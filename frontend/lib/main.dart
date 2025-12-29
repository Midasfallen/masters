import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'app.dart';

void main() {
  // Configure timeago for Russian locale
  timeago.setLocaleMessages('ru', timeago.RuMessages());

  runApp(
    const ProviderScope(
      child: ServicePlatformApp(),
    ),
  );
}
