import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(
      {required this.items,
      this.selectedIndex = 0,
      required this.onItemSelected});

  final List<FactorBottomNavigationBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((e) {
          var index = items.indexOf(e);
          return Padding(
            padding: EdgeInsets.only(left: index == 1 ? 40 : 0),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () => onItemSelected(index),
              child: SizedBox(
                // width: MediaQuery.of(context).size.width / 4,
                child: ItemsBottomNavigation(
                  isSelected: index == selectedIndex,
                  factorBottomNavigationBarItem: e,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ItemsBottomNavigation extends StatelessWidget {
  final bool isSelected;
  final FactorBottomNavigationBarItem factorBottomNavigationBarItem;

  const ItemsBottomNavigation(
      {required this.isSelected, required this.factorBottomNavigationBarItem});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 4),
          Image.asset(
            factorBottomNavigationBarItem.icon,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            // color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(height: 4),
          if (isSelected)
            SizedBox(
                height: 5,
                width: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                ))
        ],
      ),
    );
  }
}

class FactorBottomNavigationBarItem {
  FactorBottomNavigationBarItem({
    required this.icon,
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
  });

  final String icon;

  final Color activeColor;

  final Color? inactiveColor;

  final TextAlign? textAlign;
}
