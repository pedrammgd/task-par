import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:task_par/presentation/routes/page_path.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _navigateOtherScreen();
    super.initState();
  }

  void _navigateOtherScreen() {
    Future.delayed(Duration(seconds: 3))
        .then((_) => Navigator.pushReplacementNamed(context, PagePath.base));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Image.asset(
              'assets/img/task_par_icon.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            )),
            Shimmer.fromColors(
                baseColor: Colors.black,
                highlightColor: Colors.grey[300]!,
                child: const Text(
                  'تسک پَر',
                  style: TextStyle(fontSize: 17),
                )),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
