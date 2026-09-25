import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/puzzle_code.dart';
import '../core/registry.dart';
import '../l10n/l10n.dart';
import 'game_screen.dart';

Future<void> copyWithToast(BuildContext context, String text, String message) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
}

/// Asks for a puzzle code and opens that puzzle. With [replace] the current
/// route (a game screen) is swapped out instead of stacked.
Future<void> showEnterCodeDialog(BuildContext context, {bool replace = false}) async {
  final code = await showDialog<PuzzleCode>(context: context, builder: (_) => const _EnterCodeDialog());
  if (code == null || !context.mounted) return;
  final route = MaterialPageRoute<void>(builder: (_) => GameScreen(type: code.type, params: code.params));
  final nav = Navigator.of(context);
  replace ? await nav.pushReplacement(route) : await nav.push(route);
}

/// Opens puzzles from share links: the link the app was launched with, and
/// links that arrive while it runs. Register it before `runApp` so it sees
/// pushed routes before [WidgetsApp] tries to treat them as named routes.
class ShareLinkHandler with WidgetsBindingObserver {
  ShareLinkHandler({required this.navigatorKey, required this.messengerKey});

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    // Web: the page URL. Android: the link's path and query arrive as the initial route.
    final initial = kIsWeb ? Uri.base.toString() : WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    if (PuzzleCode.find(initial) != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _open(initial));
    }
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async =>
      _open(routeInformation.uri.toString());

  bool _open(String link) {
    if (PuzzleCode.find(link) == null) return false;
    final nav = navigatorKey.currentState;
    if (nav == null) return false;
    try {
      final code = PuzzleCode.parse(link, puzzleTypes);
      nav.popUntil((r) => r.isFirst);
      nav.push(MaterialPageRoute<void>(builder: (_) => GameScreen(type: code.type, params: code.params)));
    } on PuzzleCodeException catch (e) {
      final l = AppLocalizations.of(nav.context);
      messengerKey.currentState?.showSnackBar(SnackBar(content: Text(l.couldNotOpenLink(e.describe(l)))));
    }
    return true;
  }
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
