import 'dart:html' as html;
import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  UploadScreenState createState() => UploadScreenState();
}

class UploadScreenState extends State<UploadScreen> {
  String? _filePath; // Stores the selected file path

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
      print(text);

      List appNum = extractStringsStartingWithSP(text, 'SP', 11);
      List identificationCode = extractStringsStartingWithSP(text, 'PC', 13);
      List amounts = extractAmounts(text,"ლარი");
      List names = extractNames(text,'რესპონდენტი: ');

   //   print(appNum);
      print(appNum);
      print(identificationCode);
      print(amounts);
      print(names);
      print(names.length);

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
  RegExp regExp = RegExp(r'\b' + match + r'\S{' + (strLength - match.length).toString() + r'}\b', multiLine: true);

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
List <String> extractNames(String text, String word) {

  List<String> extractedNames = [];
  //capture names in any language (including non-ASCII characters)
  //RegExp regExp = RegExp(r'(?<=' + word + r')\s*([\p{L}\p{M}\p{N}\p{Pd}]+(?:\s+[\p{L}\p{M}\p{N}\p{Pd}]+)*)');
  //  RegExp regExp = RegExp(r'(?<=' + word + r')\s*([^\d\s,.]+(?:\s+[^\d\s,.]+)*)');
  RegExp regExp = RegExp(r'(?<=' + word + r')(.*?)(?=,\s*პ/ნ\s*\d{11}|\n|$)', dotAll: true);


  Iterable<Match> matches = regExp.allMatches(text);

  for (Match match in matches) {
    extractedNames.add(match.group(1)!);
  }

  return extractedNames;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.grey[200])),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload),
              label: const Text('Select File'),
            ),
            if (_filePath != null) Text('File Name: $_filePath'),
          ],
        ),
      ),
    );
  }
}
