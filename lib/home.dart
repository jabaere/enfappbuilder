import 'package:applicationbuilder/particles/amounts.dart';
import 'package:applicationbuilder/particles/debtor_inputs.dart';
import 'package:applicationbuilder/particles/orginputs.dart';
import 'package:applicationbuilder/services/docx_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:universal_html/html.dart' as html;
import 'package:quickalert/quickalert.dart';

bool isLoading = false;
bool warning = false;
final GlobalKey<DebtInputsState> debtInputsKey = GlobalKey<DebtInputsState>();
final GlobalKey<OrgInputsState> orgInputsKey = GlobalKey<OrgInputsState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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

  final _sumOfAllAmount = TextEditingController();
  final _principalAmount = TextEditingController();
  final _interestAmount = TextEditingController();
  final _penaltyAmount = TextEditingController();
  final _insuranceAmount = TextEditingController();
  final _commissionAmount = TextEditingController();
  final _apliccationFeeAmount = TextEditingController();
  final _foreclosureAmount = TextEditingController();
  final _textareaTextInput = TextEditingController();

  bool checkboxValueForTransition = false;
  bool checkboxValueForProperty = false;
  final storage = LocalStorage('app');

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
    _textareaTextInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000), // Max width for large screens
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              // 1. Applicant Section
              _SectionCard(
                title: 'აპლიკანტი',
                icon: Icons.business_center_rounded,
                child: Column(
                  children: [
                    OrgInputs(
                      orgNameController: _orgNameController,
                      orgIdController: _orgIdController,
                      orgAddressController: _orgAddressController,
                      orgPhoneNumberController: _orgPhoneNumberController,
                      orgIBanNumberController: _orgIBanNumberController,
                      orgAccuntNumberController: _orgAccuntNumberController,
                      representativeNameController: _representativeNameController,
                      representativeAdressController: _representativeAdressController,
                      representativeNumberAndEmailController: _representativeNumberAndEmailController,
                      representativeIdController: _representativeIdController,
                    ),
                    if (warning)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text("არასწორი საიდენტიფიკაციო ნომერი",
                            style: TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
                      ),
                  ],
               ),
              ),
              const SizedBox(height: 24),

              // 2. Debtors Section
              _SectionCard(
                title: 'მოვალე',
                icon: Icons.people_alt_rounded,
                child: DebtInputs(key: debtInputsKey),
              ),
              const SizedBox(height: 24),

              // 3. Document Options (Checkboxes)
              _SectionCard(
                title: 'პარამეტრები',
                icon: Icons.tune_rounded,
                child: Wrap(
                  spacing: 32,
                  runSpacing: 16,
                  children: [
                    _ActionCheckbox(
                      label: 'აღსასრულებლად მიქცევა',
                      value: checkboxValueForTransition,
                      onChanged: (v) => setState(() => checkboxValueForTransition = v ?? false),
                    ),
                    _ActionCheckbox(
                      label: 'ყადაღა',
                      value: checkboxValueForProperty,
                      onChanged: (v) => setState(() {
                        checkboxValueForProperty = v ?? false;
                        checkboxValueForTransition = v ?? false;
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Amounts Section
              _SectionCard(
                title: 'თანხები',
                icon: Icons.account_balance_wallet_rounded,
                child: Amounts(
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
              ),
              const SizedBox(height: 24),

              // 5. Property Section (Conditionally shown)
              if (checkboxValueForProperty)
                _SectionCard(
                  title: 'ქონება',
                  icon: Icons.real_estate_agent_rounded,
                  child: TextFormField(
                    controller: _textareaTextInput,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      hintText: "სახელი გვარი პ/ნ 000000000\nსაკადასტრო კოდი",
                      alignLabelWithHint: true,
                    ),
                  ),
                ),

              const SizedBox(height: 48),

              // Generate Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: isLoading ? null : _handleGenerate,
                  child: isLoading
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('დოკუმენტის გენერირება',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGenerate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        await changeTextContent(
          orgName: _orgNameController.text,
          orgId: _orgIdController.text,
          orgAdress: _orgAddressController.text,
          debtorsData: debtInputsKey.currentState!.readDataFromControllers(),
          orgPhone: _orgPhoneNumberController.text,
          orgIban: _orgIBanNumberController.text,
          orgAccNum: _orgAccuntNumberController.text,
          representativeName: _representativeNameController.text,
          representativeAdress: _representativeAdressController.text,
          representativeId: _representativeIdController.text,
          representativephoneandmeil: _representativeNumberAndEmailController.text,
          addProperty: checkboxValueForProperty,
          transition: checkboxValueForTransition,
          propertyList: _textareaTextInput.text,
          fullAmount: _sumOfAllAmount.text,
          loanPrincipal: _principalAmount.text,
          loanInterest: _interestAmount.text,
          comissionFee: _commissionAmount.text,
          loanPenalty: _penaltyAmount.text,
          insuranceAmount: _insuranceAmount.text,
          applicationFee: _apliccationFeeAmount.text,
          foreclosureFee: _foreclosureAmount.text,
          context: context,
        );
      } catch (e) {
        print('Error: $e');
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }
}

// ─── UI Primitives ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: const Color(0xFF4F46E5)),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class _ActionCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _ActionCheckbox({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: value, onChanged: onChanged),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
          ],
        ),
      ),
    );
  }
}

