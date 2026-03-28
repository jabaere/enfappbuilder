# applicationbuilder

Web App to generate Microsoft Word documents (.docx) and parse PDF files to extract and generate text for fund transfers. Built using Dart, Flutter, and Firebase

## Key features of the application include:

1. Document Generation: The app can create Microsoft Word documents based on user inputs or predefined templates, simplifying the process of document creation.

2. PDF Parsing: It can parse PDF files to extract relevant information, which is particularly useful for generating text related to fund transfers.

3. Fund Transfer Text Generation: Based on the details extracted from PDFs or provided by the user, the app generates text that can be used for transferring funds, ensuring accuracy and efficiency in financial transactions.

4. Cross-Platform Compatibility: Developed using Flutter, the app is capable of running on multiple platforms, providing a consistent user experience across devices.

5. Cloud Integration: Firebase is used for backend services, offering real-time database capabilities, authentication, and cloud storage, ensuring that the app is scalable and secure.

6. Installable (PWA): The app is a Progressive Web App (PWA), which means it can be installed directly on various devices (desktop, mobile, or tablet) from a web browser. Once installed, it behaves like a native app, allowing users to access its features conveniently without needing to navigate to a browser each time. This enhances usability, provides an app-like experience, and ensures the app is readily available whenever needed, even with offline capabilities in some cases.

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
