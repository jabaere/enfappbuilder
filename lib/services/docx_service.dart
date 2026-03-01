import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';

/// Custom DOCX processor that fills Word Content Controls (SDT blocks)
/// identified by their `<w:alias w:val="tagName"/>` attribute.
///
/// Replaces `docx_template` with a clean ZIP/XML manipulation approach.
class DocxService {
  /// Fills Word Content Controls in a DOCX template.
  ///
  /// [templateBytes]  — Raw bytes of the template .docx file.
  /// [textValues]     — alias name → replacement text.
  /// [debtorItems]    — Items for the `debtorList` repeating control.
  /// [propertyLines]  — Lines for the `multilineList` repeating control.
  static Uint8List fillContentControls({
    required Uint8List templateBytes,
    required Map<String, String> textValues,
    List<String> debtorItems = const [],
    List<String> propertyLines = const [],
  }) {
    final archive = ZipDecoder().decodeBytes(templateBytes);
    final outputArchive = Archive();

    for (final file in archive.files) {
      if (file.name == 'word/document.xml' && file.isFile) {
        String xml = utf8.decode(file.content as List<int>);

        // 1. Fill simple text content controls
        xml = _fillTextControls(xml, textValues);

        // 2. Expand debtorList
        if (debtorItems.isNotEmpty) {
          xml = _expandListControl(
            xml,
            listAlias: 'debtorList',
            itemAlias: 'debtor',
            items: debtorItems,
          );
        }

        // 3. Expand multilineList (property list)
        if (propertyLines.isNotEmpty) {
          xml = _expandPlainListControl(
            xml,
            listAlias: 'multilineList',
            plainAlias: 'multilinePlain',
            textAlias: 'multilineText',
            lines: propertyLines,
          );
        }

        final encoded = utf8.encode(xml);
        outputArchive.addFile(ArchiveFile(
          'word/document.xml',
          encoded.length,
          encoded,
        ));
      } else if (file.isFile) {
        outputArchive.addFile(
            ArchiveFile(file.name, file.size, file.content));
      }
    }

    return Uint8List.fromList(ZipEncoder().encode(outputArchive)!);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Text replacements
  // ───────────────────────────────────────────────────────────────────────────

  static String _fillTextControls(String xml, Map<String, String> values) {
    for (final entry in values.entries) {
      xml = _replaceAllSdtText(xml, entry.key, _escapeXml(entry.value));
    }
    return xml;
  }

  /// Replaces the `<w:t>` content in every SDT whose alias equals [alias].
  static String _replaceAllSdtText(String xml, String alias, String newText) {
    final marker = '<w:alias w:val="$alias"/>';
    int searchFrom = 0;

    while (true) {
      final markerIdx = xml.indexOf(marker, searchFrom);
      if (markerIdx == -1) break;

      // Find the <w:sdt> that wraps this alias marker
      final sdtStart = _sdtStart(xml, markerIdx);
      if (sdtStart == -1) { searchFrom = markerIdx + marker.length; continue; }

      final sdtEnd = _sdtEnd(xml, sdtStart);
      if (sdtEnd == -1) { searchFrom = markerIdx + marker.length; continue; }

      final sdtBlock = xml.substring(sdtStart, sdtEnd);

      // Skip list/plain containers — only handle text controls here
      final tagVal = _tagVal(sdtBlock);
      if (tagVal == 'list' || tagVal == 'plain') {
        searchFrom = sdtEnd;
        continue;
      }

      final modified = _replaceWt(sdtBlock, newText);
      xml = xml.substring(0, sdtStart) + modified + xml.substring(sdtEnd);
      searchFrom = sdtStart + modified.length;
    }
    return xml;
  }

  /// Replaces the first `<w:t>` in the `<w:sdtContent>` of [sdtBlock].
  static String _replaceWt(String sdtBlock, String newText) {
    final cStart = sdtBlock.indexOf('<w:sdtContent>');
    if (cStart == -1) return sdtBlock;
    final cEnd = sdtBlock.indexOf('</w:sdtContent>', cStart);
    if (cEnd == -1) return sdtBlock;

    final content = sdtBlock.substring(cStart, cEnd + '</w:sdtContent>'.length);

    // Replace the first <w:t> element inside sdtContent
    final wtRe = RegExp(r'<w:t(?:\s[^>]*)?>.*?</w:t>', dotAll: true);
    bool replaced = false;
    final newContent = content.replaceFirstMapped(wtRe, (_) {
      replaced = true;
      final needsSpace = newText.startsWith(' ') || newText.endsWith(' ');
      return needsSpace
          ? '<w:t xml:space="preserve">$newText</w:t>'
          : '<w:t>$newText</w:t>';
    });

    if (!replaced) {
      // No <w:t> found – insert one inside the first <w:r> or wrap in <w:r>
      return sdtBlock;
    }

    return sdtBlock.substring(0, cStart) + newContent + sdtBlock.substring(cEnd + '</w:sdtContent>'.length);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // List expansion: debtorList / debtor
  // ───────────────────────────────────────────────────────────────────────────

  static String _expandListControl(
    String xml, {
    required String listAlias,
    required String itemAlias,
    required List<String> items,
  }) {
    final listMarker = '<w:alias w:val="$listAlias"/>';
    final listMarkerIdx = xml.indexOf(listMarker);
    if (listMarkerIdx == -1) return xml;

    final listStart = _sdtStart(xml, listMarkerIdx);
    if (listStart == -1) return xml;
    final listEnd = _sdtEnd(xml, listStart);
    if (listEnd == -1) return xml;

    final listBlock = xml.substring(listStart, listEnd);

    // Find the inner item SDT template
    final itemMarker = '<w:alias w:val="$itemAlias"/>';
    final itemMarkerIdx = listBlock.indexOf(itemMarker);
    if (itemMarkerIdx == -1) return xml;

    final itemStart = _sdtStart(listBlock, itemMarkerIdx);
    if (itemStart == -1) return xml;
    final itemEnd = _sdtEnd(listBlock, itemStart);
    if (itemEnd == -1) return xml;

    final templateItemSdt = listBlock.substring(itemStart, itemEnd);

    // Find the paragraph wrapping the item SDT
    final pStart = listBlock.lastIndexOf('<w:p ', itemStart);
    final pEnd = listBlock.indexOf('</w:p>', itemEnd);
    if (pStart == -1 || pEnd == -1) return xml;
    final templatePara = listBlock.substring(pStart, pEnd + '</w:p>'.length);

    // Find sdtContent start in the list block
    final cStart = listBlock.indexOf('<w:sdtContent>');
    if (cStart == -1) return xml;

    // Rebuild: sdtPr + sdtContent with repeated paragraphs
    final buf = StringBuffer();
    buf.write(listBlock.substring(0, cStart));
    buf.write('<w:sdtContent>');

    for (final item in items) {
      final filledItem = _replaceWt(templateItemSdt, _escapeXml(item));
      final filledPara = templatePara.replaceFirst(templateItemSdt, filledItem);
      buf.write(filledPara);
    }

    buf.write('</w:sdtContent></w:sdt>');

    return xml.substring(0, listStart) + buf.toString() + xml.substring(listEnd);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Plain list expansion: multilineList / multilinePlain / multilineText
  // ───────────────────────────────────────────────────────────────────────────

  static String _expandPlainListControl(
    String xml, {
    required String listAlias,
    required String plainAlias,
    required String textAlias,
    required List<String> lines,
  }) {
    final listMarker = '<w:alias w:val="$listAlias"/>';
    final listMarkerIdx = xml.indexOf(listMarker);
    if (listMarkerIdx == -1) return xml;

    final listStart = _sdtStart(xml, listMarkerIdx);
    if (listStart == -1) return xml;
    final listEnd = _sdtEnd(xml, listStart);
    if (listEnd == -1) return xml;

    final listBlock = xml.substring(listStart, listEnd);

    // Find template plain SDT
    final plainMarker = '<w:alias w:val="$plainAlias"/>';
    final plainMarkerIdx = listBlock.indexOf(plainMarker);
    if (plainMarkerIdx == -1) return xml;

    final plainStart = _sdtStart(listBlock, plainMarkerIdx);
    if (plainStart == -1) return xml;
    final plainEnd = _sdtEnd(listBlock, plainStart);
    if (plainEnd == -1) return xml;

    final templatePlain = listBlock.substring(plainStart, plainEnd);

    // Find template text SDT inside plain
    final textMarker = '<w:alias w:val="$textAlias"/>';
    final textMarkerIdx = templatePlain.indexOf(textMarker);
    if (textMarkerIdx == -1) return xml;

    final textStart = _sdtStart(templatePlain, textMarkerIdx);
    if (textStart == -1) return xml;
    final textEnd = _sdtEnd(templatePlain, textStart);
    if (textEnd == -1) return xml;

    final templateText = templatePlain.substring(textStart, textEnd);

    // Find the sdtContent in the list block
    final cStart = listBlock.indexOf('<w:sdtContent>');
    if (cStart == -1) return xml;

    final buf = StringBuffer();
    buf.write(listBlock.substring(0, cStart));
    buf.write('<w:sdtContent>');

    for (final line in lines) {
      final filledText = _replaceWt(templateText, _escapeXml(line));
      final filledPlain = templatePlain.replaceFirst(templateText, filledText);
      buf.write(filledPlain);
    }

    buf.write('</w:sdtContent></w:sdt>');

    return xml.substring(0, listStart) + buf.toString() + xml.substring(listEnd);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // SDT navigation helpers
  // ───────────────────────────────────────────────────────────────────────────

  /// Returns the start index of the `<w:sdt>` tag that contains [pos].
  static int _sdtStart(String xml, int pos) {
    int searchPos = pos;
    int skipCount = 0; // number of closed SDTs we need to skip over

    while (searchPos >= 0) {
      final openIdx = xml.lastIndexOf('<w:sdt>', searchPos);
      if (openIdx == -1) return -1;

      final closeIdx = xml.lastIndexOf('</w:sdt>', searchPos);

      if (closeIdx != -1 && closeIdx > openIdx) {
        // The closest open tag before our position is already closed — skip it
        skipCount++;
        searchPos = openIdx - 1;
      } else {
        // This open tag is not yet closed before our position
        if (skipCount == 0) {
          return openIdx;
        }
        skipCount--;
        searchPos = openIdx - 1;
      }
    }
    return -1;
  }

  /// Returns the index AFTER the `</w:sdt>` that closes the SDT starting at [sdtStart].
  ///
  /// **Depth starts at 0. The first `<w:sdt>` we encounter (the opening tag itself)
  /// increments depth to 1. Each subsequent nested `<w:sdt>` increments further.
  /// Each `</w:sdt>` decrements — when depth reaches 0 that is our match.**
  static int _sdtEnd(String xml, int sdtStart) {
    int depth = 0;
    int pos = sdtStart;

    while (pos < xml.length) {
      final openIdx = xml.indexOf('<w:sdt>', pos);
      final closeIdx = xml.indexOf('</w:sdt>', pos);

      if (closeIdx == -1) return -1; // malformed XML

      if (openIdx != -1 && openIdx < closeIdx) {
        // Found a nested opening tag before the next close
        depth++;
        pos = openIdx + '<w:sdt>'.length;
      } else {
        // Found a closing tag
        depth--;
        if (depth == 0) {
          // This is the matching close for our starting <w:sdt>
          return closeIdx + '</w:sdt>'.length;
        }
        pos = closeIdx + '</w:sdt>'.length;
      }
    }
    return -1;
  }

  /// Returns the `w:val` of `<w:tag>` inside a block of XML.
  static String _tagVal(String block) {
    final m = RegExp(r'<w:tag w:val="([^"]*)"').firstMatch(block);
    return m?.group(1) ?? '';
  }

  /// Escapes characters that are special in XML attribute/text values.
  static String _escapeXml(String v) => v
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&apos;');
}
