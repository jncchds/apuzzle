import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/puzzle_code.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'app_router.dart';

Future<void> copyWithToast(BuildContext context, String text, String message) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
}

/// Asks for a puzzle code and opens that puzzle (in place of the current one).
Future<void> showEnterCodeDialog(BuildContext context) async {
  final code = await showDialog<PuzzleCode>(context: context, builder: (_) => const _EnterCodeDialog());
  if (code == null || !context.mounted) return;
  AppRouterDelegate.of(context).openGame(code.type, code.params);
}

class _EnterCodeDialog extends StatefulWidget {
  const _EnterCodeDialog();

  @override
  State<_EnterCodeDialog> createState() => _EnterCodeDialogState();
}

class _EnterCodeDialogState extends State<_EnterCodeDialog> {
  final _text = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) return;
    setState(() {
      // Pull the code out of a shared message or link.
      _text.text = PuzzleCode.find(text) ?? text;
      _error = null;
    });
  }

  void _submit() {
    try {
      Navigator.pop(context, PuzzleCode.parse(_text.text, puzzleTypes));
    } on PuzzleCodeException catch (e) {
      setState(() => _error = e.describe(context.l10n));
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(context.l10n.playCode),
        content: TextField(
          controller: _text,
          autofocus: true,
          autocorrect: false,
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            hintText: PuzzleCode.example,
            errorText: _error,
            errorMaxLines: 3,
            suffixIcon: IconButton(icon: const Icon(Icons.content_paste_rounded), tooltip: context.l10n.paste, onPressed: _paste),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(context.l10n.cancel)),
          FilledButton(onPressed: _submit, child: Text(context.l10n.play)),
        ],
      );
}
