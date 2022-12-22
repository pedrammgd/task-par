import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SubscriptionCardWidget extends StatelessWidget {
  const SubscriptionCardWidget(
      {Key? key,
      required this.onTap,
      required this.icon,
      required this.title,
      required this.description,
      required this.price,
      required this.backGroundColor,
      this.isSelected = false,
      required this.isLoading})
      : super(key: key);
  final Function()? onTap;
  final String icon;
  final String title;
  final String description;
  final String price;
  final Color? backGroundColor;
  final bool isSelected;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Ink(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: backGroundColor,
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
                width: 0,
              ),
            ),
            child: Row(children: [
              SizedBox(width: 8),
              Image.asset(
                icon,
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading
                        ? _shimmer(width: 50)
                        : Text(
                            title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    SizedBox(height: 4),
                    isLoading
                        ? _shimmer(width: 120)
                        : Text(description,
                            style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              SizedBox(width: 8),
              isLoading
                  ? _shimmer(width: 70)
                  : Text(
                      price,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
              SizedBox(width: 8),
            ]),
          )),
    );
  }

  Widget _shimmer({required double width}) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white60,
        child: Container(width: width, height: 10, color: Colors.blue),
      ),
    );
  }
}
