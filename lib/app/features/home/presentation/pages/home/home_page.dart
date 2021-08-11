import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/repositories/animated_background.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: AnimatedBackground(
        behaviour: RandomParticleBehaviour(),
        vsync: controller,
        child: Container(),
        // child: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       Column(
        //         children: const <Widget>[
        //           Text(
        //             'JOGADOR',
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               color: Colors.pink,
        //               fontSize: 40,
        //               fontStyle: FontStyle.normal,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           Text(
        //             'THE POP BUBBLES',
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //               color: Colors.black,
        //               fontSize: 25,
        //               fontStyle: FontStyle.normal,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //         ],
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.all(32),
        //         child: OutlinedButton(
        //           style: ButtonStyle(
        //             shape: MaterialStateProperty.all(
        //               RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(18),
        //               ),
        //             ),
        //             visualDensity: VisualDensity.adaptivePlatformDensity,
        //             backgroundColor: MaterialStateProperty.all(Colors.black),
        //           ),
        //           onPressed: () {},
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: const <Widget>[
        //               Icon(
        //                 CupertinoIcons.play_fill,
        //                 color: Colors.pink,
        //                 size: 50,
        //               ),
        //               Text(
        //                 'PLAY',
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   color: Colors.pink,
        //                   fontSize: 50,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
      ),
      // GetBuilder<HomeController>(
      //   builder: (HomeController get) => CustomPaint(
      //     foregroundPainter: BubblePainter(
      //       bubbles: get.bubbles,
      //       controller: get.animationController,
      //     ),
      //     size: Size(
      //       MediaQuery.of(context).size.width,
      //       MediaQuery.of(context).size.height,
      //     ),
      //   ),
      // ),
    );
  }
}
