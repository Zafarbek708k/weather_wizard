import 'dart:async';
import 'package:flutter/services.dart';
import 'package:l/l.dart';
import 'package:weather_wizard/setup.dart';
import 'app.dart';

void run() => l.capture<void>(
      () => runZonedGuarded<void>(
        () async {
          await setup();
          await SystemChrome.setPreferredOrientations([]).then(
            (_) => App.run(),
          );
        },
        (final error, final stackTree) {
          l.e("l_capture error section");
          l.e("io_top_level_error: $error && $stackTree", stackTree);
        },
      ),
      const LogOptions(
        printColors: true,
        handlePrint: true,
        outputInRelease: true,
      ),
    );
