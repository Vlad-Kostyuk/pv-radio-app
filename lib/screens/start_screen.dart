import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pueblo_vista/global.dart';
import 'package:pueblo_vista/screens/player_screen.dart';
import 'package:pueblo_vista/widgets/unlock_all_perks.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _hasAnimatedIn = false;
  PageController _pageController = PageController();
  int _currentIndex = 0;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/first-screen.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PageView(
                  onPageChanged: (v) {
                    setState(() {
                      _currentIndex = v;
                    });
                  },
                  controller: _pageController,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: Image.asset(
                            'assets/full-logo.png',
                            width: MediaQuery.of(context).size.width * 0.7,
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              margin: const EdgeInsets.all(24.0),
                              child: Column(
                                children: const [
                                  Text(
                                    "Hey! Listen...",
                                    style: TextStyle(
                                      color: Color(0xFFF89820),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 26.0,
                                    ),
                                  ),
                                  Text(
                                    "Soothing instrumentals and lush melodies with lofi hip hop undertones. The perfect aural vibes to relax, focus or study, have a cup of coffee or even sleep to.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 12.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                              },
                              child: Container(
                                width: 140,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF89820),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  "Next",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        height: 426,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const UnlockAllPerks(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
