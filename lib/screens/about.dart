import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.grey[200])),
      body: const SingleChildScrollView(
         child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 150),
          child: Column(
            children: [
                Text(
                     '''
                        აპლიკაციის გამოყენებით:
                          1.გაიმარტივებთ აპლიკაციების წერის პროცესს
                          2.დაზოგავთ დროს
                          3.აღარ გექნებათ შეხება word-ის დოკუმენტთან
                          4.თავიდან აიცილებთ როგორც ტექნიკურ ასევე ვიზუალურ შეცდომებს
   
                     ''',style: TextStyle(color: Colors.teal, fontSize: 18),)
            ],
          ),
         ),
      ));
  }
}