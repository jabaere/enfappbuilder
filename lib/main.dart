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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //  debugShowMaterialGrid: true,
      title: 'Applicationbuilder',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
        seedColor: colorScheme.onSurfaceVariant,
        surface: colorScheme.onSurface,
      // ···
        brightness: Brightness.light,
    ),
    
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.onSurfaceVariant,
        ),
      ),
      home: FutureBuilder<bool>(
        future: checkUserAuthenticationState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking authentication status
            return const Center(
                child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(color: Colors.teal)));
          } else {
            // Decide which screen to show based on the authentication status
            return snapshot.data == true
                ? MyHomePage(
                    title: 'აპლიკაციის გენერირება',
                    fetchData: fetchData, // Add your actual fetchData logic
                  )
                : LoginScreen(onLoginSuccess: () {
                    // Reload the widget when the user successfully logs in
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'აპლიკაციის გენერირება',
                        fetchData: fetchData, // Add your actual fetchData logic
                      ),
                    ));
                  });
          }
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: colorScheme.surfaceContainerHighest),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.access_time),
          //   onPressed: () {
          //     Navigator.of(context).push(_createRoute(InputWidget()));
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.upload),
            color: Colors.grey[200],
            onPressed: () {
              Navigator.of(context).push(_createRoute(const UploadScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded),
            color: Colors.grey[200],
            onPressed: () {
              Navigator.of(context)
                  .push(_createRoute(const InstructionsScreen()));
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.segment_sharp),
          //   color: Colors.grey[200],
          //   onPressed: () {
          //     Navigator.of(context).push(_createRoute(const About()));
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.grey[200],
            onPressed: () async {
              final LocalStorage storage = LocalStorage('my_app');

              // Save authentication state
              await storage.setItem('isLoggedIn', false);
              await storage.setItem('token', '');
              //
              await FirebaseAuth.instance.signOut();
              
              print('Logged out');
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(
                  onLoginSuccess: () async {
                    // Navigate to the login screen
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
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              )
            : getPage(),
      ),
    );
  }
}
