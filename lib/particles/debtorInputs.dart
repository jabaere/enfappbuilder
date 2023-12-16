import 'package:flutter/material.dart';

class DebtInputs extends StatefulWidget {
  const DebtInputs({Key? key}) : super(key: key);

  @override
  State<DebtInputs> createState() => DebtInputsState();
}

class DebtInputsState extends State<DebtInputs> {
  final List<TextEditingController> _controllers = [];
  final List<Widget> _fields = [];
  final smallGap = const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            // Display the existing fields
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.start,
              children: [
                Column(
                  children: _fields,
                ),
              ],
            ),
            smallGap, // Add spacing
            ElevatedButton(
              onPressed: () {
                // Add a new field on button press
                setState(() {
                  _fields.add(_buildField('მოვალე - ${_fields.length+1}'));
                });
              },
              child: const SizedBox(
                width: 102,
                child: Row(
                  children: [
                    Text('დამატება'),
                    SizedBox(width: 5),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String labelText) {
    final TextEditingController controller = TextEditingController();
    _controllers.add(controller); // Add the new controller to the list

    return Column(
      children: [
        SizedBox(
          width: 250,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
              labelText: labelText,
              labelStyle: const TextStyle(fontSize: 12),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: const Color.fromARGB(255, 240, 235, 235),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'შეიყვანეთ $labelText';
              }
              return null;
            },
          ),
        ),
        smallGap
      ],
    );
  }
    void readDataFromControllers() {
    for (TextEditingController controller in _controllers) {
      String text = controller.text;
      //print("Text from controller: $text");
      print(_controllers[2].text);
    }
  }
}
