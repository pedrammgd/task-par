import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task_par/presentation/utils/app_theme.dart';
import 'package:task_par/presentation/utils/constants.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
          child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ))
          // LottieBuilder.asset(Resources.loading,
          //     height: MediaQuery.of(context).size.height * 0.2),
          ),
    );
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: LottieBuilder.asset(
          Resources.empty,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      ),
    );
  }
}

class FailureWidget extends StatelessWidget {
  final String message;

  const FailureWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(message);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(Resources.error,
                height: MediaQuery.of(context).size.height * 0.12),
            SizedBox(height: 20),
            Text(message, style: AppTheme.text1),
          ],
        ),
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(Resources.search,
                height: MediaQuery.of(context).size.height * 0.2),
            SizedBox(height: 20),
            Text("جستجوی تسک", style: AppTheme.text1),
          ],
        ),
      ),
    );
  }
}

class GarbageWidget extends StatelessWidget {
  const GarbageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Center(
        child: LottieBuilder.asset(Resources.garbage,
            height: MediaQuery.of(context).size.height * 0.2),
      ),
    );
  }
}
