import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mini_service_booking_app/core/routes/app_pages.dart';
import 'package:mini_service_booking_app/core/themes/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool isConnected = false;
  bool isTrying = true;
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    const startPosition = Offset(0, 100);
    const endPosition = Offset(0, 0);
    final curvedAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeOut,
    );
    _animation = Tween<Offset>(
      begin: startPosition,
      end: endPosition,
    ).animate(curvedAnimation);
   
    _animationController!.forward();

  Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed(Routes.login);
    });
  }

  showNoInternetSnackbar() {
    SnackBar snack = SnackBar(
      duration: const Duration(days: 1),
      content: Row(
        children: [
          const Expanded(
            flex: 1,
            child: Icon(Icons.wifi_off, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Expanded(
            flex: 4,
            child: Text(
              "You are offline!",
              softWrap: true,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () {
                setState(() {
                  isTrying = false;
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: const Text("Try again"),
            ),
          ),
        ],
      ),
    );
    setState(() {
      isTrying = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation!,
          builder: (context, child) {
            return Transform.translate(
              offset: _animation!.value,
              child: Opacity(
                opacity: _animationController!.value,
                child: Image.asset("assets/images/app_icon.png", height: 400),

                // const Text(
                //   "LIQ",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 60,
                //       fontWeight: FontWeight.w900),
                // ),
              ),
            );
          },
        ),
      ),
    );
  }
}
