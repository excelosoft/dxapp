import 'package:flutter/material.dart';
import 'package:responsive_dashboard/Screens/AuthScreens/login_screen.dart';
import 'package:responsive_dashboard/Screens/home_dashboard_screen.dart';

import 'package:responsive_dashboard/component/sideMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

class LayoutView extends StatefulWidget {
  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> with WidgetsBindingObserver {
  dynamic userData = '';

  @override
  void initState() {
    checkLoggedIn();
    super.initState();
  }

  bool loggedIn = false;

  checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('Layout Initi$loggedIn');

    return Scaffold(
      key: drawerKey,
      drawer: SideMenu(),
      body: loggedIn ? Dashboard() : LoginScreen(),
    );
  }
}
