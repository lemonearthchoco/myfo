import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myfo/providers/my_info_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../themes/myfo_colors.dart';

class LanguageSettingScreen extends StatefulWidget {
  const LanguageSettingScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreen();
}

class _LanguageSettingScreen extends State<LanguageSettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(AppLocalizations.of(context)!.about_language),
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<MyInfoProvider>(builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("English"),
                  trailing: provider.myInfo.language == "en"
                      ? const Icon(Icons.check, color: MyfoColors.primary)
                      : null,
                  onTap: () {
                    provider.setLanguage("en");
                  },
                ),
                ListTile(
                  title: const Text("한국어"),
                  trailing: provider.myInfo.language == "ko"
                      ? const Icon(Icons.check, color: MyfoColors.primary)
                      : null,
                  onTap: () {
                    provider.setLanguage("ko");
                  },
                ),
              ],
            ),
          );
        }));
  }
}
