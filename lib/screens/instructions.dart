import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ინსტრუქცია'),
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800), // Max width for reading comfort
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              _buildInstructionCard(
                title: 'გამოყენების ინსტრუქცია',
                icon: Icons.info_outline_rounded,
                content: [
                  '1. სასურველია აპლიკაციის მიერ დაგენერირებული დოკუმენტი გახსნათ Microsoft Word-ის საშუალებით.',
                  '2. პირველი გამოყენებისას შეგიძლიათ შეინახოთ კრედიტორის (აპლიკანტის) ინფორმაცია "ინფორმაციის დამახსოვრება" ღილაკით.',
                  '3. მოვალის გრაფის შეუვსებლობის შემთხვევაში აპლიკაცია გიჩვენებთ შეცდომას და ფაილი არ დაგენერირდება.',
                  '4. მოვალის გრაფაში შეიყვანეთ ინფომაცია თანმიმდევრობით: სახელი გვარი, პირადი ნომერი, მისამართი, ტელეფონის ნომერი.',
                  '5. რამდენიმე მოვალის დამატების (ღილაკი "დამატება") შემთხვევაში ავტომატურად მოინიშნება "სოლიდარული" მოთხოვნის სტატუსი.',
                  '6. "ყადაღის" მონიშვნის შემთხვევაში ავტომატურად ინიშნება "აღსასრულებლად მიქცევის" გრაფაც.',
                  '7. "აღსასრულებლად მიქცევის" მონიშვნა შესაძლებელია დამოუკიდებლადაც.',
                  '8. "ყადაღის" მონიშვნისას ჩნდება ქონების დამატებითი გრაფა. ყოველი ახალი ქონების შესახებ ინფორმაცია უნდა დაიწყოს ახალი ხაზიდან.',
                  '9. თანხების გრაფაში, თუ რომელიმე მოთხოვნა არ არსებობს (მაგ: საკომისიო), ველში მიუთითეთ 0.',
                  '10. მოთხოვნის დასაბუთებაში ავტომატურად მითითებულია სტანდარტული ჩამონათვალი:\n   • სესხის ხელშეკრულება\n   • გრაფიკი\n   • გაფრთხილების წერილები\n   • საბანკო რეკვიზიტები და ამონაწერი\n   • მინდობილობა\nსაჭიროებისამებრ, ფაილის დაგენერირების შემდეგ შეგიძლიათ ეს სია ხელით შეცვალოთ Word-ში.',
                ],
              ),
              const SizedBox(height: 24),
              _buildInstructionCard(
                title: 'ტექნიკური ინფორმაცია და უსაფრთხოება',
                icon: Icons.security_rounded,
                content: [
                  'აპლიკაცია მუშაობს სრულად ლოკალურად უსაფრთხოდ თქვენს ბრაუზერში.',
                  'არცერთი შეყვანილი პერსონალური თუ ფინანსური მონაცემი არ იგზავნება სერვერზე და არ ინახება მონაცემთა ბაზაში.',
                  '"ინფორმაციის დამახსოვრების" ფუნქცია იყენებს მხოლოდ თქვენი ბრაუზერის ლოკალურ მეხსიერებას (Local Storage).',
                  'Word შაბლონის შევსება და დოკუმენტის გენერირება ხდება მყისიერად თქვენს მოწყობილობაზე, რაც გამორიცხავს მონაცემთა გაჟონვის რისკს.'
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionCard({
    required String title,
    required IconData icon,
    required List<String> content,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF4F46E5), size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...content.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6.0),
                        child: Icon(Icons.circle, size: 6, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF475569),
                            height: 1.6, // Better line height for readability
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
