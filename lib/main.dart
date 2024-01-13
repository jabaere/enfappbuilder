import 'package:applicationbuilder/firebase_options.dart';
import 'package:applicationbuilder/screens/about.dart';
import 'package:applicationbuilder/screens/instructions.dart';
import 'package:applicationbuilder/screens/login_screen.dart';
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
    await storage.ready;

    return storage.getItem('isLoggedIn') ?? false;
  }
//
  // bool isTokenExpired(String token) {
  //   DateTime tokenCreationDate = DateTime.parse('2024-01-01T00:00:00');

  //   // Calculate the expiration date (3 days from the creation date)
  //   DateTime expirationDate = tokenCreationDate.add(Duration(days: 3));

  //   // Get the current date and time
  //   DateTime currentDate = DateTime.now();

  //   // Check if the current date is after the expiration date
  //   return currentDate.isAfter(expirationDate);
  // }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //  debugShowMaterialGrid: true,
      title: 'Applicationbuilder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: colorScheme.onSurfaceVariant,
          background: colorScheme.background,
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
            return const Center(child: SizedBox(width:50,height:50, child: CircularProgressIndicator(color: Colors.teal)));
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
          style: TextStyle(color: colorScheme.surfaceVariant),
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
          IconButton(
            icon: const Icon(Icons.segment_sharp),
            color: Colors.grey[200],
            onPressed: () {
              Navigator.of(context).push(_createRoute(const About()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.grey[200],
            onPressed: () async {
              final LocalStorage storage = LocalStorage('my_app');

              // Save authentication state
              await storage.setItem('isLoggedIn', false);

              // Perform additional logout logic if needed
              await FirebaseAuth.instance.signOut();
              print('Logged out');
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(
                  onLoginSuccess: () async {
                    // Navigate to the login screen
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'აპლიკაციის გენერირება',
                        fetchData: fetchData, // Add your actual fetchData logic
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
