import 'package:flutter/material.dart';

class DebtInputs extends StatefulWidget {
  const DebtInputs({Key? key}) : super(key: key);

  @override
  State<DebtInputs> createState() => DebtInputsState();
}

class DebtInputsState extends State<DebtInputs> with AutomaticKeepAliveClientMixin {
  final List<TextEditingController> _controllers = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_controllers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Color(0xFF94A3B8)),
                  SizedBox(width: 8),
                  Text(
                    'დამატეთ მოვალე',
                    style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: List.generate(
              _controllers.length,
              (index) => _DebtorEntry(
                index: index + 1,
                controller: _controllers[index],
              ),
            ),
          ),
        const SizedBox(height: 12),

        // Action buttons
        Row(
          children: [
            _ActionButton(
              label: 'დამატება',
              icon: Icons.add_circle_outline_rounded,
              color: const Color(0xFF4F46E5),
              onPressed: _addEntry,
            ),
            if (_controllers.length > 1) ...[
              const SizedBox(width: 10),
              _ActionButton(
                label: 'წაშლა',
                icon: Icons.remove_circle_outline_rounded,
                color: const Color(0xFFEF4444),
                onPressed: _removeEntry,
                outlined: true,
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _addEntry() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeEntry() {
    setState(() {
      if (_controllers.isNotEmpty) {
        final ctrl = _controllers.removeLast();
        ctrl.dispose();
      }
    });
  }

  List<String> readDataFromControllers() {
    return _controllers.map((c) => c.text).toList();
  }
}

class _DebtorEntry extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  const _DebtorEntry({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'მოვალე $index — სახელი, პ/ნ, მისამართი, ტელ.',
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                '$index',
                style: const TextStyle(
                  color: Color(0xFF4F46E5),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'შეიყვანეთ მოვალის ინფო' : null,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool outlined;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return outlined
        ? OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          )
        : ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: onPressed,
            icon: Icon(icon, size: 18),
            label: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          );
  }
}
