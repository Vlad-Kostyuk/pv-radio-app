import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pueblo_vista/screens/settings_popup/views/app_icons.dart';
import 'package:pueblo_vista/screens/settings_popup/views/playback_settings.dart';

class SettingsPopup extends StatefulWidget {
  const SettingsPopup({Key? key}) : super(key: key);

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  int _currentIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Widget> _settingsScreens = const [
    AppIcons(),
    PlaybackSettings(),
  ];

  List<String> _settingsNames = const [
    "",
    "App Icons",
    "Playback Settings",
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/logo-icon.png",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Settings${_currentPage != 0 ? ' > ${_settingsNames[_currentPage]}' : ""}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Text(
                                "Pueblo Vista Radio",
                                style: TextStyle(
                                  color: Color(0xFF7D7D7D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black.withOpacity(0.12),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.black.withOpacity(0.4),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 24.0),
                  height: 1,
                  color: const Color(0xFF7D7D7D).withOpacity(0.2),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          _currentIndex = 0;
                                          _currentPage = 1;
                                        });
                                        _pageController.animateToPage(
                                          1,
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      title: const Text(
                                        "App icons",
                                      ),
                                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      color: const Color(0xFF7D7D7D).withOpacity(0.2),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        HapticFeedback.selectionClick();
                                        setState(() {
                                          _currentIndex = 1;
                                          _currentPage = 2;
                                        });
                                        _pageController.animateToPage(
                                          1,
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                      title: const Text(
                                        "Playback settings",
                                      ),
                                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 1,
                                      color: const Color(0xFF7D7D7D).withOpacity(0.2),
                                    ),
                                    const ListTile(
                                      title: Text(
                                        "Manage subscription",
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                                    ),
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   height: 1,
                                    //   color: const Color(0xFF7D7D7D).withOpacity(0.2),
                                    // ),
                                    // const ListTile(
                                    //   title: Text(
                                    //     "Send feedback",
                                    //   ),
                                    //   trailing: Icon(Icons.arrow_forward_ios_rounded),
                                    // ),
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width,
                                    //   height: 1,
                                    //   color: const Color(0xFF7D7D7D).withOpacity(0.2),
                                    // ),
                                    // const ListTile(
                                    //   title: Text(
                                    //     "Rate Pueblo Vista Radio",
                                    //   ),
                                    //   trailing: Icon(Icons.arrow_forward_ios_rounded),
                                    // ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEEE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const ListTile(
                                  title: Text(
                                    "App Version",
                                  ),
                                  trailing: Text("2022.05"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _settingsScreens[_currentIndex],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
