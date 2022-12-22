import 'package:flutter/material.dart';
import 'package:task_par/presentation/utils/utils.dart';

class WideAppBar extends StatelessWidget {
  const WideAppBar({
    Key? key,
    required this.tag,
    required this.title,
    required this.gradient,
    required this.child,
    this.actions,
    this.color,
  }) : super(key: key);

  final String tag;
  final String title;
  final Color gradient;
  final Widget child;
  final List<Widget>? actions;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,

      title: Hero(
        tag: Keys.heroTitleCategory + tag,
        child: Text(
          title,
          style: AppTheme.headline2.withWhite.copyWith(color: color),
        ),
      ),
      actions: actions, foregroundColor: color,
      backgroundColor: gradient,
      // gradient.colors[0].mix(gradient.colors[1], 0.5),
      stretch: true,
      shadowColor: gradient,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            // gradient: gradient.withDiagonalGradient,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: child,
        ),
      ),
    );
  }
}
