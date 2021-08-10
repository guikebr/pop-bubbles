import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../home/presentatiom/pages/home/home_page.dart';
import 'root_controller.dart';

class RootPage extends GetView<RootController> {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
