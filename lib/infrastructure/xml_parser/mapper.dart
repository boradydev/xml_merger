import 'package:xml/xml.dart';
import 'package:xml_merger/infrastructure/xml_parser/dto.dart';

/// Маппер для преобразования между XML-структурами и чистыми моделями данных.
///
/// Инкапсулирует в себе знание о специфичных тегах XML-документа.
class XmlMapper {
  /// Метод для создания DTO из сырого объекта [XmlDocument].
  static XmlDocumentDto fromXml(XmlDocument doc) {
    final docBody = doc.rootElement.findElements('Документ').firstOrNull;
    final sf = docBody?.findElements('СвСчФакт').firstOrNull;

    String getOrg(XmlElement? parent) =>
        parent
            ?.findElements('ИдСв')
            .firstOrNull
            ?.findElements('СвЮЛУч')
            .firstOrNull
            ?.getAttribute('НаимОрг') ??
        '';

    return XmlDocumentDto(
      sellerName: getOrg(sf?.findElements('СвПрод').firstOrNull),
      buyerName: getOrg(sf?.findElements('СвПокуп').firstOrNull),
      docNumber: sf?.getAttribute('НомерДок') ?? '',
      date: sf?.getAttribute('ДатаДок') ?? '',
      invoiceNumber:
          sf
              ?.findElements('ДокПодтвОтгрНом')
              .firstOrNull
              ?.getAttribute('РеквНомерДок') ??
          '',
      totalAmount:
          docBody
              ?.findElements('ТаблСчФакт')
              .firstOrNull
              ?.findElements('ВсегоОпл')
              .firstOrNull
              ?.getAttribute('СтТовУчНалВсего') ??
          '',
    );
  }

  /// Модифицирует атрибуты оригинального XML-дерева
  /// для последующего сохранения файла на диск.
  static void updateXml(XmlDocument doc, XmlDocumentDto dto) {
    final docBody = doc.rootElement.findElements('Документ').firstOrNull;
    final sf = docBody?.findElements('СвСчФакт').firstOrNull;

    sf?.setAttribute('НомерДок', dto.docNumber);

    sf
        ?.findElements('ДокПодтвОтгрНом')
        .firstOrNull
        ?.setAttribute('РеквНомерДок', dto.invoiceNumber);
  }
}
