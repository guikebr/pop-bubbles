import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: const <Widget>[
                SizedBox(height: 200),
                Text(
                  'GUIKE',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 40,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'THE POP BUBBLES',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          GetBuilder<HomeController>(
            builder: (HomeController get) => SafeArea(
              child: CustomPaint(
                foregroundPainter: BubblePainter(
                  bubbles: get.bubbles,
                  controller: get.animationController,
                ),
                size: Size(Get.size.width, Get.size.height),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
