import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practical/screen/media_list_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirectNext();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: FlutterLogo()));
  }

  void redirectNext() async{
    await Future.delayed(Duration(seconds: 3));
    Get.off(MediaListScreen());
  }
}
