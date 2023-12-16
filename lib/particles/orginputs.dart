import 'package:flutter/material.dart';

class OrgInputs extends StatefulWidget {
  final TextEditingController orgNameController;
  final TextEditingController orgIdController;
  final TextEditingController orgAddressController;
  final TextEditingController orgPhoneNumberController;
  final TextEditingController orgIBanNumberController;
  final TextEditingController orgAccuntNumberController;
  final TextEditingController representativeNameController;
  final TextEditingController representativeAdressController;
  final TextEditingController representativeNumberAndEmailController;

  const OrgInputs({
    Key? key,
    required this.orgNameController,
    required this.orgIdController,
    required this.orgAddressController,
    required this.orgPhoneNumberController,
    required this.orgIBanNumberController,
    required this.orgAccuntNumberController,
    required this.representativeNameController,
    required this.representativeAdressController,
    required this.representativeNumberAndEmailController,
  }) : super(key: key);

  @override
  _OrgInputsState createState() => _OrgInputsState();
}

class _OrgInputsState extends State<OrgInputs> {
  final smallGap = const SizedBox(height: 20);
  // Create a ValueNotifier to hold the checkbox state
  bool isSaveCheckboxValue = false;
  bool isRepresentative = true;
  bool isInputOn = true;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Adjust this breakpoint as needed

    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Wrap(
        spacing: 10.0, // Horizontal spacing between fields
        runSpacing: 10.0, // Vertical spacing between lines
        alignment: isSmallScreen ? WrapAlignment.center : WrapAlignment.start,
        children: [
          ..._buildTwoRowsFormFields(),
          Row(
            children: [
              Checkbox(
                value: isRepresentative,
                onChanged: (newValue) {
                  // Update the checkbox state using the ValueNotifier
                  setState(() {
                    isRepresentative = newValue ?? false;
                  });
                  print(isRepresentative);
                },
              ),
              const Text('წარმომადგენელი')
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: isSaveCheckboxValue,
                onChanged: (newValue) {
                  // Update the checkbox state using the ValueNotifier
                  setState(() {
                    isSaveCheckboxValue = newValue ?? false;
                  });
                  print(isSaveCheckboxValue);
                },
              ),
              const Text('ინფორმაციის დამახსოვრება')
            ],
          ),
                smallGap,
  
        ],
      ),
    );
  }

  List<Widget> _buildTwoRowsFormFields() {
    return [
     
      _buildField(
          'აპლიკანტის დასახელება', widget.orgNameController, isSaveCheckboxValue),
      _buildField('აპლიკანტის საიდენტიფიკაციო კოდი', widget.orgIdController,
          isSaveCheckboxValue),
      _buildField(
          'აპლიკანტის მისამართი', widget.orgAddressController, isSaveCheckboxValue),
      _buildField('აპლიკანტის ტელეფონის ნომერი',
          widget.orgPhoneNumberController, isSaveCheckboxValue),
      _buildField(
          'IBAN - ნომერი', widget.orgIBanNumberController, isSaveCheckboxValue),
      _buildField('აპლიკანტის ანგარიშის ნომერი',
          widget.orgAccuntNumberController, isSaveCheckboxValue),
      isRepresentative? Wrap(
        spacing: 10.0, // Horizontal spacing between fields
        runSpacing: 10.0, // Vertical spacing between lines
        //alignment: isSmallScreen ? WrapAlignment.center : WrapAlignment.start,
        children: [
          _buildField(
              'წარმომადგენელი', widget.representativeNameController, isSaveCheckboxValue),
          _buildField('წარმომადგენლის მისამართი',
              widget.representativeAdressController, isSaveCheckboxValue),
          _buildField('წარმომადგენლის Phone & Email',
              widget.representativeNumberAndEmailController, isSaveCheckboxValue),
        ],
      ):Container()

    ];
  }

  Widget _buildField(
      String labelText, TextEditingController controller, bool enabled) {
    //print('Building field for $labelText with enabled state: $enabled');
    return Column(
      children: [
        SizedBox(
          width: 250,
          child: TextFormField(
            enabled: !enabled,
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
      ],
    );
  }
}
