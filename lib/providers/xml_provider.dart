import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:xml/xml.dart';
import '../dtos/xml_doc.dart';
import '../services/xml_service.dart';

class XmlProvider extends ChangeNotifier {
  final _xmlService = XmlService();
  XmlDocumentDto _firstXmlDto = XmlDocumentDto();
  XmlDocumentDto _secondXmlDto = XmlDocumentDto();

  String? _firstFilePath;
  String? _secondFilePath;

  XmlDocument? _firstDoc;

  XmlDocumentDto get firstDto => _firstXmlDto;

  XmlDocumentDto get secondDto => _secondXmlDto;

  bool get isBuyerValid {
    return _firstXmlDto.buyerName == _secondXmlDto.buyerName;
  }

  bool get isSellerValid {
    return _firstXmlDto.sellerName == _secondXmlDto.sellerName;
  }

  bool get isDocNumValid {
    return _firstXmlDto.docNumber == _secondXmlDto.docNumber;
  }

  bool get isInvoiceNumValid {
    return _firstXmlDto.invoiceNumber == _secondXmlDto.invoiceNumber;
  }

  bool get isTotalValid {
    return _firstXmlDto.totalAmount == _secondXmlDto.totalAmount;
  }

  bool get isDateValid {
    return _firstXmlDto.date == _secondXmlDto.date;
  }

  String? get firstPath => _firstFilePath;

  String? get secondPath => _secondFilePath;

  Future<void> loadFirstFile(String path) async {
    final doc = await _xmlService.loadDocument(path);
    _firstDoc = doc;
    _firstXmlDto = XmlDocumentDto.fromXml(doc);
    _firstFilePath = path;
    notifyListeners();
  }

  Future<void> loadSecondFile(String path) async {
    final doc = await _xmlService.loadDocument(path);
    _secondXmlDto = XmlDocumentDto.fromXml(doc);
    _secondFilePath = path;
    notifyListeners();
  }

  Future<void> _pickFile(Function(String) onLoad) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml'],
    );
    if (result?.files.single.path != null) {
      await onLoad(result!.files.single.path!);
    }
  }

  Future<void> pickFirstXmlFile() => _pickFile(loadFirstFile);

  Future<void> pickSecondXmlFile() => _pickFile(loadSecondFile);

  bool get canSave {
    if (!_firstXmlDto.isPopulated) return false;
    if (!_secondXmlDto.isPopulated) return false;

    return _firstXmlDto.docNumber == _secondXmlDto.docNumber &&
        _firstXmlDto.totalAmount == _secondXmlDto.totalAmount;
  }

  void mergeFields() {
    _firstXmlDto = XmlDocumentDto(
      buyerName: _firstXmlDto.buyerName,
      sellerName: _firstXmlDto.sellerName,
      docNumber: _secondXmlDto.docNumber,
      invoiceNumber: _secondXmlDto.invoiceNumber,
      totalAmount: _firstXmlDto.totalAmount,
      date: _firstXmlDto.date,
    );
    notifyListeners();
  }

  Future<void> saveFirstFile() async {
    if (_firstDoc == null || _firstFilePath == null) return;

    _firstXmlDto.updateXml(_firstDoc!);

    await _xmlService.saveDocument(_firstDoc!, _firstFilePath!);
  }
}
