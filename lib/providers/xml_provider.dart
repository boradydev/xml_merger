import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:windows1251/windows1251.dart';
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
  XmlDocument? _secondDoc;

  XmlDocumentDto get firstXmlDto => _firstXmlDto;

  XmlDocumentDto get secondXmlDto => _secondXmlDto;

  String? get firstFilePath => _firstFilePath;

  String? get secondFilePath => _secondFilePath;

  Future<void> loadFirstFile(String path) async {
    final doc = await _xmlService.loadDocument(path);
    _firstDoc = doc;
    _firstXmlDto = XmlDocumentDto.fromXml(doc);
    _firstFilePath = path;
    notifyListeners();
  }

  Future<void> loadSecondFile(String path) async {
    final doc = await _xmlService.loadDocument(path);
    _secondDoc = doc;
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

  bool get areFieldsIdentical {
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

    final file = File(_firstFilePath!);
    const header = '<?xml version="1.0" encoding="windows-1251"?>\n';

    final xmlContent = _firstDoc!.toXmlString(
      pretty: true,
      entityMapping: XmlDefaultEntityMapping.xml(),
    );

    final bytes = windows1251.encode(header + xmlContent);
    await file.writeAsBytes(bytes);
  }
}
