import 'package:xml/xml.dart';

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
