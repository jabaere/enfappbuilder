import 'package:applicationbuilder/particles/amounts.dart';
import 'package:applicationbuilder/particles/debtorInputs.dart';
import 'package:applicationbuilder/particles/orginputs.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'package:quickalert/quickalert.dart';

//
bool isLoading = false;
//attach a GlobalKey to a DebtorInputs class,
final GlobalKey<DebtInputsState> debtInputsKey = GlobalKey<DebtInputsState>();
//

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double btnWidt = 250;
  double btnHeight = 52;

  final _formKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _orgIdController = TextEditingController();
  final _orgAddressController = TextEditingController();
  final _orgPhoneNumberController = TextEditingController();
  final _orgIBanNumberController = TextEditingController();
  final _orgAccuntNumberController = TextEditingController();
  final _representativeNameController = TextEditingController();
  final _representativeAdressController = TextEditingController();
  final _representativeNumberAndEmailController = TextEditingController();
  //
  final _sumOfAllAmount = TextEditingController();
  final _principalAmount = TextEditingController();
  final _interestAmount = TextEditingController();
  final _penaltyAmount = TextEditingController();
  final _insuranceAmount = TextEditingController();
  final _commissionAmount = TextEditingController();
  final _apliccationFeeAmount = TextEditingController();
  final _foreclosureAmount = TextEditingController();

  //
  final _textareaTextInput = TextEditingController();

  final List<String> _debtorInfo = [];
  bool checkboxValueForTransition = false;
  bool checkboxValueForProperty = false;
  //
  String orgIdentifyNumberValue = '';

  final headerStyle = const TextStyle(color: Colors.teal, fontSize: 18);
  // List<String> userIdentifyInputValues = List.generate(11, (index) => '');

  // void updateInputValue(int index, String value) {
  //   setState(() {
  //     userIdentifyInputValues[index] = value;
  //   });
  // }
  @override
  void dispose() {
    _orgNameController.dispose();
    _orgIdController.dispose();
    _orgAddressController.dispose();
    _orgPhoneNumberController.dispose();
    _orgIBanNumberController.dispose();
    _orgAccuntNumberController.dispose();
    _representativeNameController.dispose();
    _representativeAdressController.dispose();
    _representativeNumberAndEmailController.dispose();
    _sumOfAllAmount.dispose();
    _principalAmount.dispose();
    _interestAmount.dispose();
    _penaltyAmount.dispose();
    _insuranceAmount.dispose();
    _commissionAmount.dispose();
    _apliccationFeeAmount.dispose();
    _foreclosureAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Text(
                  'ინფორმაცია აპლიკანტის შესახებ',
                  style: headerStyle,
                ),
              ),
            ),
            OrgInputs(
              orgNameController: _orgNameController,
              orgIdController: _orgIdController,
              orgAddressController: _orgAddressController,
              orgPhoneNumberController: _orgPhoneNumberController,
              orgIBanNumberController: _orgIBanNumberController,
              orgAccuntNumberController: _orgAccuntNumberController,
              representativeNameController: _representativeNameController,
              representativeAdressController: _representativeAdressController,
              representativeNumberAndEmailController:
                  _representativeNumberAndEmailController,
            ),
            Center(
              child: Text('ინფორმაცია მოვალის შესახებ', style: headerStyle),
            ),
            DebtInputs(key: debtInputsKey),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: checkboxValueForTransition,
                        onChanged: (newValue) {
                          // Update the checkbox state using the ValueNotifier
                          setState(() {
                            checkboxValueForTransition = newValue ?? false;
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text('აღსასრულებლად მიქცევა'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: checkboxValueForProperty,
                        onChanged: (newValue) {
                          // Update the checkbox state using the ValueNotifier

                          setState(() {
                            checkboxValueForProperty = newValue ?? false;
                          });
                        },
                      ),
                      const SizedBox(width: 5),
                      const Text('ყადაღა'),
                    ],
                  )
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Text('ინფორმაცია თანხებზე', style: headerStyle),
              ),
            ),
            Amounts(
              sumOfAllAmount: _sumOfAllAmount,
              principalAmount: _principalAmount,
              interestAmount: _interestAmount,
              penaltyAmount: _penaltyAmount,
              insuranceAmount: _insuranceAmount,
              commissionAmount: _commissionAmount,
              apliccationFeeAmount: _apliccationFeeAmount,
              foreclosureAmount: _foreclosureAmount,
              foreclosureAmountTrue: checkboxValueForProperty,
            ),
            checkboxValueForProperty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        children: [
                          Text('ინფორმაცია ქონებაზე', style: headerStyle),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 12.0), // Adjust padding as needed
                            child: TextFormField(
                              controller: _textareaTextInput,
                              maxLines: 8, //or null
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 12.0),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Color.fromARGB(255, 240, 235, 235),
                                hintStyle: TextStyle(fontSize: 12),
                                hintText:
                                    " სახელი გვარი პ/ნ 000000000  \n საკადასტრო კოდი",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
// Other Form Fields...

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 140),
              child: ElevatedButton(
                onPressed: () async {
                  //debtInputsKey.currentState?.readDataFromControllers();
                 // print(_textareaTextInput.text);
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true; // Set loading state
                    });

                    try {
                      await changeTextContent(
                        _orgNameController.text,
                        _orgIdController.text,
                      );

                      setState(() {
                        isLoading = false; // Unset loading state
                      });

                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                      );

                      _orgNameController.clear(); // Clear input
                    } catch (e) {
                      setState(() {
                        isLoading =
                            false; // Unset loading state in case of error
                      });
                      print('Error: $e');
                      // Handle error or show error alert
                    }
                  }
                },
                child: Text(isLoading ? 'Loading...' : 'Generate',style: headerStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> changeTextContent(String orgName, String orgId) async {
  try {
    // Load the template DOCX file
    const f = 'assets/template.docx';
    final template = await DocxTemplate.fromBytes(
        (await rootBundle.load(f)).buffer.asUint8List());
    Content content = Content();

    content.add(TextContent("username", orgName));
    content.add(TextContent("ara", '\u2713'));

    // Apply the replacements
    final modifiedDocxBytes = await template.generate(content);

    // Create a Blob and generate a download link
    final blob = html.Blob(
        [Uint8List.fromList(modifiedDocxBytes!)], 'application/msword');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "generated.docx")
      ..click();

    // Clean up resources

    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print('Error modifying DOCX file: $e');
  }
}
