import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  final headerStyle = const TextStyle(color: Colors.teal, fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[200]),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.start,
              direction: constraints.maxWidth < 600 ? Axis.vertical : Axis.horizontal,
              children: [
                buildContent('მოხმარების წესები',['gdhgh','dsadsa']),
                buildContent('ტექნიკური ინფორმაცია',['mmmmm','dddd']),
                // Add more content as needed
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(String title,List<String> about) {
    
    Widget item;

    for(String i in about){
        item = Text(i);
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 100),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headerStyle),
          SizedBox(height: 5),
         Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: about.map((item) => Text(item)).toList(),
          ),
         
          
          // Add more text or content here...
        ],
      ),
    );
  }
}
