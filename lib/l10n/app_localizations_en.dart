// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'XML Merger';

  @override
  String get cardFirstTitle => 'Ozon UTD';

  @override
  String get cardSecondTitle => '1c UTD';

  @override
  String get sellerOrganization => 'Seller Organization';

  @override
  String get buyerOrganization => 'Buyer Organization';

  @override
  String get documentNumber => 'Document Number';

  @override
  String get invoiceNumber => 'Invoice Number';

  @override
  String get totalAmount => 'Total Amount (with VAT)';

  @override
  String get date => 'Date';

  @override
  String get firstButton => 'Save Ozon UTD';

  @override
  String get secondButton => 'Merge fields from 1c UTD';

  @override
  String get cardCommonDescription => 'Drop file here or click to select';

  @override
  String get notifySaveSuccess => 'File saved successfully';

  @override
  String get notifySaveError => 'Error saving file';

  @override
  String get notifyWarning => 'Warning: amounts in documents differ!';

  @override
  String get notifyMergeSuccess => 'Fields from 1c UTD merged';
}
