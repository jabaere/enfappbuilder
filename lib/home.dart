import 'package:applicationbuilder/particles/amounts.dart';
import 'package:applicationbuilder/particles/debtorInputs.dart';
import 'package:applicationbuilder/particles/orginputs.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:universal_html/html.dart' as html;
import 'package:quickalert/quickalert.dart';

//
bool isLoading = false;
bool warning = false;
//attach a GlobalKey to a DebtorInputs class,
final GlobalKey<DebtInputsState> debtInputsKey = GlobalKey<DebtInputsState>();
//
final GlobalKey<OrgInputsState> orgInputsKey = GlobalKey<OrgInputsState>();

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
  final _representativeIdController = TextEditingController();
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

  bool checkboxValueForTransition = false;
  bool checkboxValueForProperty = false;
  //
  String orgIdentifyNumberValue = '';

  final headerStyle = const TextStyle(color: Colors.teal, fontSize: 18);

  final storage = LocalStorage('app');
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
    _representativeIdController.dispose();
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
              representativeIdController: _representativeIdController,
            ),
            warning
                ? Text("არასწორი საიდენტიფიკაციო ნომერი",
                    style: TextStyle(color: Colors.red))
                : Text(''),
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
                  //debtInputsKey.currentState?.readDataFromControllers();
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true; // Set loading state
                    });

                    try {
                      await changeTextContent(
                          _orgNameController.text,
                          _orgIdController.text,
                          _orgAddressController.text,
                          debtInputsKey.currentState!.readDataFromControllers(),
                          _orgPhoneNumberController.text,
                          _orgIBanNumberController.text,
                          _orgAccuntNumberController.text,
                          _representativeNameController.text,
                          _representativeAdressController.text,
                          _representativeIdController.text,
                          _representativeNumberAndEmailController.text,
                          checkboxValueForProperty,
                          checkboxValueForTransition,
                          _textareaTextInput.text,
                          _sumOfAllAmount.text,
                          _principalAmount.text,
                          _interestAmount.text,
                          _commissionAmount.text,
                          _penaltyAmount.text,
                          _insuranceAmount.text,
                          _apliccationFeeAmount.text,
                          _foreclosureAmount.text,
                          context
                          );

                      setState(() {
                        isLoading = false; // Unset loading state
                      });

                      // QuickAlert.show(
                      //   context: context,
                      //   type: QuickAlertType.success,
                      // );

                      // _orgNameController.clear(); // Clear input
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                        // Unset loading state in case of error
                      });
                      print('Error: $e');
                      // Handle error or show error alert
                    }
                  }
                },
                child: Text(isLoading ? 'Loading...' : 'Generate',
                    style: headerStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> changeTextContent(
    String orgName,
    String orgId,
    String orgAdress,
    List debtorsData,
    String orgPhone,
    String orgIban,
    String orgAccNum,
    String representativeName,
    String representativeAdress,
    String representativeId,
    String representativephoneandmeil,
    bool addProperty,
    bool transition,
    String propertyList,
    String fullAmount,
    String loanPrincipal,
    String loanInterest,
    String comissionFee,
    String loanPenalty,
    String insuranceAmount,
    String applicationFee,
    String foreclosureFee,
    BuildContext context
    ) async {
  try {
    var storage = LocalStorage('app');
    await storage.ready;
// Load the template DOCX file
    const f = 'assets/template.docx';
    final template = await DocxTemplate.fromBytes(
        (await rootBundle.load(f)).buffer.asUint8List());
    Content content = Content();

//content logic -----------------------------------------------------------------
//set applicant name ------------------------------------------------------------

    content.add(TextContent("applicantName", orgName));

//set applicant id---------------------------------------------------------------
    void generateTextContentForApplicantId(String id, String contentName) {
      for (int i = 0; i < id.length; i++) {
        content.add(TextContent('$contentName$i', id[i]));
      }
    }

// avoid using wrong numbers of id -------------------------------------------------------

    if (orgId.length == 11 || orgId.length == 9) {
      generateTextContentForApplicantId(orgId, 'applicantId');
    } else {
// ignore: use_build_context_synchronously
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'საიდენტიფიკაციო კოდი უნდა შედგებოდეს 9/11 სიმბოლოსაგან');
      return;
    }

// set applicant address --------------------------------------------------------

    content.add(TextContent('orgaddress', orgAdress));

// set applicant number phone ---------------------------------------------------

    content.add(TextContent('orgnumber', orgPhone));

// set IBAN code ----------------------------------------------------------------

    content.add(TextContent('orgibancode', orgIban));

// set Account number -----------------------------------------------------------

    if (orgAccNum.length == 22) {
      generateTextContentForApplicantId(orgAccNum, 'orgaccountnumber');
    } else {
      // ignore: use_build_context_synchronously
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'ანგარიშის ნომერი უნდა შედგებოდეს 22 სიმბოლოსაგან');
      return;
    }
// set representative name

    if (storage.getItem('representator') == true) {
      content.add(TextContent('representativename', representativeName));
      print(representativeId.length);
      if (representativeId.length != 11) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'საიდენტიფიკაციო კოდი უნდა შედგებოდეს 11 სიმბოლოსაგან');
        return;
      }
      generateTextContentForApplicantId(
          representativeId, 'representativeidnumber');

