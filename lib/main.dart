import 'package:applicationbuilder/screens/about.dart';
import 'package:applicationbuilder/screens/instructions.dart';
import 'package:flutter/material.dart';
import 'package:applicationbuilder/home.dart';
import 'package:applicationbuilder/screens/upload.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // Simulating fetching data asynchronously
  Future<void> fetchData() {
    return Future.delayed(const Duration(seconds: 2));
  }

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
      home: MyHomePage(title: 'აპლიკაციის გენერირება', fetchData: fetchData),
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
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.teal,),
              )
            : getPage(),
      ),
    );
  }
}
