import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';

import '../routes/RoutePath.dart';

const noImg = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

List headerVal = ['Estimate', 'Bills', 'Warranty', 'JobSheet', 'Quick Quotation'];

List headerAss = [
  ImageConstant.estimateIcon,
  ImageConstant.billsIcon,
  ImageConstant.warrantyIcon,
  ImageConstant.jobsheetIcon,
  ImageConstant.quickQuotationIcon,
];

class AppConst {
  static log(key, value) {
    // ignore: avoid_print
    return print({key, value});
  }

  static isIosDevice() {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  static BuildContext? outerContext;
  static BuildContext? getOuterContext() {
    return outerContext;
  }

  static setOuterContext(BuildContext context) {
    outerContext = context;
  }

  static String? _fcmToken;
  static String? getFcmToken() {
    return _fcmToken;
  }

  static setFcmToken(String token) {
    _fcmToken = token;
  }

  static dynamic _accessToken;
  static dynamic getAccessToken() {
    return _accessToken;
  }

  static setAccessToken(dynamic token) {
    _accessToken = token;
  }

  static bool _isPublicView = false;
  static bool getPublicView() {
    return _isPublicView;
  }

  static setPublicView(bool val) {
    _isPublicView = val;
  }

  static bool _isAuthenticated = false;
  static bool getIsAuthenticated() {
    return _isAuthenticated;
  }

  static setIsAuthenticated(bool val) {
    _isAuthenticated = val;
  }

  static String role = "";
  static String getRole() {
    return role;
  }

  static setRole(String val) {
    role = val;
  }

  static showConsoleLog(message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static String? noImage = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAHlBMVEX09PTh4eH19fXg4ODk5OTw8PDs7Ozq6uru7u7n5+dZKxXMAAAELUlEQVR4nO2dWXKtMAwFwQMX9r/hB9RNMOARhCTyTv/kIxVQl4kHYZmuAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAsZ03o9eA6OfwyH360bXWz30kyd2HHvbq8LaibQdJ2V+C7Yf6RSdQsEZOxApGqWCsyJNK5qPVsEZCsHOS1tksBNFI2rsZTY8gaG0QxaCRjRj0ITS4/wvW0judguaKbjaID1f+xLEZG8/psZtV6OeKF3GbH2DHW9fbDN0WgTn/j0wvBtVYEjSM9MAwxZgKAMMW4ChDLyGxoQ/eGA0NMYPk3O9c9PH80nyGZo1A/e9l3WEiZM8DxmeZm3GH/Ib1jFNXZna0AzntTFZcigPj2E8f2M/HIoshqkEFYsih+Fu7b9XZOhvWNow4bdw85YVMBjmkqg0Kb4sHG2YaUKaFF+W5w3zefDnO5vnR/wwPxXh8YwOw1Oaz4Pbmzct8ryhLxhe+EdsivRxw/RgePW2821a/uZ5w8ILt/auZp7Ct8Qqb9g6/17XKA3BKnhK227yswirjvZtPc22yqwN912jxW6bQGW87xrx93mCuoBfNWs7JkKqIuaYeWcf04brn3ey1ITMsXrK7F9oWD1Ft+pUxPyeFXB8L1I5aJYsRnKbTcM9E5utyleQzUTVz2eSu8mKYb8km5jbLleI+xUZ4cJ+wHzgr8jqFzY85iNnfPe0vJn5uVff8mamuKMzGzrn27Xu9+3a4Bu2JddsWc3Erv4NaeWe3HTw6t9yV246Tkev3bB6V3UyfOWGDdvGU/HrNmzbFx8X0GzYvPE/asA14l+hubIhqqC4DS+UbsQc9Bpeq005S2g1vFx8c7LQani5uuikIWhohnR5wI3yqaOHnOG8ZLQpxVv1YYd1p5jhuiZOKN4sgNsrShl+F/0xxfsVfjtFoRE/yGqcfkdQwhgqyrRhmLY5tiJJjWbwvkfEcJeXOjyoNEWoVrYND4m3UJGqyla2DU+ZxUCRqoxY1DCWOv3pbsjqpCUNo4LfVqQrBBc0jAquioaylF/OMCG4KlKW8j9vmBjxk4LUSLUhm6CUIZ+gkCGjoIwhp6CIIaughCGvoIAhsyC/Ibcg+4jPLsjdhvyCzIYCgryGEoK8hoV93u83lDn+i9VQ4iGFIQwrDN2fN/z7bQhDGMIQhjCEYdnwvxrxPyKnljIadn6QgNOwMxKwGgoDwxZgKAMMW4ChDE/N2kiCoyA4eYTgPO/t/PPluyc6COrICc5kDybZ1jodhPP+u4LFg1qkofjXyR9jIgzFaaKl84Rkoen9FDci1Tmb0h5JqM6gNFo7m2R5zgVFbd8kW5nHZzJOx0MowNqhHHiL4+h2H7ARZvl4HvUHAtfD1yfpycyX6TPSfwCxE8o+JXhADwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAs/ANyGFT0fw3sTAAAAABJRU5ErkJggg==';

  static String? docTypeImage = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9RsiK7WSMHn6rVq5pLvEgINRyVTNKJ7drsg&usqp=CAU';
}

class ProfileMenuItems {
  final int id;
  final String title;
  final String icon;
  final String screen;

  ProfileMenuItems({
    required this.title,
    required this.icon,
    required this.screen,
    required this.id,
  });
}

List<ProfileMenuItems> profileMenuItems = [
  ProfileMenuItems(title: "Profile", screen: RoutePath.profileScreen, id: 1, icon: ImageConstant.userIcon),
 ProfileMenuItems(title: "Invantory Review", screen: RoutePath.calendar, id: 2, icon: ImageConstant.calendarIcon),
  ProfileMenuItems(title: "Maintenance", screen: RoutePath.maintenanceScreen, id: 3, icon: ImageConstant.maintenanceIcon),
  ProfileMenuItems(title: "Offers", screen: RoutePath.offersScreen, id: 4, icon: ImageConstant.offersIcon),
  ProfileMenuItems(title: "Logout", screen: RoutePath.login, id: 5, icon: ImageConstant.logoutIcon),
  ProfileMenuItems(title: "Quick Quotation  ", screen: RoutePath.quickScreen, id: 6, icon: ImageConstant.quickQuotationIcon),
];
