import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class OrgInputs extends StatefulWidget {
  final TextEditingController orgNameController;
  final TextEditingController orgIdController;
  final TextEditingController orgAddressController;
  final TextEditingController orgPhoneNumberController;
  final TextEditingController orgIBanNumberController;
  final TextEditingController orgAccuntNumberController;
  final TextEditingController representativeNameController;
  final TextEditingController representativeIdController;
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
    required this.representativeIdController,
  }) : super(key: key);

  @override
  OrgInputsState createState() => OrgInputsState();
}

class OrgInputsState extends State<OrgInputs> {
  final smallGap = const SizedBox(height: 20);
  // Create a ValueNotifier to hold the checkbox state
  bool isSaveCheckboxValue = false;
  bool isRepresentative = true;
  bool isInputOn = true;

  //localstorage variables
  late LocalStorage storage;
  String? organizationName;
  String? organizationId;
  String? organizationAddress;
  String? organizationNumber;
  String? organizationBankIbanNumber;
  String? organizationBanckAccount;
  String? organizationRepresentatorName;
  String? organizationRepresentatorIdNumber;
  String? organizationRepresentatorAdress;
  String? organizationRepresentatorInfo;
  bool? saveData;
  bool? representative;

  @override
  void initState() {
    super.initState();
    initializeStorage();
  }

  //fetch data from localstorage
  Future<void> initializeStorage() async {
    storage = LocalStorage('app');
    await storage.ready;
    setState(() {
      //checkbox data
      storage.setItem('representator', true);
      saveData = storage.getItem('saveData');
      representative = storage.getItem('representator');
      isRepresentative = representative ?? true;
      isSaveCheckboxValue = saveData ?? false;
      //other inputs
      organizationName = storage.getItem('organizationName');
      organizationId = storage.getItem('organizationId');
      organizationAddress = storage.getItem('organizationAddress');
      organizationNumber = storage.getItem('organizationNumber');
      organizationBankIbanNumber =
          storage.getItem('organizationBankIbanNumber');
      organizationBanckAccount = storage.getItem('organizationBanckAccount');
      //------------------------------------------------------
      widget.orgNameController.text = organizationName ?? '';
      widget.orgIdController.text = organizationId ?? '';
      widget.orgAddressController.text = organizationAddress ?? '';
      widget.orgPhoneNumberController.text = organizationNumber ?? '';
      widget.orgIBanNumberController.text = organizationBankIbanNumber ?? '';
      widget.orgAccuntNumberController.text = organizationBanckAccount ?? '';

      //representator

      if (isRepresentative == true) {
        organizationRepresentatorName =
            storage.getItem('organizationRepresentatorName');
        organizationRepresentatorAdress =
            storage.getItem('organizationRepresentatorAdress');
        organizationRepresentatorInfo =
            storage.getItem('organizationRepresentatorInfo');
        organizationRepresentatorIdNumber = storage.getItem('organizationRepresentatorIdNumber');
        //----------------------------------------------------------------------------
        widget.representativeNameController.text =
            organizationRepresentatorName ?? '';
        widget.representativeIdController.text = organizationRepresentatorIdNumber ?? '';
        widget.representativeAdressController.text =
            organizationRepresentatorAdress ?? '';
        widget.representativeNumberAndEmailController.text =
            organizationRepresentatorInfo ?? '';
      }
    });
  }
  //---------------------------------------------------------------------------------------

  void generateLocalstorageItems(String name, String content) {
    storage.setItem(name, content);
  }

  //----------------------------------------------------------------------------------------

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
                    isRepresentative = newValue ?? true;
                  });
                  storage.setItem('representator', isRepresentative);
                  //print(isRepresentative);
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
                  //print(isSaveCheckboxValue);
                  storage.setItem('saveData', isSaveCheckboxValue);
                  if (isSaveCheckboxValue == true) {
                    //  storage.setItem('organizationName', widget.orgNameController.text);
                    //  storage.setItem('organizationId', widget.orgIdController.text);
                    //  storage.setItem('organizationAddress', widget.orgAddressController.text);
                    generateLocalstorageItems(
                        'organizationName', widget.orgNameController.text);
                    generateLocalstorageItems(
                        'organizationId', widget.orgIdController.text);
                    generateLocalstorageItems('organizationAddress',
                        widget.orgAddressController.text);
                    generateLocalstorageItems('organizationNumber',
                        widget.orgPhoneNumberController.text);
                    generateLocalstorageItems('organizationBankIbanNumber',
                        widget.orgIBanNumberController.text);
                    generateLocalstorageItems('organizationBanckAccount',
                        widget.orgAccuntNumberController.text);

                    if (isRepresentative == true) {
                      generateLocalstorageItems('organizationRepresentatorName',
                          widget.representativeNameController.text);
                       generateLocalstorageItems('organizationRepresentatorIdNumber',
                          widget.representativeIdController.text);
                      generateLocalstorageItems(
                          'organizationRepresentatorAdress',
                          widget.representativeAdressController.text);
                      generateLocalstorageItems('organizationRepresentatorInfo',
                          widget.representativeNumberAndEmailController.text);
                    }
                  } else {
                    //storage.clear();
                  }
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
      _buildField('აპლიკანტის დასახელება', widget.orgNameController,
          isSaveCheckboxValue),
      _buildField('აპლიკანტის საიდენტიფიკაციო კოდი', widget.orgIdController,
          isSaveCheckboxValue),
      _buildField('აპლიკანტის მისამართი', widget.orgAddressController,
          isSaveCheckboxValue),
      _buildField('აპლიკანტის ტელეფონის ნომერი',
          widget.orgPhoneNumberController, isSaveCheckboxValue),
      _buildField(
          'IBAN - ნომერი', widget.orgIBanNumberController, isSaveCheckboxValue),
      _buildField('აპლიკანტის ანგარიშის ნომერი',
          widget.orgAccuntNumberController, isSaveCheckboxValue),
      isRepresentative
          ? Wrap(
              spacing: 10.0, // Horizontal spacing between fields
              runSpacing: 10.0, // Vertical spacing between lines
              //alignment: isSmallScreen ? WrapAlignment.center : WrapAlignment.start,
              children: [
                _buildField('წარმომადგენელი',
                    widget.representativeNameController, isSaveCheckboxValue),
                _buildField('წარმომადგენლის პირადი ნომერი',
                    widget.representativeIdController, isSaveCheckboxValue),
                _buildField('წარმომადგენლის მისამართი',
                    widget.representativeAdressController, isSaveCheckboxValue),
                _buildField(
                    'წარმომადგენლის Phone & Email',
                    widget.representativeNumberAndEmailController,
                    isSaveCheckboxValue),
              ],
            )
          : Container()
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
