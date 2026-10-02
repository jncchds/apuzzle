import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/backup.dart';
import '../core/day.dart';
import '../core/persistence.dart';
import '../l10n/l10n.dart';

/// Settings section to move progress to another device, as a file or as
/// text on the clipboard. Importing merges ([ProgressTransfer.importProgress]).
class TransferTiles extends StatelessWidget {
  const TransferTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      children: [
        ListTile(
          title: Text(l.transferTitle, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          subtitle: Text(l.transferHint),
        ),
        ListTile(
          leading: const Icon(Icons.file_upload_outlined),
          title: Text(l.transferExportFile),
          onTap: () => _exportFile(context),
        ),
        ListTile(
          leading: const Icon(Icons.file_download_outlined),
          title: Text(l.transferImportFile),
          onTap: () => _importFile(context),
        ),
        ListTile(leading: const Icon(Icons.copy), title: Text(l.transferCopy), onTap: () => _copy(context)),
        ListTile(leading: const Icon(Icons.content_paste), title: Text(l.transferPaste), onTap: () => _paste(context)),
      ],
    );
  }

  static String _code(BuildContext context) => ProgressCode.encode(context.read<GameStore>().exportProgress());

  static void _toast(BuildContext context, String text) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _exportFile(BuildContext context) async {
    final l = context.l10n;
    try {
      final saved = await FilePicker.saveFile(
        fileName: 'apuzzle-${Day.today()}.apuzzle',
        bytes: utf8.encode(_code(context)),
      );
      if (saved != null && context.mounted) _toast(context, l.transferSaved);
    } on Object {
      if (context.mounted) _toast(context, l.transferSaveFailed);
    }
  }

  Future<void> _importFile(BuildContext context) async {
    final file = await FilePicker.pickFile();
    if (file == null || !context.mounted) return;
    final text = utf8.decode(await file.readAsBytes(), allowMalformed: true);
    if (context.mounted) await _import(context, text);
  }

  Future<void> _copy(BuildContext context) async {
    final l = context.l10n;
    try {
      await Clipboard.setData(ClipboardData(text: _code(context)));
    } on PlatformException {
      if (context.mounted) _toast(context, l.transferCopyFailed);
      return;
    }
    if (context.mounted) _toast(context, l.transferCopied);
  }

  Future<void> _paste(BuildContext context) async {
    String? text;
    try {
      text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    } on PlatformException {
      text = null; // the browser refused to read the clipboard
    }
    if (context.mounted) await _import(context, text ?? '');
  }

  Future<void> _import(BuildContext context, String text) async {
    final l = context.l10n;
    final store = context.read<GameStore>();
    final data = ProgressCode.decode(text);
    int changed;
    try {
      if (data == null) throw const FormatException();
      changed = await store.importProgress(data);
    } on FormatException {
      if (context.mounted) _toast(context, l.transferBadData);
      return;
    }
    if (context.mounted) _toast(context, changed == 0 ? l.transferNothingNew : l.transferImported(changed));
  }
}
