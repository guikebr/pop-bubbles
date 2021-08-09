import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'keys_languages.dart';
import 'locales/en_us.dart';
import 'locales/pt_br.dart';

class TranslationController extends Translations {
  static final Locale? locale = Get.deviceLocale;
  static const Locale fallbackLocale = Locale('pt', 'BR');

  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
        KeysLanguages.enUS: enUs,
        KeysLanguages.ptBR: ptBr,
      };
}
