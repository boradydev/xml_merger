import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/xml_provider.dart'; // Импортируем провайдер языка
import '../widgets/info_field.dart';
import '../widgets/pick_file_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeProvider p) => p.isDarkMode);
    final localeProvider = context.watch<LocaleProvider>();
    final xmlProvider = context.watch<XmlProvider>();
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          TextButton(
            onPressed: () {
              if (localeProvider.locale.languageCode == 'ru') {
                localeProvider.setLocale(const Locale('en'));
              } else {
                localeProvider.setLocale(const Locale('ru'));
              }
            },
            child: Text(
              localeProvider.locale.languageCode.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: // Внутри Row -> Expanded -> Column для Base
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InfoField(
                          label: l10n.sellerOrganization,
                          value: xmlProvider.firstXmlDto.sellerName,
                          isWarning: true,
                          isValid:
                              xmlProvider.firstXmlDto.sellerName ==
                              xmlProvider.secondXmlDto.sellerName,
                        ),
                        InfoField(
                          label: l10n.buyerOrganization,
                          value: xmlProvider.firstXmlDto.buyerName,
                          isWarning: true,
                          isValid:
                              xmlProvider.firstXmlDto.buyerName ==
                              xmlProvider.secondXmlDto.buyerName,
                        ),
                        InfoField(
                          label: l10n.documentNumber,
                          value: xmlProvider.firstXmlDto.docNumber,
                          isValid:
                              xmlProvider.firstXmlDto.docNumber ==
                              xmlProvider.secondXmlDto.docNumber,
                        ),
                        InfoField(
                          label: l10n.invoiceNumber,
                          value: xmlProvider.firstXmlDto.invoiceNumber,
                          isValid:
                              xmlProvider.firstXmlDto.invoiceNumber ==
                              xmlProvider.secondXmlDto.invoiceNumber,
                        ),
                        InfoField(
                          label: l10n.totalAmount,
                          value: xmlProvider.firstXmlDto.totalAmount,
                          isValid:
                              xmlProvider.firstXmlDto.totalAmount ==
                              xmlProvider.secondXmlDto.totalAmount,
                        ),
                        InfoField(
                          label: l10n.date,
                          value: xmlProvider.firstXmlDto.date,
                          isWarning: true,
                          isValid:
                              xmlProvider.firstXmlDto.date ==
                              xmlProvider.secondXmlDto.date,
                        ),
                        const SizedBox(height: 20),
                        FileSelectorCard(
                          title: l10n.cardFirstTitle,
                          description: l10n.cardCommonDescription,
                          path: xmlProvider.firstFilePath,
                          onTap: () => xmlProvider.pickFirstXmlFile(),
                          onFileDropped: (path) =>
                              xmlProvider.loadFirstFile(path),
                          icon: Icons.file_copy,
                          color: Colors.blue.shade100,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: xmlProvider.areFieldsIdentical
                              ? () => xmlProvider.saveFirstFile()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade100,
                          ),
                          icon: const Icon(Icons.save_alt),
                          label: Text(l10n.firstButton),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InfoField(
                          label: l10n.sellerOrganization,
                          value: xmlProvider.secondXmlDto.sellerName,
                          isWarning: true,
                          isValid:
                              xmlProvider.firstXmlDto.sellerName ==
                              xmlProvider.secondXmlDto.sellerName,
                        ),
                        InfoField(
                          label: l10n.buyerOrganization,
                          value: xmlProvider.secondXmlDto.buyerName,
                          isWarning: true,
                          isValid:
                              xmlProvider.firstXmlDto.buyerName ==
                              xmlProvider.secondXmlDto.buyerName,
                        ),
                        InfoField(
                          label: l10n.documentNumber,
                          value: xmlProvider.secondXmlDto.docNumber,
                          isValid:
                              xmlProvider.firstXmlDto.docNumber ==
                              xmlProvider.secondXmlDto.docNumber,
                        ),
                        InfoField(
                          label: l10n.invoiceNumber,
                          value: xmlProvider.secondXmlDto.invoiceNumber,
                          isValid:
                              xmlProvider.firstXmlDto.invoiceNumber ==
                              xmlProvider.secondXmlDto.invoiceNumber,
                        ),
                        InfoField(
                          label: l10n.totalAmount,
                          value: xmlProvider.secondXmlDto.totalAmount,
                          isValid:
                              xmlProvider.firstXmlDto.totalAmount ==
                              xmlProvider.secondXmlDto.totalAmount,
                        ),
                        InfoField(
                          label: l10n.date,
                          value: xmlProvider.secondXmlDto.date,
                          isWarning: true,
                          isValid:
                              xmlProvider.firstXmlDto.date ==
                              xmlProvider.secondXmlDto.date,
                        ),
                        const SizedBox(height: 20),
                        FileSelectorCard(
                          title: l10n.cardSecondTitle,
                          description: l10n.cardCommonDescription,
                          path: xmlProvider.secondFilePath,
                          onTap: () => xmlProvider.pickSecondXmlFile(),
                          onFileDropped: (path) =>
                              xmlProvider.loadSecondFile(path),
                          icon: Icons.add_box,
                          color: Colors.green.shade100,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: xmlProvider.secondFilePath != null
                              ? () => xmlProvider.mergeFields()
                              : null,
                          icon: const Icon(Icons.arrow_back),
                          label: Text(l10n.secondButton),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
