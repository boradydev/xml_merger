import 'dart:convert';
import 'dart:io';
import 'package:windows1251/windows1251.dart';
import 'package:xml/xml.dart';

class XmlService {
  /// Определяет кодировку XML-документа по его начальным байтам.
  ///
  /// Метод декодирует первые 100 байт (или меньше, если файл совсем мелкий)
  /// в строку [latin1], чтобы безопасно прочитать XML-декларацию.
  /// Затем с помощью регулярного выражения ищет атрибут `encoding`.
  ///
  /// Особенности работы:
  /// * `bytes` — массив байтов [List<int>] сырого содержимого файла.
  /// * Поиск регулярным выражением регистронезависимый
  /// (ищет `encoding="..."` или `encoding='...'`).
  ///
  /// Возвращает название кодировки в нижнем регистре `windows-1251`,
  /// либо `utf-8`, если кодировка не найдена или декларация отсутствует.
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

  /// Загружает XML-документ из файла с автоматическим определением кодировки.
  ///
  /// Читает содержимое файла по пути [filePath] в виде байтов, определяет
  /// кодировку с помощью приватного метода [_detectEncoding] и
  /// парсит строку в [XmlDocument].
  ///
  /// Поддерживает декодирование:
  /// * `windows-1251` декодирует через пакет `windows1251`.
  /// * `utf-8` используется по умолчанию во всех остальных случаях.
  ///
  /// Возвращает готовый для работы объект [XmlDocument].
  ///
  /// Может выбросить:
  /// * [FileSystemException] — если файл не найден или недоступен для чтения.
  /// * [XmlParserException] — если содержимое файла не является валидным XML.
  Future<XmlDocument> loadDocument(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    final encodingName = _detectEncoding(bytes);

    String content;
    if (encodingName == 'windows-1251') {
      content = windows1251.decode(bytes);
    } else {
      content = utf8.decode(bytes);
    }

    return XmlDocument.parse(content);
  }

  /// Сохраняет XML-документ в файл с учетом кодировки декларации.
  ///
  /// определяет кодировку из заголовка XML [document]
  /// и записывает байты по пути [filePath].
  ///
  /// * `pretty: true` метод форматирует XML в удобочитаемую строку с отступами.
  /// * `spaceBeforeSelfClose: (node) => true` добавляет пробел
  /// перед закрывающим тегом (например, `<tag />`).
  ///
  /// Поддерживает кодировки:
  /// * `windows-1251` (использует пакет `windows1251`)
  /// * `utf-8` (используется по умолчанию)
  ///
  /// Может выбросить [FileSystemException], если не удалось записать файл.
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