// set address ----------------------------------------------------------------

      content.add(TextContent('representativeaddress', representativeAdress));
      content.add(TextContent(
          'representativephoneandemail', representativephoneandmeil));
    }

// set conditions -------------------------------------------------------------

    if (debtorsData.length > 1) {
      content.add(TextContent('solidarydemantNo', '\u2713'));
      content.add(TextContent('severalLiabilityYes', '\u2713'));
    } else {
      content.add(TextContent('solidarydemantNo', '\u2713'));
      content.add(TextContent('severalLiabilityNo', '\u2713'));
    }

//  -------------------------------------------------------------

    content.add(TextContent('reciprocalbligationNo', '\u2713'));

//  -------------------------------------------------------------
    if (addProperty == true) {
      content.add(TextContent('tobeenforcedYes', '\u2713'));
      content.add(TextContent('foreclosureYes', '\u2713'));
// property list
      content.add(PlainContent('propertyList')..add(TextContent('property', propertyList)));
    } else {
      //content.add(TextContent('tobeenforcedNo', '\u2713'));
      content.add(TextContent('foreclosureNo', '\u2713'));
    }
//
    if (transition == true) {
      content.add(TextContent('tobeenforcedYes', '\u2713'));
    } else {
      content.add(TextContent('tobeenforcedNo', '\u2713'));
    }

// set loan full amount
    content.add(TextContent('requestSum', fullAmount));
// set loan principal
    content.add(TextContent('loanPrincipal', loanPrincipal));

// set loan interest and comission fee
    content.add(TextContent('loanInterest', loanInterest));
    int.parse(comissionFee) != 0 ?
    content.add(TextContent('IssuanceFee', comissionFee))
    :
    content.add(TextContent('IssuanceFee', ''));
// set loan penalty and insurance fee
   content.add(TextContent('loanPenalty', loanPenalty));
   content.add(TextContent('insuranceCommission', insuranceAmount));
// set application fee
    
   content.add(TextContent('applicationFee', applicationFee));
  

// set foreclosure fee
   content.add(TextContent('foreclosureFee', foreclosureFee));

// application creation time  ---------------------------------------------------

    DateTime now = DateTime.now();
    String formattedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    content.add(TextContent('writeDate', formattedDate));

//

// set debtor info --------------------------------------------------------------

    List<Content> localContent = [];

// Loop through debtorsData and add each element as separate content

    for (int j = 0; j < debtorsData.length; j++) {
      var e = debtorsData[j];
      localContent.add(TextContent('debtor', e));
    }
//  Add a list to the view.

    content.add(ListContent("debtorList", localContent));

//   

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
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
    );
  } catch (e) {
    print('Error modifying DOCX file: $e');
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
    );
  }
}
