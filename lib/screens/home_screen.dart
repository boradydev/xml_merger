import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dtos/xml_doc.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../providers/xml_provider.dart';
import '../widgets/action_button_widget.dart';
import '../widgets/info_field.dart';
import '../widgets/locate_toggle_widget.dart';
import '../widgets/pick_file_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeProvider p) => p.isDarkMode);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          const LocaleToggleButton(),
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: const Row(
            children: [
              Expanded(child: XmlFileColumn(isFirst: true)),
              SizedBox(width: 20),
              Expanded(child: XmlFileColumn(isFirst: false)),
            ],
          ),
        ),
      ),
    );
  }
}

class XmlFileColumn extends StatelessWidget {
  final bool isFirst;

  const XmlFileColumn({super.key, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    final dto = context.select(
      (XmlProvider p) => isFirst ? p.firstDto : p.secondDto,
    );
    final path = context.select(
      (XmlProvider p) => isFirst ? p.firstPath : p.secondPath,
    );

    final xmlProvider = context.read<XmlProvider>();
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final canSave = context.select((XmlProvider p) => p.canSave);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InfoFieldGroup(
          dto: dto,
          isBuyerValid: context.select((XmlProvider p) => p.isBuyerValid),
          isSellerValid: context.select((XmlProvider p) => p.isSellerValid),
          isDocNumValid: context.select((XmlProvider p) => p.isDocNumValid),
          isInvoiceNumValid: context.select(
            (XmlProvider p) => p.isInvoiceNumValid,
          ),
          isTotalValid: context.select((XmlProvider p) => p.isTotalValid),
          isDateValid: context.select((XmlProvider p) => p.isDateValid),
        ),
        const SizedBox(height: 20),
        if (isFirst)
          ActionButton(
            icon: Icons.save_alt,
            label: l10n.firstButton,
            onPressed: canSave ? () => xmlProvider.saveFirstFile() : null,
            backgroundColor: colorScheme.primaryContainer,
          )
        else
          ActionButton(
            icon: Icons.arrow_back,
            label: l10n.secondButton,
            onPressed: path != null ? () => xmlProvider.mergeFields() : null,
            backgroundColor: colorScheme.tertiaryContainer,
          ),
        const SizedBox(height: 20),
        FileSelectorCard(
          title: isFirst ? l10n.cardFirstTitle : l10n.cardSecondTitle,
          description: l10n.cardCommonDescription,
          path: path,
          onTap: () => isFirst
              ? xmlProvider.pickFirstXmlFile()
              : xmlProvider.pickSecondXmlFile(),
          onFileDropped: (path) => isFirst
              ? xmlProvider.loadFirstFile(path)
              : xmlProvider.loadSecondFile(path),
          icon: isFirst ? Icons.file_copy : Icons.add_box,
          color: isFirst ? Colors.blue.shade100 : Colors.green.shade100,
        ),
      ],
    );
  }
}

class InfoFieldGroup extends StatelessWidget {
  final XmlDocumentDto dto;
  final bool isBuyerValid;
  final bool isSellerValid;
  final bool isDocNumValid;
  final bool isInvoiceNumValid;
  final bool isTotalValid;
  final bool isDateValid;

  const InfoFieldGroup({
    super.key,
    required this.dto,
    required this.isBuyerValid,
    required this.isSellerValid,
    required this.isDocNumValid,
    required this.isInvoiceNumValid,
    required this.isTotalValid,
    required this.isDateValid,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        InfoField(
          label: l10n.sellerOrganization,
          value: dto.sellerName,
          isWarning: true,
          isValid: isSellerValid,
        ),
        InfoField(
          label: l10n.buyerOrganization,
          value: dto.buyerName,
          isWarning: true,
          isValid: isBuyerValid,
        ),
        InfoField(
          label: l10n.documentNumber,
          value: dto.docNumber,
          isValid: isDocNumValid,
        ),
        InfoField(
          label: l10n.invoiceNumber,
          value: dto.invoiceNumber,
          isValid: isInvoiceNumValid,
        ),
        InfoField(
          label: l10n.totalAmount,
          value: dto.totalAmount,
          isValid: isTotalValid,
        ),
        InfoField(
          label: l10n.date,
          value: dto.date,
          isWarning: true,
          isValid: isDateValid,
        ),
      ],
    );
  }
}
