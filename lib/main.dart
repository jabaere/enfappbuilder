import 'package:applicationbuilder/screens/instructions.dart';
import 'package:flutter/material.dart';
import 'package:applicationbuilder/home.dart';
import 'package:applicationbuilder/screens/upload.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
      home: const MyHomePage(title: 'აპლიკაციის/გადახდების გენერაცია'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Widget getPage() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return UploadScreen();
      default:
        throw UnimplementedError("Page not found");
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

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
        
        title: Center(child: Text(widget.title,style: TextStyle(color: colorScheme.surfaceVariant),)),
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
              Navigator.of(context).push(_createRoute(UploadScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.integration_instructions),
            color: Colors.grey[200],
            onPressed: () {
              Navigator.of(context).push(_createRoute(const InstructionsScreen()));
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.transparent,
        child: getPage(),
      ),
    );
  }
}
