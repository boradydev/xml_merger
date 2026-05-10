// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'XML Слияние';

  @override
  String get cardFirstTitle => 'Озон УПД';

  @override
  String get cardSecondTitle => '1с УПД';

  @override
  String get sellerOrganization => 'Организация-продавец';

  @override
  String get buyerOrganization => 'Организация-покупатель';

  @override
  String get documentNumber => 'Номер документа';

  @override
  String get invoiceNumber => 'Номер отгрузки';

  @override
  String get totalAmount => 'Итоговая сумма (с НДС)';

  @override
  String get date => 'Дата';

  @override
  String get firstButton => 'Сохранить';

  @override
  String get secondButton => 'Перенести данные из 1c';

  @override
  String get cardCommonDescription => 'Перетащите файл сюда или нажмите для выбора';
}
