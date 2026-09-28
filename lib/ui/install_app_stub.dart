import 'package:flutter/foundation.dart';

import 'install_app.dart';

ValueNotifier<InstallMode> createInstallNotifier() => ValueNotifier(InstallMode.none);

Future<bool> promptInstall() async => false;
