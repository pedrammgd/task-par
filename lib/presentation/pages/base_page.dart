import 'package:flutter/material.dart';
import 'package:task_par/presentation/pages/calendar_page.dart';
import 'package:task_par/presentation/pages/dashboard_page.dart';
import 'package:task_par/presentation/pages/search_page.dart';
import 'package:task_par/presentation/pages/subscription_page.dart';
import 'package:task_par/presentation/utils/constants.dart';
import 'package:task_par/presentation/utils/extensions.dart';
import 'package:task_par/presentation/utils/helper.dart';
import 'package:task_par/presentation/widgets/custom_bottom_navigation_bar.dart';

class BasePage extends StatefulWidget {
  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentBody = 0;
  PageController controller = PageController();

  static List<Widget> get bodyList => [
        DashboardPage(),
        SearchPage(),
        // BagPage(),
        CalendarPage(),
        ProfilePage(),
      ];

  _onItemTapped(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _currentBody = index;
    });
    controller.jumpToPage(index);
  }

  Widget get _getPage => bodyList[_currentBody];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
          onPageChanged: _onItemTapped,
          controller: controller,
          itemBuilder: (BuildContext context, int index) {
            return bodyList[index];
          },
          itemCount: 4,
        ),
        floatingActionButton: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black
              // gradient: AppTheme.pinkGradient.withVerticalGradient,
              // boxShadow: AppTheme.getShadow(AppTheme.frenchRose),
              ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(56),
            child: Icon(Icons.add, color: Colors.white)
                .addRipple(onTap: () => Helper.showBottomSheet(context)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavigationBar(
          selectedIndex: _currentBody,
          items: [
            FactorBottomNavigationBarItem(icon: Resources.homeIcon),
            FactorBottomNavigationBarItem(icon: Resources.searchIcon),
            FactorBottomNavigationBarItem(icon: Resources.calendarIcon),
            FactorBottomNavigationBarItem(icon: Resources.settingIcon),
          ],
          onItemSelected: _onItemTapped,
        )
        // BottomNavBar(
        //   selectedIndex: _currentBody,
        //   onItemTapped: _onItemTapped,
        // ),
        );
  }
}
