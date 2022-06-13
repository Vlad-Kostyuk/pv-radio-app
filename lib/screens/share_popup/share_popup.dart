import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pueblo_vista/screens/settings_popup/views/app_icons.dart';
import 'package:pueblo_vista/screens/settings_popup/views/playback_settings.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SharePopup extends StatefulWidget {
  SharePopup({Key? key, required this.song}) : super(key: key);

  Map<String, dynamic> song;

  @override
  State<SharePopup> createState() => _SharePopupState();
}

class _SharePopupState extends State<SharePopup> {
  final PageController _pageController = PageController();
  GlobalKey albumArtKey = GlobalKey();

  final List<Widget> _settingsScreens = const [
    AppIcons(),
    PlaybackSettings(),
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
                  padding: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RepaintBoundary(
                        key: albumArtKey,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          widget.song['art'],
                                        )),
                                  ),
                                ),
                                const SizedBox(width: 14.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width-180,
                                      height: 18,
                                      child: Text(
                                        "${widget.song['title']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      "${widget.song['artist']}",
                                      style: const TextStyle(
                                        color: Color(0xFF7D7D7D),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: GestureDetector(
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
                                        ShareFilesAndScreenshotWidgets().shareScreenshot(albumArtKey, 1024, widget.song['title'], "${widget.song['title']}.png", "image/png", text: "I'm listening to ${widget.song['title']} by ${widget.song['artist']} on Pueblo Vista FM for iOS! Get it here: https://pueblo-vista.com");
                                      },
                                      title: const Text(
                                        "Share",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.ios_share_rounded,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              if (widget.song['custom_fields']['spotify_url'] != null && widget.song['custom_fields']['apple_music_url'] != null)
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
                                          launchUrlString(widget.song['custom_fields']['spotify_url']);
                                        },
                                        title: const Text(
                                          "Listen on Spotify",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        trailing: Image.asset(
                                          'assets/icon-spotify.png',
                                          width: 24.0,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 1,
                                        color: const Color(0xFF7D7D7D).withOpacity(0.2),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          HapticFeedback.selectionClick();
                                          launchUrlString(widget.song['custom_fields']['apple_music_url']);
                                        },
                                        title: const Text(
                                          "Listen on Apple Music",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        trailing: Image.asset(
                                          'assets/icon-apple-music.png',
                                          width: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
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
