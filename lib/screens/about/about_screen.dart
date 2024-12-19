import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version} (Build ${packageInfo.buildNumber})';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("about",
            style: GoogleFonts.jost(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<String>(
              future: _getAppVersion(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Row(
                      children: [Text('현재 버전'), Text('Loading...')]);
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyfoText(
                            '현재 버전',
                            fontWeight: FontWeight.bold,
                          ),
                          MyfoText('1.0.0', color: Colors.black54)
                        ]),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [MyfoText('현재 버전'), MyfoText('Loading...')]),
                );
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyfoText(
                      '피드백',
                      fontWeight: FontWeight.bold,
                    ),
                    MyfoText('gkscodus11@gmail.com', color: Colors.black54)
                  ]),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MyfoText(
                        '앱 리뷰 남기기',
                        fontWeight: FontWeight.bold,
                      ),
                      Icon(CupertinoIcons.forward, color: Colors.black54),
                      // IconButton(
                      //     padding: EdgeInsets.zero,
                      //     onPressed: () => {print("App Review")},
                      //     icon: Icon(Icons.navigate_next)),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
