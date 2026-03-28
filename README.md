# ENF App Builder (აპლიკაციის გენერატორი)

A professional, local-first legal document automation suite built with Flutter and Firebase. Designed to streamline the generation of Microsoft Word (.docx) documents for enforcement and legal proceedings.

---

## 🌟 Overview

**ENF App Builder** is a specialized tool that automates the creation of complex legal documents from standardized templates. It focuses on **privacy, speed, and precision**, ensuring that sensitive legal data remains on the user's device while providing a seamless, cross-platform experience.

## ✨ Key Features

### 📄 Smart DOCX Generation
- Uses advanced ZIP/XML manipulation to fill Word **Content Controls (SDT blocks)**.
- Replaces tags like `debtorList` and `multilineList` with dynamic data, allowing for repeating rows and complex property lists.
- Maintains original template styling and formatting perfectly.

### 🔒 Privacy & Local-First Security
- **No Data Uploads**: All document processing happens directly in the browser or on the local device.
- **Client-Side Storage**: Sensitive applicant information can be "remembered" using local browser storage, never touching a central database.
- **Offline Ready**: Operates independently of server-side logic for core document generation.

### ⚖️ Legal Logic & Validation
- **Solidary Liability**: Automatically calculates and marks "Solidary" status when multiple debtors are involved.
- **Conditional Fields**: Dynamically shows property fields based on legal triggers (e.g., "Seizure" selection).
- **Proactive Error Handling**: Prevents document generation if critical data (like debtor details) is missing.

---

## 🇬🇪 გამოყენების ინსტრუქცია (Instructions)

1. **დოკუმენტის გახსნა**: სასურველია აპლიკაციის მიერ დაგენერირებული დოკუმენტი გახსნათ **Microsoft Word**-ის საშუალებით.
2. **მონაცემთა დამახსოვრება**: შეგიძლიათ შეინახოთ აპლიკანტის ინფორმაცია "ინფორმაციის დამახსოვრება" ღილაკით (მონაცემები რჩება თქვენს ბრაუზერში).
3. **მოვალის გრაფა**: შეიყვანეთ ინფორმაცია თანმიმდევრობით: *სახელი გვარი, პირადი ნომერი, მისამართი, ტელეფონის ნომერი*.
4. **ყადაღა & ქონება**: "ყადაღის" მონიშვნისას ჩნდება ქონების დამატებითი გრაფა. ყოველი ახალი ქონება დაიწყეთ ახალი ხაზიდან.
5. **სტანდარტული დასაბუთება**: აპლიკაცია ავტომატურად ამატებს სესხის ხელშეკრულების, გრაფიკის და სხვა სტანდარტულ მოთხოვნებს, რომელთა შეცვლაც შეგიძლიათ Word-ში.

---

## 🛠 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Web, Desktop, Mobile)
- **Language**: Dart
- **Backend**: [Firebase](https://firebase.google.com/) (Authentication & Analytics)
- **DOCX Processing**: Custom implementation using `archive` and `utf8` manipulation (located in `DocxService`).
- **PDF Handling**: `syncfusion_flutter_pdf` for extraction and parsing.
- **Local Persistence**: `localstorage` for caching user preferences.

## 📂 Project Structure

- `lib/services/docx_service.dart`: The core engine for manipulating Word XML structures.
- `lib/screens/`: Flutter UI components (Home, Upload, Instructions, Login).
- `lib/particles/`: Data models and reusable UI "particles".
- `assets/template.docx`: The master Word template with Content Controls.

## 🚀 Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/jabaere/enfappbuilder.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run -d chrome
   ```

---

## Last Update

### Files Changed

| File | Change |
|------|--------|
| `pubspec.yaml` | Removed `docx_template: ^0.4.0`, added `archive: ^3.6.1`, removed `dependency_overrides` |
| `lib/services/docx_service.dart` | New custom DOCX processor |
| `lib/home.dart` | Refactored `changeTextContent()` to use `DocxService` |

---

### How the New Service Works

A `.docx` file is essentially a ZIP archive. The new `DocxService.fillContentControls()` works as follows:

- Unpacks the DOCX bytes using `archive`
- Reads `word/document.xml` as UTF-8 text
- Locates each `<w:sdt>` (Structured Document Tag / Content Control) using  
  `<w:alias w:val="tagName"/>` (same approach used by `docx_template`)
- Replaces the `<w:t>` text content inside each matched control
- Expands list controls (e.g., `debtorList`, `multilineList`) by cloning the template paragraph for each entry
- Repacks the archive and returns the updated DOCX bytes

---

### Notes

- The DOCX template remains unchanged
- Existing Microsoft Word Content Controls are fully preserved
- This replaces `docx_template` with a custom implementation

## Screenshots
   

<img width="1920" height="919" alt="Applicationbuilder-03-28-2026_10_40_AM" src="https://github.com/user-attachments/assets/ac5c21d8-150d-42ba-b210-eb10151219bc" />

<img width="1920" height="919" alt="Applicationbuilder-03-28-2026_11_16_AM" src="https://github.com/user-attachments/assets/837d9a07-2a6b-4045-8571-bbcf94d81673" />

<img width="1920" height="919" alt="Applicationbuilder-03-28-2026_11_18_AM" src="https://github.com/user-attachments/assets/6ef05b33-3e64-4a20-8648-f511f0d56ac1" />

<img width="1920" height="919" alt="Applicationbuilder-03-28-2026_11_18_AM (1)" src="https://github.com/user-attachments/assets/9387f433-ded2-4a3d-be7c-91633d01ec96" />
