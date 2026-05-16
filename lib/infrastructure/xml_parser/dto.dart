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

  bool get isPopulated =>
      docNumber.isNotEmpty &&
      sellerName.isNotEmpty &&
      buyerName.isNotEmpty &&
      totalAmount.isNotEmpty;
}
