import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pueblo_vista/global.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class UnlockAllPerks extends StatefulWidget {
  const UnlockAllPerks({Key? key, this.whiteBG}) : super(key: key);

  final bool? whiteBG;

  @override
  State<UnlockAllPerks> createState() => _UnlockAllPerksState();
}

class _UnlockAllPerksState extends State<UnlockAllPerks> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Unlock all perks!",
                      style: TextStyle(
                        color: Color(0xFFF89820),
                        fontWeight: FontWeight.w900,
                        fontSize: 26.0,
                      ),
                    ),
                  ),
                  if (widget.whiteBG != null && widget.whiteBG == true)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12.0),
              Text(
                "Enhance your uninterrupted and ad-free listening experience by subscribing and we will reward you with a bunch of goodies and exclusive perks like:",
                style: TextStyle(
                  color: widget.whiteBG != null && widget.whiteBG == true ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 12.0,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                "• Choose playback quality\n• Sleep & Pomodoro timer\n• Favorite tracks list\n• Custom app icons\n• Unique wallpapers\n• And more updates!",
                style: TextStyle(
                  color: widget.whiteBG != null && widget.whiteBG == true ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 12.0),
              if (_isLoading)
                SizedBox(
                  height: 100,
                  child: Center(
                    child: CupertinoActivityIndicator(
                      color: widget.whiteBG != null && widget.whiteBG == true ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              if (offerings != null && !_isLoading)
                Column(
                  children: offerings!.all.keys.map<Widget>((v) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              PurchaserInfo purchaserInfo = await Purchases.purchasePackage(offerings!.all[v]!.monthly!);
                              var isPro = purchaserInfo.entitlements.all["PVRadio Premium"]!.isActive;
                              if (isPro) {
                                Navigator.pop(context);
                              }
                            } on PlatformException catch (e) {
                              var errorCode = PurchasesErrorHelper.getErrorCode(e);
                              if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              }
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF89820),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${offerings!.all[v]!.monthly!.product.priceString}/month",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Text(
                                  "( all perks instantly available )",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        GestureDetector(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              PurchaserInfo purchaserInfo = await Purchases.purchasePackage(offerings!.all[v]!.annual!);
                              var isPro = purchaserInfo.entitlements.all["PVRadio Premium"]!.isActive;
                              if (isPro) {
                                Navigator.pop(context);
                              }
                            } on PlatformException catch (e) {
                              var errorCode = PurchasesErrorHelper.getErrorCode(e);
                              if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                  ),
                                );
                              }
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF89820),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${offerings!.all[v]!.annual!.product.priceString}/year",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Text(
                                  "( 7 day free trial. Save 45% annually )",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              const SizedBox(height: 12.0),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.whiteBG != null && widget.whiteBG == true ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Keep using it for free!",
                        style: TextStyle(
                          color: widget.whiteBG != null && widget.whiteBG == true ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "( standard perks & background playback )",
                        style: TextStyle(
                          color: widget.whiteBG != null && widget.whiteBG == true ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  child: Text(
                    "Restore Purchases",
                    style: TextStyle(
                      color: widget.whiteBG != null && widget.whiteBG == true ? Colors.black : Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _isLoading = true;
                      
                    });
                    try {
                      PurchaserInfo restoredInfo = await Purchases.restoreTransactions();
                      if (restoredInfo.entitlements.all["PVRadio Premium"]!.isActive) {
                        setState(() {
                          isPro = true;
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("No previous purchase found."),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Error. Please try again."),
                        ),
                      );
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
