import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pueblo_vista/models/stream_quality_model.dart';
import 'package:pueblo_vista/widgets/unlock_all_perks.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;
Offerings? offerings;
bool isPro = false;

List<StreamQualityModel> streamQualityOptions = [
  StreamQualityModel(
    title: "Audiophile",
    description: "High quality audio stream",
    url: "https://pueblovista.fm/radio/8000/audiophile.mp3",
  ),
  StreamQualityModel(
    title: "Standard",
    description: "Standard quality for solid bandwidth",
    url: "https://pueblovista.fm/radio/8000/standard.mp3",
  ),
  StreamQualityModel(
    title: "Data saver",
    description: "Lower quality, perfect for low bandwidth",
    url: "https://pueblovista.fm/radio/8000/datasaver.mp3",
  )
];

Future<void> initGlobals() async {
  prefs = await SharedPreferences.getInstance();
  try {
    print("Init offerings");
    offerings = await Purchases.getOfferings();
    if (offerings!.current != null) {
      print("Offerings set");
    }
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      if (purchaserInfo.entitlements.all["PVRadio Premium"] != null && purchaserInfo.entitlements.all["PVRadio Premium"]!.isActive) {
        isPro = true;
      }
    } on PlatformException catch (e) {
      // Error fetching purchaser info
    }
  } on PlatformException catch (e) {
    print(e);
  }
}

void showSubMenu(BuildContext context) {
  HapticFeedback.heavyImpact();
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
         
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const UnlockAllPerks(
              whiteBG: true,
            ),
          ),
        ),
      );
    },
  );
}
