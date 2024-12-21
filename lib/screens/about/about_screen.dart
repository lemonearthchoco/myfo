import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:myfo/screens/about/theme_setting_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ABOUT")
            // style: GoogleFonts.jost(
            //   fontSize: 20,
            //   fontWeight: FontWeight.bold,
            // )),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FutureBuilder<String>(
            //   future: _getAppVersion(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 20.0, vertical: 16.0),
            //         child: const Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 '현재 버전',
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               Text('1.0.0', color: Colors.black54)
            //             ]),
            //       );;
            //     } else if (snapshot.hasError) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 20.0, vertical: 16.0),
            //         child: const Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 '현재 버전',
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               Text('1.0.0', color: Colors.black54)
            //             ]),
            //       );
            //     }
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 20.0, vertical: 16.0),
            //       child:Padding(
            //     padding: const EdgeInsets.symmetric(
            //     horizontal: 20.0, vertical: 16.0),
            //     child: const Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //     Text(
            //     '현재 버전',
            //     fontWeight: FontWeight.bold,
            //     ),
            //     Text('1.0.0', color: Colors.black54)
            //     ]),
            //     );
            //   },
            // ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('현재 버전',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('1.0.0')
                  ]),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('피드백', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('gkscodus11@gmail.com')
                  ]),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('테마 설정',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      GestureDetector(
                        child:
                            Icon(CupertinoIcons.forward, color: Colors.black54),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThemeSettingScreen(),
                            )),
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
