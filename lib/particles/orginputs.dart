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
  bool isSaveCheckboxValue = false;
  bool isRepresentative = true;

  late LocalStorage storage;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    storage = LocalStorage('app');
    await storage.ready;
    setState(() {
      storage.setItem('representator', true);
      isSaveCheckboxValue = storage.getItem('saveData') ?? false;
      isRepresentative = storage.getItem('representator') ?? true;

      widget.orgNameController.text = storage.getItem('organizationName') ?? '';
      widget.orgIdController.text = storage.getItem('organizationId') ?? '';
      widget.orgAddressController.text = storage.getItem('organizationAddress') ?? '';
      widget.orgPhoneNumberController.text = storage.getItem('organizationNumber') ?? '';
      widget.orgIBanNumberController.text = storage.getItem('organizationBankIbanNumber') ?? '';
      widget.orgAccuntNumberController.text = storage.getItem('organizationBanckAccount') ?? '';

      if (isRepresentative) {
        widget.representativeNameController.text =
            storage.getItem('organizationRepresentatorName') ?? '';
        widget.representativeIdController.text =
            storage.getItem('organizationRepresentatorIdNumber') ?? '';
        widget.representativeAdressController.text =
            storage.getItem('organizationRepresentatorAdress') ?? '';
        widget.representativeNumberAndEmailController.text =
            storage.getItem('organizationRepresentatorInfo') ?? '';
      }
    });
  }

  void _saveToStorage() {
    storage.setItem('organizationName', widget.orgNameController.text);
    storage.setItem('organizationId', widget.orgIdController.text);
    storage.setItem('organizationAddress', widget.orgAddressController.text);
    storage.setItem('organizationNumber', widget.orgPhoneNumberController.text);
    storage.setItem('organizationBankIbanNumber', widget.orgIBanNumberController.text);
    storage.setItem('organizationBanckAccount', widget.orgAccuntNumberController.text);
    if (isRepresentative) {
      storage.setItem('organizationRepresentatorName', widget.representativeNameController.text);
      storage.setItem('organizationRepresentatorIdNumber', widget.representativeIdController.text);
      storage.setItem('organizationRepresentatorAdress', widget.representativeAdressController.text);
      storage.setItem('organizationRepresentatorInfo', widget.representativeNumberAndEmailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Applicant fields grid
        _FormGrid(children: [
          _buildField('აპლიკანტის დასახელება', widget.orgNameController,
              icon: Icons.business_outlined),
          _buildField('საიდენტიფიკაციო კოდი', widget.orgIdController,
              icon: Icons.badge_outlined),
          _buildField('მისამართი', widget.orgAddressController,
              icon: Icons.location_on_outlined),
          _buildField('ტელეფონი', widget.orgPhoneNumberController,
              icon: Icons.phone_outlined),
          _buildField('IBAN', widget.orgIBanNumberController,
              icon: Icons.account_balance_outlined),
          _buildField('ანგარიშის ნომერი', widget.orgAccuntNumberController,
              icon: Icons.credit_card_outlined),
        ]),
        const SizedBox(height: 16),

        // Checkboxes row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Wrap(
            spacing: 24,
            runSpacing: 4,
            children: [
              _StyledCheckbox(
                value: isRepresentative,
                label: 'წარმომადგენელი',
                onChanged: (v) {
                  setState(() => isRepresentative = v ?? true);
                  storage.setItem('representator', isRepresentative);
                },
              ),
              _StyledCheckbox(
                value: isSaveCheckboxValue,
                label: 'ინფორმაციის დამახსოვრება',
                onChanged: (v) {
                  setState(() => isSaveCheckboxValue = v ?? false);
                  storage.setItem('saveData', isSaveCheckboxValue);
                  if (isSaveCheckboxValue) _saveToStorage();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Representative section
        if (isRepresentative) ...[
          _SectionDivider(label: 'წარმომადგენელი'),
          const SizedBox(height: 12),
          _FormGrid(children: [
            _buildField('სახელი გვარი', widget.representativeNameController,
                icon: Icons.person_outlined),
            _buildField('პირადი ნომერი', widget.representativeIdController,
                icon: Icons.badge_outlined),
            _buildField('მისამართი', widget.representativeAdressController,
                icon: Icons.location_on_outlined),
            _buildField('ტელ. / Email', widget.representativeNumberAndEmailController,
                icon: Icons.contact_mail_outlined),
          ]),
        ],
      ],
    );
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {required IconData icon}) {
    return TextFormField(
      enabled: !isSaveCheckboxValue,
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
      ),
      validator: (v) =>
          (v == null || v.isEmpty) ? 'შეიყვანეთ $label' : null,
    );
  }
}

// ─── Shared UI primitives ────────────────────────────────────────────────────

class _FormGrid extends StatelessWidget {
  final List<Widget> children;
  const _FormGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cols = constraints.maxWidth > 600 ? 2 : 1;
      if (cols == 1) {
        return Column(
          children: children
              .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12), child: c))
              .toList(),
        );
      }
      // 2-column grid
      final rows = <Widget>[];
      for (int i = 0; i < children.length; i += 2) {
        final right = i + 1 < children.length ? children[i + 1] : const SizedBox();
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: children[i]),
                const SizedBox(width: 12),
                Expanded(child: right),
              ],
            ),
          ),
        );
      }
      return Column(children: rows);
    });
  }
}

class _StyledCheckbox extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;
  const _StyledCheckbox(
      {required this.value, required this.label, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: value, onChanged: onChanged),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF475569),
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F46E5),
                letterSpacing: 0.5)),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
      ],
    );
  }
}
