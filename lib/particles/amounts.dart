import 'package:applicationbuilder/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Amounts extends StatefulWidget {
  final TextEditingController sumOfAllAmount;
  final TextEditingController principalAmount;
  final TextEditingController interestAmount;
  final TextEditingController penaltyAmount;
  final TextEditingController insuranceAmount;
  final TextEditingController commissionAmount;
  final TextEditingController apliccationFeeAmount;
  final TextEditingController foreclosureAmount;
  
 final bool foreclosureAmountTrue;
  
  const Amounts({
    Key?key,
    required this.sumOfAllAmount,
    required this.principalAmount,
    required this.interestAmount,
    required this.penaltyAmount,
    required this.insuranceAmount,
    required this.commissionAmount,
    required this.apliccationFeeAmount,
    required this.foreclosureAmount,
    required this.foreclosureAmountTrue,
  }) : super(key: key);

  @override
  State<Amounts> createState() => _AmountsState();
}

class _AmountsState extends State<Amounts> {
  var ct =  debtInputsKey.currentState;
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Wrap(
        spacing: 10.0, // Horizontal spacing between fields
        runSpacing: 10.0, // Vertical spacing between lines
        alignment: isSmallScreen ? WrapAlignment.center : WrapAlignment.start,
        children: [
          ..._buildTwoRowsFormFields(),
        
          ct!.smallGap,
  
        ],
      ),
    );
  }

    List<Widget> _buildTwoRowsFormFields() {
    return [
   
      _buildField(
          'სრული მოთხოვნა', widget.sumOfAllAmount),
      _buildField(
          'ძირი', widget.principalAmount),
    _buildField(
          'სარგებელი', widget.interestAmount),
           _buildField(
          'პირგასამტეხლო', widget.penaltyAmount),
           _buildField(
          'დაზღვევა', widget.insuranceAmount),
          _buildField(
          'საკომისიო', widget.commissionAmount),
           _buildField(
          'სააპლიკაციო საფასური', widget.apliccationFeeAmount),
        widget.foreclosureAmountTrue ?  _buildField(
          'ყადაღის საფასური', widget.foreclosureAmount) : Container(),

    ];
  }
    Widget _buildField(
      String labelText, TextEditingController controller) {
    //print('Building field for $labelText with enabled state: $enabled');
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
            keyboardType: TextInputType.number,
               inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')), // Allow only digits
              ],
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