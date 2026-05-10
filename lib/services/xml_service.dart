import 'dart:convert';
import 'dart:io';
import 'package:windows1251/windows1251.dart';
import 'package:xml/xml.dart';

/// Сервис для низкоуровневой работы с XML-документами
class XmlService {
  /// Читает файл по пути и возвращает объект XmlDocument
  Future<XmlDocument> loadDocument(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    String content;
    try {
      // 1. Сначала пробуем UTF-8
      content = utf8.decode(bytes);
    } catch (_) {
      try {
        // 2. Если упало — это 99% кириллица Windows-1251
        content = windows1251.decode(bytes);
      } catch (e) {
        throw Exception("Не удалось определить кодировку файла.");
      }
    }

    // ВАЖНО: Если в XML есть заголовок <?xml ... encoding="windows-1251"?>,
    // библиотека xml может выдать ошибку, так как мы уже декодировали строку в UTF-8.
    // Если падает на парсинге, можно вырезать заголовок:
    final cleanContent = content.replaceFirst(RegExp(r'<\?xml.*?\?>'), '');

    return XmlDocument.parse(cleanContent);
  }

  /// Пример логики слияния: добавляет всех детей из корня донора в корень базы
  void mergeDocuments(XmlDocument base, XmlDocument donor) {
    final baseRoot = base.rootElement;
    final donorRoot = donor.rootElement;

    // Копируем узлы донора и вставляем в базу
    for (var node in donorRoot.children) {
      baseRoot.children.add(node.copy());
    }
  }
}
