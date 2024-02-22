import 'package:dict_cat_archives/layouts/app_bar.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: CustomAppBar(title: Text(labelAbout)),
      body: Column(
        children: [
          isMobile
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/vision.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/images/vision.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/images/core.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                )
              : Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/vision.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/images/vision.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/images/core.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
          Expanded(
            flex: 2,
            child: Image.asset(
              'assets/images/BoD.png',
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
