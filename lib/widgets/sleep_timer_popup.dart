import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SleepTimerPopup extends StatelessWidget {
  SleepTimerPopup({Key? key, required this.showCancelOption}) : super(key: key);

  bool showCancelOption;

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.bedtime,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Sleep Timer",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildSleepButton(1, context),
                          _buildSleepButton(30, context),
                          _buildSleepButton(60, context),
                        ],
                      ),
                      if (showCancelOption)
                        TextButton(
                          child: const Text(
                            "Cancel Timer",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            HapticFeedback.vibrate();
                            Navigator.pop(context, 0);
                          },
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
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
        ),
      ),
    );
  }

  Widget _buildSleepButton(int minutes, BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        Navigator.pop(context, minutes);
      },
      child: Container(
        width: 90,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF79725),
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          "$minutes Mins",
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
