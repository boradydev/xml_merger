import 'dart:convert';
import 'dart:io';
import 'package:windows1251/windows1251.dart';
import 'package:xml/xml.dart';

class XmlService {
  String _detectEncoding(List<int> bytes) {
    final head = latin1.decode(
      bytes.sublist(0, bytes.length < 100 ? bytes.length : 100),
    );
    final regex = RegExp(
      r"""encoding\s*=\s*["'](.*?)["']""",
      caseSensitive: false,
    );
    final match = regex.firstMatch(head);
    final encoding = match?.group(1)?.toLowerCase();

    return encoding ?? 'utf-8';
  }

  Future<XmlDocument> loadDocument(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    final encodingName = _detectEncoding(bytes);

    String content;
    if (encodingName == 'windows-1251' || encodingName == 'cp1251') {
      content = windows1251.decode(bytes);
    } else {
      content = utf8.decode(bytes);
    }

    return XmlDocument.parse(content);
  }

  Future<void> saveDocument(XmlDocument document, String filePath) async {
    final declaration = document.declaration;
    final encoding = declaration?.getAttribute('encoding') ?? 'utf-8';
    final xmlString = document.toXmlString(
      pretty: true,
      spaceBeforeSelfClose: (node) => true,
    );

    List<int> outputBytes;
    if (encoding.toLowerCase() == 'windows-1251') {
      outputBytes = windows1251.encode(xmlString);
    } else {
      outputBytes = utf8.encode(xmlString);
    }

    await File(filePath).writeAsBytes(outputBytes);
  }
}
