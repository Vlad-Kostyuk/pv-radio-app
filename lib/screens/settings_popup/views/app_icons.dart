import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:pueblo_vista/global.dart';

class AppIcons extends StatefulWidget {
  const AppIcons({Key? key}) : super(key: key);

  @override
  State<AppIcons> createState() => _AppIconsState();
}

class _AppIconsState extends State<AppIcons> {
  int _currentIcon = 0;

  @override
  void initState() {
    _currentIcon = prefs!.getInt('currentIcon') ?? 0;

    super.initState();
  }

  final List<String> _premiumIcons = ["black", "blue", "pvm", "white"];
  final List<String> _standardIcons = ["casette", "yellow", "turntable", "yellowturntable"];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          const SizedBox(height: 6.0),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Text(
                    "STANDARD ICONS",
                    style: TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontWeight: FontWeight.w800,
                      fontSize: 8,
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    bottom: 12.0,
                  ),
                  shrinkWrap: true,
                  children: _standardIcons.map<Widget>((v) {
                    return GestureDetector(
                      onTap: () async {
                        HapticFeedback.heavyImpact();
                        try {
                          if (await FlutterDynamicIcon.supportsAlternateIcons) {
                            await FlutterDynamicIcon.setAlternateIconName(v);
                            print("App icon change successful");
                            return;
                          }
                        } on PlatformException catch (e) {
                          print("Failed to change app icon");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/$v@2x.png'),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: Text(
                    "PREMIUM ICONS",
                    style: TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontWeight: FontWeight.w800,
                      fontSize: 8,
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    bottom: 12.0,
                  ),
                  shrinkWrap: true,
                  children: _premiumIcons.map<Widget>((v) {
                    return GestureDetector(
                      onTap: () async {
                        if (isPro) {
                          HapticFeedback.heavyImpact();
                          try {
                            if (await FlutterDynamicIcon.supportsAlternateIcons) {
                              await FlutterDynamicIcon.setAlternateIconName(v);
                              print("App icon change successful");
                              return;
                            }
                          } on PlatformException catch (e) {
                            print("Failed to change app icon");
                          }
                        } else {
                          showSubMenu(context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/icons/$v@2x.png'),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
