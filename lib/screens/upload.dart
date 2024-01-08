import 'dart:html' as html;
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  String? _filePath; // Stores the selected file
  String output = '';
  List appNum = [];
  List identificationCode = [];
  List amounts = [];
  List names = [];

  void loadPdfDocument(html.File file) {
    // Read the PDF document only after setting _filePath inside setState
    final reader = FileReader();
    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((event) {
      // Load an existing PDF document.
      PdfDocument document = PdfDocument(
        inputBytes: reader.result as List<int>,
      );

      String text = PdfTextExtractor(document).extractText();
      //print(text);

      appNum = extractStringsStartingWithSP(text, 'SP', 11);
      identificationCode = extractStringsStartingWithSP(text, 'PC', 13);
      amounts = extractAmounts(text, "ლარი");
      names = extractNames(text, 'რესპონდენტი: ');

      //
      String getAllValuesAsString(List<dynamic> list) {
        StringBuffer result = StringBuffer();
        for (var element in list) {
          result
              .write('$element'); // Appending each element followed by a space
        }
        return result.toString().trim(); // Remove trailing space
      }

      if (identificationCode.length > 1) {
        setState(() {
          output = '''
გთხოვთ პრობლემური კლიენტის  რესპონდენტი: ${getAllValuesAsString(names)} საქმეზე  დაგვიმტკიცოთ გამარტივებული წარმოების ხარჯი:
${amounts[1]} ლარი - სააპლიკაციო საფასური;
${amounts[2]} ლარი - ყადაღის საფასური;
${amounts[3]}  ლარი  - საგარანტიო თანხა;
გთხოვთ, დამტკიცების შემთხვევაში გადარიცხოთ თანხები შემდეგი დანიშნულებით:
მიმღების დასახელება: სსიპ აღსრულების ეროვნული ბიურო
საიდენტიფიკაციო კოდი: 205263873
მიმღების ბანკი: სს "საქართველოს ბანკი"
ბანკის კოდი: BAGAGE22
ანგარიშის ნომერი: GE39BG0000000252525252
1. ${amounts[1]} ლარი
დანიშნულება: სააპლიკაციო საფასური, საქმის ნომერი #${appNum[0]}, სს კრედო ბანკი (205232238) - გადახდის ნომერი - ${identificationCode[0]}.
2. ${amounts[2]} ლარი
დანიშნულება:ყადაღის საფასური საქმის ნომერი #${appNum[0]}, სს კრედო ბანკი (205232238) - გადახდის ნომერი - ${identificationCode[1]}.
3. ${amounts[3]} ლარი
დანიშნულება: საგარანტიო თანხა : საქმის ნომერი #${appNum[0]}, სს კრედო ბანკი (205232238) - გადახდის ნომერი - ${identificationCode[2]}.
''';
        });
      } else{
        setState(() {
           output = '''
გთხოვთ პრობლემური კლიენტის  რესპონდენტი: ${getAllValuesAsString(names)} საქმეზე  დაგვიმტკიცოთ გამარტივებული წარმოების ხარჯი:
${amounts[1]} ლარი - სააპლიკაციო საფასური;
გთხოვთ, დამტკიცების შემთხვევაში გადარიცხოთ თანხები შემდეგი დანიშნულებით:
მიმღების დასახელება: სსიპ აღსრულების ეროვნული ბიურო
საიდენტიფიკაციო კოდი: 205263873
მიმღების ბანკი: სს "საქართველოს ბანკი"
ბანკის კოდი: BAGAGE22
ანგარიშის ნომერი: GE39BG0000000252525252
1. ${amounts[1]} ლარი
დანიშნულება: სააპლიკაციო საფასური, საქმის ნომერი #${appNum[0]}, სს კრედო ბანკი (205232238) - გადახდის ნომერი - ${identificationCode[0]}.

''';
        });
      }


      document.dispose();
    });
  }

  void _pickFile() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];

        setState(() {
          _filePath = file.name;

          loadPdfDocument(file);
        });
      }
    });

    //Load an existing PDF document.
  }

// extract identification numbers and app number

  List<String> extractStringsStartingWithSP(
      String text, String match, num strLength) {
    List<String> extractedStrings = [];
    //print(match);
    RegExp regExp = RegExp(
        r'\b' + match + r'\S{' + (strLength - match.length).toString() + r'}\b',
        multiLine: true);

    Iterable<Match> matches = regExp.allMatches(text);

    for (Match matchedItem in matches) {
      String matchedString = matchedItem.group(0)!; // Get the matched string
      if (matchedString.length == strLength) {
        // Check for the length of 11 characters
        extractedStrings.add(matchedString); // Add the string to the list
      }
    }

    return extractedStrings;
  }

// extract amounts
  List<String> extractAmounts(String text, String word) {
    List<String> extractedNumbers = [];
    RegExp regExp = RegExp(r'(\d+(\.\d+)?)\s*' + word);

    Iterable<Match> matches = regExp.allMatches(text);

    for (Match match in matches) {
      extractedNumbers.add(match.group(1)!);
    }

    return extractedNumbers;
  }

//extract names
  List<String> extractNames(String text, String word) {
    List<String> extractedNames = [];
    //capture names in any language (including non-ASCII characters)
    //RegExp regExp = RegExp(r'(?<=' + word + r')\s*([\p{L}\p{M}\p{N}\p{Pd}]+(?:\s+[\p{L}\p{M}\p{N}\p{Pd}]+)*)');
    //  RegExp regExp = RegExp(r'(?<=' + word + r')\s*([^\d\s,.]+(?:\s+[^\d\s,.]+)*)');
    RegExp regExp = RegExp(r'(?<=' + word + r')(.*?)(?=,\s*პ/ნ\s*\d{11}|\n|$)',
        dotAll: true);

    Iterable<Match> matches = regExp.allMatches(text);

    for (Match match in matches) {
      extractedNames.add(match.group(1)!);
    }

    return extractedNames;
  }

// copy text
  void copyOutput() {
    Clipboard.setData(ClipboardData(text: output));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text Copied to Clipboard')),
    ); // This will print the content of the 'output' variable
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.grey[200])),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload),
                      label: const Text('აირჩიეთ რეკვიზიტი'),
                    ),
                    if (_filePath != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('File Name: $_filePath'),
                      ),
                  ],
                ),
                const SizedBox(width: 30),
                if (output.isNotEmpty)
                  Column(
                    children: [
                      Text(output,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[400],
                          )),
                      ElevatedButton.icon(
                        onPressed: copyOutput,
                        icon: const Icon(Icons.copy_all),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
