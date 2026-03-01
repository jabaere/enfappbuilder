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
    Key? key,
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
  // ignore: unused_field
  var ct = debtInputsKey.currentState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(builder: (context, constraints) {
          final cols = constraints.maxWidth > 500 ? 3 : 1;
          final fields = _buildFields();
          if (cols == 1) {
            return Column(
              children: fields
                  .map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12), child: f))
                  .toList(),
            );
          }
          // 3-column grid
          final rows = <Widget>[];
          for (int i = 0; i < fields.length; i += cols) {
            final rowFields = fields.sublist(i, (i + cols).clamp(0, fields.length));
            while (rowFields.length < cols) rowFields.add(const SizedBox());
            rows.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rowFields
                      .expand((f) => [Expanded(child: f), const SizedBox(width: 12)])
                      .toList()
                    ..removeLast(),
                ),
              ),
            );
          }
          return Column(children: rows);
        }),
      ],
    );
  }

  List<Widget> _buildFields() {
    final fields = [
      _buildField('ძირი', widget.principalAmount,
          icon: Icons.payments_outlined),
      _buildField('სარგებელი', widget.interestAmount,
          icon: Icons.trending_up_rounded),
      _buildField('პირგასამტეხლო', widget.penaltyAmount,
          icon: Icons.warning_amber_outlined),
      _buildField('დაზღვევა', widget.insuranceAmount,
          icon: Icons.health_and_safety_outlined),
      _buildField('საკომისიო', widget.commissionAmount,
          icon: Icons.percent_rounded),
      _buildField('სააპლიკაციო საფასური', widget.apliccationFeeAmount,
          icon: Icons.receipt_outlined),
    ];
    if (widget.foreclosureAmountTrue) {
      fields.add(_buildField('ყადაღის საფასური', widget.foreclosureAmount,
          icon: Icons.gavel_rounded));
    }
    return fields;
  }

  Widget _buildField(String label, TextEditingController ctrl,
      {required IconData icon}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        suffixText: '₾',
        suffixStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'შეიყვანეთ $label' : null,
    );
  }
}