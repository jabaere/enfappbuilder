import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  final headerStyle = const TextStyle(color: Colors.teal, fontSize: 18);

  const InstructionsScreen({super.key});
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey[200]),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.start,
              direction: constraints.maxWidth < 600 ? Axis.vertical : Axis.horizontal,
              children: [
                buildContent('მოხმარების წესები',[
                  '''
                     1.სასურველია დაგენერირებული დოკუმენტი გახსნათ Microsoft Word - ის საშუალებით.
                     2.აპლიკაციის პირველი გამოყენებისას სასურველია შეინახოთ აპლიკანტის შესახებ ინფორმაცია მონიშვნის
                       "ინფორმაციის დამახსოვრება" გააქტიურებით.
                     3.მოვალის გრაფის შეუვსებლობის შემთხვევაში აპლიკაცია გიჩვენებთ შეცდომას და ფაილი არ დაგენერირდება
                     4.მოვალის გრაფაში ვუთითებთ: <<სახელს << გვარს << პირად ნომერს << მისამართს << ტელეფონის ნომერს
                       მითითებული მიმდევრობით.
                     5.რამდენიმე მოვალის შემთხვევაში ავტომატურად მოინიშნება "სოლიდარული" მოთხოვნის გრაფა.
                     6."ყადაღის" მონიშვნის შემთხვევაში ავტომატურად მონიშნება "აღსასრულებლად მიქცევის" გრაფაც.
                     7."აღსასრულებლად მიქცევის" მონიშვნის გააქტიურება შესაძლებელია დამოუკიდებლადაც.
                     8."ყადაღის" მონიშვნის შემთხვევაში გააქტიურდება ქონების გრაფა, რომლის შევსებისას უნდა
                       გაითვალისწონოთ, რომ ყოველი ახალი წინადადება უნდა დაიწყოს ახალი ხაზიდან.
                     9.თანხების მითითების დროს თუ არ არსებობს რომელიმე მოთხოვნა შესაბამის გრაფაში ვწერთ 0 - ს,
                     მაგალითად არ გვაქვს "საკომისიო" - მივუთითებთ 0-ს და ა.შ.
                     10.მოთხოვნის დასაბუთებაში მითითებულია ზოგადი ინფორმაცია:
                        1.	სესხის ხელშეკრულება
                        2.	გრაფიკი
                        3.	გაფრთხილების წერილები
                        4.	საბანკო რეკვიზიტები და ამონაწერი. 
                        5.	მინდობილობა.
                      აუცილებლობის შემთხვევაში დასაბუთება შეგიძლიათ დააკორექტიროთ ხელით.
                  '''
                  ]),
                // buildContent('ტექნიკური ინფორმაცია',[
                //   '''
                //   აპლიკაცია არ გზავნის და არ ინახავს თქვენს მიერ შეყვანილ ინფორმაციას. 
                //   ხშირად გამოყენებული/განმეორებადი საჯარო ინფორმაცია, მაგალითად კრედიტორის შესახებ - 
                //   ინახება ლოკალურად web browser - ის local storage - ში.
                //   ''',
                //   '''
                //   აპლიკაციის მუშაობის პრინციპი მოიცავს 3 ეტაპს:
                //      1.შაბლონის ჩამოტვირთვა
                //         მოთხოვნის შემდეგ სისტემა ჩამოტვირთავს შაბლონს (HTTP მოთხოვნის საშუალებით)
                //      2.შაბლონის მოდიფიკაცია
                //         შაბლონის მეხსიერებაში ჩატვირთვის შემდეგ ლოკალურად ხდება placeholder - ების
                //         ჩანაცვლება მომხმარებლის მიერ შეყვანილი მონაცემებით.
                //      3.შეცვლილი ფაილის შენახვა
                //         სისტემა შეინახავს მოდიფიცირებულ ფაილს download საქაღალდეში 
                    
                //   გადარიცხვის ტექსტის ავტომატური გენერირებისათვის სისტემა ლოკალურად კითხულობს არჩეული
                //   ფაილის შინაარს და აგენერირებს შესაბამის ტექსტს. აღნიშნული პროცედურის დროს
                //   არჩეული ფაილი არ ინახება და იგზავნება მონაცემთა ბაზებში.
                //   '''
                // ]),
                // Add more content as needed
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildContent(String title,List<String> about) {
 
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headerStyle),
          const SizedBox(height: 5),
         Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: about.map((item) => Text(item)).toList(),
          ),
         
          
          // Add more text or content here...
        ],
      ),
    );
  }
}




