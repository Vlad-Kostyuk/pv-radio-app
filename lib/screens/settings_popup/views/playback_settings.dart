import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pueblo_vista/global.dart';

class PlaybackSettings extends StatefulWidget {
  const PlaybackSettings({Key? key}) : super(key: key);

  @override
  State<PlaybackSettings> createState() => _PlaybackSettingsState();
}

class _PlaybackSettingsState extends State<PlaybackSettings> {
  bool _disableArtwork = false;
  bool _streamAutoplay = true;
  int _streamQuality = 1;

  @override
  void initState() {
    _disableArtwork = prefs!.getBool('disableArtwork') ?? false;
    _streamAutoplay = prefs!.getBool('streamAutoplay') ?? true;
    _streamQuality = prefs!.getInt('streamQuality') ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          const SizedBox(height: 6.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
            child: Text(
              "MUSIC PLAYER",
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontWeight: FontWeight.w800,
                fontSize: 8,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    "Stream Autoplay on",
                  ),
                  trailing: CupertinoSwitch(
                    value: _streamAutoplay,
                    onChanged: (v) {
                      setState(() {
                        _streamAutoplay = v;
                      });
                      prefs!.setBool('streamAutoplay', v);
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: const Color(0xFF7D7D7D).withOpacity(0.2),
                ),
                ListTile(
                  title: const Text(
                    "Disable artwork",
                  ),
                  trailing: CupertinoSwitch(
                    value: _disableArtwork,
                    onChanged: (v) {
                      setState(() {
                        _disableArtwork = v;
                      });
                      prefs!.setBool('disableArtwork', v);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
            child: Text(
              "MUSIC PLAYER",
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontWeight: FontWeight.w800,
                fontSize: 8,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: streamQualityOptions.map<Widget>(
                (v) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          v.title,
                        ),
                        subtitle: Text(
                          v.description,
                        ),
                        trailing: CupertinoSwitch(
                          value: _streamQuality == streamQualityOptions.indexOf(v),
                          onChanged: (a) {
                            if (isPro) {
                              setState(() {
                                _streamQuality = streamQualityOptions.indexOf(v);
                              });
                              prefs!.setInt('streamQuality', streamQualityOptions.indexOf(v));
                            } else {
                              showSubMenu(context);
                            }
                          },
                        ),
                      ),
                      if (streamQualityOptions.indexOf(v) != streamQualityOptions.length-1) // avoid displaying the divider on the last option
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: const Color(0xFF7D7D7D).withOpacity(0.2),
                        ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
