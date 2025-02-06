import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfo/components/myfo_tag.dart';
import 'package:myfo/providers/my_info_provider.dart';
import 'package:myfo/screens/about/language_setting_screen.dart';
import 'package:myfo/screens/about/theme_setting_screen.dart';
import 'package:myfo/themes/myfo_colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../themes/myfo_tag_decoration.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  void showLanguageSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: MyfoColors.secondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Consumer<MyInfoProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.about_language,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text("English"),
                    trailing: provider.myInfo.language == "en"
                        ? const Icon(Icons.check, color: MyfoColors.primary)
                        : null,
                    onTap: () {
                      provider.setLanguage("en");
                      Navigator.pop(context); // 모달 닫기
                    },
                  ),
                  ListTile(
                    title: const Text("한국어"),
                    trailing: provider.myInfo.language == "ko"
                        ? const Icon(Icons.check, color:  MyfoColors.primary)
                        : null,
                    onTap: () {
                      provider.setLanguage("ko");
                      Navigator.pop(context); // 모달 닫기
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MY")),
      body: Consumer<MyInfoProvider>(builder: (context, provider, child) {
        final my = provider.myInfo;
        final customDecorations =
            Theme.of(context).extension<MyfoTagDecoration>();

        return SingleChildScrollView(
          // padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.about_current_version,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Text('1.0.0')
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.about_feedback,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const Text('gkscodus11@gmail.com')
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                            Text(AppLocalizations.of(context)!.about_theme,
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 3.0),
                            // margin: const EdgeInsets.only(bottom: 4.0),
                            decoration: customDecorations?.defaultBoxDecoration,
                            child: Text(AppLocalizations.of(context)!.about_update_label,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12)),
                          )
                        ],
                      ),
                      GestureDetector(
                        child: Row(
                          children: [
                            Text(my.themeName == 'Default' ? AppLocalizations.of(context)!.about_theme_default : 'Default'),
                            // const Icon(CupertinoIcons.forward),
                          ],
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThemeSettingScreen(),
                            )),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.about_language,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      GestureDetector(
                        child: Row(
                          children: [
                            Text(my.language == 'ko' ? '한국어' : 'English'),
                            const SizedBox(width: 5),
                            const Icon(CupertinoIcons.forward)
                          ],
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LanguageSettingScreen(),
                            )),
                      )
                    ]),
              ),
            ],
          ),
        );
      }),
    );
  }
}
