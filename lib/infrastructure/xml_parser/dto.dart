import 'package:xml/xml.dart';

/// Объект переноса данных (DTO) для представления информации из XML-документа.
///
/// Класс инкапсулирует парсинг специфичной структуры бухгалтерского XML
/// (например, счет-фактуры) и предоставляет плоскую модель данных для UI.
class XmlDocumentDto {
  final String sellerName;
  final String buyerName;
  final String docNumber;
  final String invoiceNumber;
  final String totalAmount;
  final String date;

  XmlDocumentDto({
    this.sellerName = '',
    this.buyerName = '',
    this.docNumber = '',
    this.invoiceNumber = '',
    this.totalAmount = '',
    this.date = '',
  });

  /// Фабричный метод для создания DTO из сырого объекта [XmlDocument].
  factory XmlDocumentDto.fromXml(XmlDocument doc) {
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
  void updateXml(XmlDocument doc) {
    final docBody = doc.rootElement.findElements('Документ').firstOrNull;
    final sf = docBody?.findElements('СвСчФакт').firstOrNull;

    sf?.setAttribute('НомерДок', docNumber);

    sf
        ?.findElements('ДокПодтвОтгрНом')
        .firstOrNull
        ?.setAttribute('РеквНомерДок', invoiceNumber);
  }

  bool get isPopulated =>
      docNumber.isNotEmpty &&
      sellerName.isNotEmpty &&
      buyerName.isNotEmpty &&
      totalAmount.isNotEmpty;
}
