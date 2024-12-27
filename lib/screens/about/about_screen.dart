import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfo/components/myfo_tag.dart';
import 'package:myfo/providers/my_info_provider.dart';
import 'package:myfo/screens/about/theme_setting_screen.dart';
import 'package:provider/provider.dart';

import '../../themes/myfo_tag_decoration.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('현재 버전',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('1.0.0')
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('피드백',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text('gkscodus11@gmail.com')
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
                          const Text('테마',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 3.0),
                            // margin: const EdgeInsets.only(bottom: 4.0),
                            decoration: customDecorations?.defaultBoxDecoration,
                            child: const Text('업데이트 예정',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12)),
                          )
                        ],
                      ),
                      GestureDetector(
                        child: Row(
                          children: [
                            Text(my.themeName == 'Default' ? '기본' : '기본'),
                            // const Icon(CupertinoIcons.forward),
                          ],
                        ),
                        // onTap: () => Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => ThemeSettingScreen(),
                        //     )),
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
