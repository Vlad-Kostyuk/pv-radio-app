import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MusicVisualiser extends StatefulWidget {
  const MusicVisualiser({Key? key}) : super(key: key);

  @override
  State<MusicVisualiser> createState() => _MusicVisualiserState();
}

class _MusicVisualiserState extends State<MusicVisualiser> {
  List<double> _bars = List.generate(4, (a) => Random().nextDouble());
  Timer? _changeTimer;

  @override
  void initState() {
    super.initState();
    _changeTimer = Timer.periodic(const Duration(milliseconds: 600), (v) {
      _bars = List.generate(4, (a) => Random().nextDouble());
      setState(() {});
    });
  }

  @override
  void dispose() {
    _changeTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _bars.map<Widget>((v) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            width: 2,
            height: 10 * v,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}
