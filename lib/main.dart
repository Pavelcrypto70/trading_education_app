import 'package:flutter/material.dart';
import 'app.dart';
import 'services/locale_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleService.instance.load();
  runApp(const TradeMasterApp());
}
