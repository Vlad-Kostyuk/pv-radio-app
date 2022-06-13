import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:pueblo_vista/global.dart';
import 'package:pueblo_vista/screens/share_popup/share_popup.dart';
import 'package:pueblo_vista/screens/start_screen.dart';
import 'package:pueblo_vista/utils.dart';
import 'package:pueblo_vista/widgets/music_visualiser.dart';
import 'package:pueblo_vista/screens/settings_popup/settings_popup.dart';
import 'package:pueblo_vista/widgets/sleep_timer_popup.dart';
import 'package:pueblo_vista/widgets/unlock_all_perks.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin {
  final player = AudioPlayer();
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://pueblovista.fm/api/live/nowplaying/pueblo_vista_fm'),
  );
  AnimationController? _playPauseController;

  MediaItem? _mediaItem;
  int _elapsed = 0;
  int _previousElapsed = 0;
  Timer? _secondTimer;
  int _streamQuality = 1;
  bool _disableArtwork = true;
  bool _streamAutoplay = true;

  DateTime? _shouldStop;

  @override
  void initState() {
    _playPauseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) => _checkFirstBoot());
  }

  Future<void> initPlatformState() async {
    print("Init platform state");
    await Purchases.setDebugLogsEnabled(true);

    if (Platform.isAndroid) {
      await Purchases.setup("goog_sMAnLFjzmBLhOUENdVqyeEyPxYu");
    } else if (Platform.isIOS) {
      await Purchases.setup("appl_yXjwIjDAtNaCBMgrmlLJbuNTOrN");
    }
  }

  Future<void> _setupApp() async {
    print("Init platform state 1");
    await initPlatformState();
    print("Setting up app");
    await initGlobals();
  }

  void _checkFirstBoot() async {
    await _setupApp();
    _startPlayback();

    if (prefs!.getBool('first') != null) {
      showCupertinoModalPopup(
        builder: (BuildContext context) {
          return const StartScreen();
        },
        context: context,
      );
      prefs!.setBool('first', true);
    } else {
      int _launches = prefs!.getInt('launches') ?? 0;
      _launches++;

      if (_launches >= 5) {
        showSubMenu(context);
        _launches = 0;
      }

      prefs!.setInt('launches', _launches);
    }
  }


  @override
  void dispose() {
    _secondTimer!.cancel();
    super.dispose();
  }

  void _startPlayback() async {
    _streamQuality = prefs!.getInt('streamQuality') ?? 1;
    _disableArtwork = prefs!.getBool('disableArtwork') ?? false;
    _streamAutoplay = prefs!.getBool('streamAutoplay') ?? true;
    player.setAudioSource(
      AudioSource.uri(
        Uri.parse(
          streamQualityOptions[_streamQuality].url,
        ),
        tag: MediaItem(
            id: "1",
            artist: "Pueblo Vista Radio",
            artUri: Uri.parse(
              "https://yt3.ggpht.com/hzRVDF0urn645vFlGHqiCg73lzOSyx6hioGUCc71JlbrfJrWorwn0ZP0JCJgtKWUGZRK_rZKug8=s176-c-k-c0x00ffffff-no-rj",
            ),
            title: "Lofi hip hop radio 🌺 chill beats to relax / study"),
      ),
    );
    if (_streamAutoplay) {
      player.play();
    } else {
      _playPauseController!.forward();
    }
    setState(() {});
  }

  void _resetValues() {
    // this function re-inits player-related settings
    _streamQuality = prefs!.getInt('streamQuality') ?? 1;
    _disableArtwork = prefs!.getBool('disableArtwork') ?? false;
    _streamAutoplay = prefs!.getBool('streamAutoplay') ?? true;
    // if (player.playing) {
    //   player.setAudioSource(
    //     AudioSource.uri(
    //       Uri.parse(
    //         streamQualityOptions[_streamQuality].url,
    //       ),
    //       tag: _mediaItem,
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: player.playing
                ? const [
                    Color.fromRGBO(74, 107, 147, 1),
                    Color.fromRGBO(98, 59, 101, 1),
                  ]
                : const [
                    Color.fromARGB(255, 38, 56, 77),
                    Color.fromARGB(255, 57, 34, 58),
                  ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: StreamBuilder<dynamic>(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                  ),
                );
              }

              var _stationData = jsonDecode(snapshot.data);

              if (_previousElapsed != _stationData['now_playing']['elapsed']) {
                _elapsed = _stationData['now_playing']['elapsed'];
                _previousElapsed = _stationData['now_playing']['elapsed'];
                if (_secondTimer != null && _secondTimer!.isActive) {
                  // we need to cancel the existing timer to ensure that seconds don't flicker around out of sync
                  _secondTimer!.cancel();
                }
                _secondTimer = Timer.periodic(const Duration(seconds: 1), (v) {
                  setState(() {
                    _elapsed++; // as the websocket doesn't update every second - but the UI needs to - we increase the elapsed duration
                  });
                  if (_shouldStop != null && _shouldStop!.difference(DateTime.now()).inSeconds <= 0) {
                    player.stop();
                    _shouldStop = null;
                    _playPauseController!.forward();
                    setState(() {});
                  }
                });
              }

              // check if the audiosource has changed and we need to update the audio service
              // MediaItem _currentMediaItem =

              // if (_currentMediaItem != _mediaItem) {
              //   _mediaItem = _currentMediaItem;
              //   _resetValues();
              // }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        opacity: player.playing ? 1 : 0,
                        child: Row(
                          children: [
                            const MusicVisualiser(),
                            const SizedBox(width: 4.0),
                            Text(
                              "${_stationData['listeners']['current']} people listening now",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.width * 0.85,
                        child: Center(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                            opacity: player.playing ? 1 : 0.65,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                              width: player.playing ? MediaQuery.of(context).size.width * 0.85 : MediaQuery.of(context).size.width * 0.6,
                              height: player.playing ? MediaQuery.of(context).size.width * 0.85 : MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 16),
                                    color: Colors.black.withOpacity(0.45),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _disableArtwork
                                    ? Image.asset(
                                        "assets/logo-icon.png",
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: _stationData['now_playing']['song']['art'],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 42.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 24,
                            child: TextScroll(
                              "${_stationData['now_playing']['song']['title']}    ",
                              velocity: const Velocity(
                                pixelsPerSecond: Offset(20, 0),
                              ),
                              delayBefore: const Duration(seconds: 3),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                              // softWrap: true,
                            ),
                          ),
                          Text(
                            _stationData['now_playing']['song']['artist'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return SharePopup(song: _stationData['now_playing']['song']);
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white.withOpacity(0.12),
                          child: const Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 42.0),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 24,
                        height: 4,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.31),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(seconds: 1),
                              width: _elapsed / _stationData['now_playing']['duration'] * (MediaQuery.of(context).size.width - 48),
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: const Duration(seconds: 1),
                              top: -2,
                              left: _elapsed / _stationData['now_playing']['duration'] * (MediaQuery.of(context).size.width - 48) - 4,
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getStringDuration(
                              Duration(
                                seconds: _elapsed,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "-${getStringDuration(Duration(seconds: _stationData['now_playing']['duration'] - _elapsed))}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 42.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.none,
                        height: 53,
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (isPro) {
                                  HapticFeedback.mediumImpact();
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SleepTimerPopup(
                                        showCancelOption: _shouldStop != null,
                                      );
                                    },
                                  ).then((v) {
                                    if (v != null) {
                                      if (v == 0) {
                                        _shouldStop = null;
                                      } else {
                                        _shouldStop = DateTime.now().add(Duration(minutes: v));
                                      }
                                      setState(() {});
                                    }
                                  });
                                } else {
                                  showSubMenu(context);
                                }
                              },
                              icon: const Icon(
                                CupertinoIcons.moon_zzz_fill,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            if (_shouldStop != null)
                              Text(
                                getStringDuration(
                                  _shouldStop!.difference(
                                    DateTime.now(),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFFF99624),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: const Icon(
                      //     Icons.airplay,
                      //     color: Colors.white,
                      //     size: 28,
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          if (!player.playing) {
                            player.setAudioSource(
                              AudioSource.uri(
                                Uri.parse(
                                  streamQualityOptions[_streamQuality].url,
                                ),
                                tag: _mediaItem,
                              ),
                            );
                          }
                          player.playing ? player.stop() : player.play();
                          if (player.playing) {
                            _playPauseController!.reverse();
                          } else {
                            _playPauseController!.forward();
                          }
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 37,
                          backgroundColor: Colors.white,
                          child: AnimatedIcon(
                            icon: AnimatedIcons.pause_play,
                            progress: _playPauseController!,
                            color: Colors.black,
                            size: 42,
                          ),
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(
                      //     CupertinoIcons.list_bullet,
                      //     color: Colors.white,
                      //     size: 28,
                      //   ),
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return const SettingsPopup();
                            },
                          ).then((v) {
                            _resetValues();
                          });
                        },
                        icon: const Icon(
                          CupertinoIcons.settings_solid,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
