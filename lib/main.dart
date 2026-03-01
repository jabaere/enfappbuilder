import 'dart:async';
import 'package:applicationbuilder/firebase_options.dart';
import 'package:applicationbuilder/screens/instructions.dart';
import 'package:applicationbuilder/screens/login_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:applicationbuilder/home.dart';
import 'package:applicationbuilder/screens/upload.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  //firebase_analytics
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  await analytics.logEvent(
    name: 'app_open',
    parameters: <String, dynamic>{
      'screen': 'login_screen',
    },
  );

//reset user state after 5 days
  // final LocalStorage storage = LocalStorage('my_app');
  // Timer.periodic(const Duration(minutes: 7200), (timer) async {
  //   await storage.setItem('isLoggedIn', false);
  //   await storage.setItem('token', '');
  
  //   await FirebaseAuth.instance.signOut();

  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Simulating fetching data asynchronously
  Future<void> fetchData() {
    return Future.delayed(const Duration(seconds: 2));
  }

  Future<bool> checkUserAuthenticationState() async {
    final LocalStorage storage = LocalStorage('my_app');
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    await storage.ready;

    if (user == null){
       await storage.setItem('isLoggedIn', false);
       await storage.setItem('token', '');
    }

    if (user == null) return false;

    return storage.getItem('isLoggedIn') &&
            user.refreshToken == storage.getItem('token') ||
        false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Applicationbuilder',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            side: BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
          errorStyle: const TextStyle(fontSize: 11),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return const Color(0xFF4F46E5);
            return Colors.white;
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4F46E5),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      home: FutureBuilder<bool>(
        future: checkUserAuthenticationState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF4F46E5),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48, height: 48,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 3),
                    ),
                    SizedBox(height: 20),
                    Text('იტვირთება...', style: TextStyle(
                      color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            );
          }
          return snapshot.data == true
              ? MyHomePage(title: 'აპლიკაციის გენერირება', fetchData: fetchData)
              : LoginScreen(onLoginSuccess: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      title: 'აპლიკაციის გენერირება', fetchData: fetchData),
                  ));
                });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.fetchData})
      : super(key: key);
  final Future<void> Function() fetchData;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _selectedIndex = 0;
  bool isLoading = true;
  Future<void> fetchData() {
    return Future.delayed(const Duration(seconds: 2));
  }

  Widget getPage() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      // case 1:
      //   return const UploadScreen();
      // case 2:
      //   return const About();
      default:
        throw UnimplementedError("Page not found");
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-2.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.bounceInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await widget.fetchData();
    setState(() {
      isLoading = false;
    });
  }

  // void _navigateToScreen(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _AppBarButton(
            icon: Icons.cloud_upload_outlined,
            tooltip: 'ატვირთვა',
            onTap: () => Navigator.of(context).push(_createRoute(const UploadScreen())),
          ),
          _AppBarButton(
            icon: Icons.help_outline_rounded,
            tooltip: 'ინსტრუქცია',
            onTap: () => Navigator.of(context).push(_createRoute(const InstructionsScreen())),
          ),
          _AppBarButton(
            icon: Icons.logout_rounded,
            tooltip: 'გასვლა',
            onTap: () async {
              final LocalStorage storage = LocalStorage('my_app');
              await storage.setItem('isLoggedIn', false);
              await storage.setItem('token', '');
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(
                  onLoginSuccess: () async {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'აპლიკაციის გენერირება',
                        fetchData: fetchData,
                      ),
                    ));
                  },
                ),
              ));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
            )
          : getPage(),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _AppBarButton({required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Icon(icon, color: Colors.white.withOpacity(0.9), size: 22),
        ),
      ),
    );
  }
}