// ─── Document Generation Logic ──────────────────────────────────────────────

Future<void> changeTextContent({
  required String orgName,
  required String orgId,
  required String orgAdress,
  required List debtorsData,
  required String orgPhone,
  required String orgIban,
  required String orgAccNum,
  required String representativeName,
  required String representativeAdress,
  required String representativeId,
  required String representativephoneandmeil,
  required bool addProperty,
  required bool transition,
  required String propertyList,
  required String fullAmount,
  required String loanPrincipal,
  String loanInterest = '0',
  String comissionFee = '0',
  String loanPenalty = '0',
  String insuranceAmount = '0',
  required String applicationFee,
  required String foreclosureFee,
  required BuildContext context,
}) async {
  try {
    orgName = orgName.trim();
    orgId = orgId.trim();
    orgAdress = orgAdress.trim();
    orgPhone = orgPhone.trim();
    orgIban = orgIban.trim();
    orgAccNum = orgAccNum.trim();
    representativeName = representativeName.trim();
    representativeAdress = representativeAdress.trim();
    representativeId = representativeId.trim();
    representativephoneandmeil = representativephoneandmeil.trim();
    loanPrincipal = loanPrincipal.trim();
    loanInterest = loanInterest.trim();
    comissionFee = comissionFee.trim();
    loanPenalty = loanPenalty.trim();
    insuranceAmount = insuranceAmount.trim();
    applicationFee = applicationFee.trim();
    foreclosureFee = foreclosureFee.trim();
    
    var storage = LocalStorage('app');
    await storage.ready;

    var debtorName = 'generated';
    final String square = ' \u25A1 '; // □
    final String checkmark = ' \u2713 '; // ✓

    // Validation
    if (orgId.length != 11 && orgId.length != 9) {
      QuickAlert.show(context: context, type: QuickAlertType.error, text: 'საიდენტიფიკაციო კოდი უნდა შედგებოდეს 9/11 სიმბოლოსაგან');
      return;
    }
    if (orgAccNum.length != 22) {
      QuickAlert.show(context: context, type: QuickAlertType.error, text: 'ანგარიშის ნომერი უნდა შედგებოდეს 22 სიმბოლოსაგან');
      return;
    }
    if (storage.getItem('representator') == true && representativeId.length != 11) {
      QuickAlert.show(context: context, type: QuickAlertType.error, text: 'საიდენტიფიკაციო კოდი უნდა შედგებოდეს 11 სიმბოლოსაგან');
      return;
    }

    if (loanPrincipal.startsWith('0') && loanPrincipal.length > 1 ||
        loanInterest.startsWith('0') && loanInterest.length > 1 ||
        comissionFee.startsWith('0') && comissionFee.length > 1 ||
        loanPenalty.startsWith('0') && loanPenalty.length > 1 ||
        insuranceAmount.startsWith('0') && insuranceAmount.length > 1 ||
        applicationFee.startsWith('0') && applicationFee.length > 1 ||
        addProperty == true && foreclosureFee.startsWith('0') && foreclosureFee.length > 1) {
      QuickAlert.show(context: context, type: QuickAlertType.error, text: 'არასწორი რიცხვი');
      return;
    }

    // Build values
    final Map<String, String> textValues = {};
    textValues['applicantName'] = orgName;
    for (int i = 0; i < orgId.length; i++) textValues['applicantId$i'] = orgId[i];
    textValues['orgaddress'] = orgAdress;
    textValues['orgnumber'] = orgPhone;
    textValues['orgibancode'] = orgIban;
    for (int i = 0; i < orgAccNum.length; i++) textValues['orgaccountnumber$i'] = orgAccNum[i];

    if (storage.getItem('representator') == true) {
      textValues['representativename'] = representativeName;
      for (int i = 0; i < representativeId.length; i++) textValues['representativeidnumber$i'] = representativeId[i];
      textValues['representativeaddress'] = representativeAdress;
      textValues['representativephoneandemail'] = representativephoneandmeil;
    }

    if (debtorsData.length > 1) {
      textValues['solidarydemantNo'] = checkmark;
      textValues['solidarydemantYes'] = square;
      textValues['severalLiabilityYes'] = checkmark;
      textValues['severalLiabilityNo'] = square;
    } else {
      textValues['solidarydemantNo'] = checkmark;
      textValues['solidarydemantYes'] = square;
      textValues['severalLiabilityNo'] = checkmark;
      textValues['severalLiabilityYes'] = square;
    }

    textValues['reciprocalbligationNo'] = checkmark;
    textValues['reciprocalbligationYes'] = square;

    if (addProperty) {
      textValues['foreclosureYes'] = checkmark;
      textValues['foreclosureNo'] = square;
    } else {
      textValues['foreclosureNo'] = checkmark;
      textValues['foreclosureYes'] = square;
    }

    if (transition) {
      textValues['tobeenforcedYes'] = checkmark;
      textValues['tobeenforcedNo'] = square;
    } else {
      textValues['tobeenforcedNo'] = checkmark;
      textValues['tobeenforcedYes'] = square;
    }

    final double totalAmount = double.parse(loanPrincipal) +
        double.parse(loanInterest) +
        double.parse(comissionFee) +
        double.parse(loanPenalty) +
        double.parse(insuranceAmount) +
        double.parse(applicationFee) +
        double.parse(addProperty ? foreclosureFee : '0');
    
    textValues['requestSum'] = '${totalAmount.toStringAsFixed(2)} ლარი';
    textValues['loanPrincipal'] = '$loanPrincipal ლარი';
    textValues['loanInterest'] = loanInterest != '0' ? '$loanInterest ლარი' : '';
    textValues['IssuanceFee'] = comissionFee != '0' ? 'საკომისიო $comissionFee ლარი' : '';
    textValues['loanPenalty'] = loanPenalty != '0' ? '$loanPenalty ლარი' : '';
    textValues['insuranceCommission'] = insuranceAmount != '0' ? 'სიცოცხლის დაზღვევა - $insuranceAmount ლარი' : '';
    textValues['applicationFee'] = 'სააპლიკაციო საფასური - $applicationFee ლარი';
    textValues['foreclosureFee'] = addProperty ? 'ყადაღის რეგისტრაციის საფასური - $foreclosureFee ლარი' : '';

    final DateTime now = DateTime.now();
    textValues['writeDate'] = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

    final List<String> debtorList = debtorsData.map((e) => e.toString()).toList();
    if (debtorList.isNotEmpty && (debtorList[0].contains('პ/ნ') || debtorList[0].contains('პ.ნ') || debtorList[0].contains('პნ'))) {
      final idx = debtorList[0].indexOf('პ/ნ');
      debtorName = idx != -1 ? debtorList[0].substring(0, idx) : debtorName;
    }

    final List<String> propertyLines = addProperty ? propertyList.split('\n') : [];

    const templatePath = 'assets/template.docx';
    final templateBytes = (await rootBundle.load(templatePath)).buffer.asUint8List();

    final modifiedDocxBytes = DocxService.fillContentControls(
      templateBytes: templateBytes,
      textValues: textValues,
      debtorItems: debtorList,
      propertyLines: propertyLines,
    );

    final blob = html.Blob([modifiedDocxBytes], 'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'აპლიკაცია $debtorName.docx')
      ..click();
    html.Url.revokeObjectUrl(url);

    // ignore: use_build_context_synchronously
    QuickAlert.show(context: context, type: QuickAlertType.success);
  } catch (e) {
    print('Error modifying DOCX file: $e');
    // ignore: use_build_context_synchronously
    QuickAlert.show(context: context, type: QuickAlertType.error);
  }
}
