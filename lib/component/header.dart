// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_dashboard/Services/Apis.dart';

import 'package:responsive_dashboard/component/custom/custom_confirmation_model.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/dataModel/user_data_model.dart';
import 'package:responsive_dashboard/layout.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:responsive_dashboard/style/style.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constant.dart';
import '../functions/shared_preference.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  UserDataModel? userDataModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  getUserData() async {
    final data = await ApiProvider().getProfile();

      userDataModel = data;
      setState(() {

      });
  }

  @override
  void initState() {
    LocalStorage.getUserId().then((value) => {
          print(value),
          setState(() {
            AppConst.setAccessToken(value);
          })
        });
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: Responsive.isMobile(context) ? 110: 110,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: Responsive.isMobile(context) ? AppBar(
                automaticallyImplyLeading: false,
                leading: Get.currentRoute != '/' && Get.currentRoute != '/dashboard' ?
                IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                      ):IconButton(
            onPressed: () {
          if (drawerKey.currentState != null) {
    drawerKey.currentState?.openDrawer();
    }
    },
      icon: Icon(Icons.menu, color: AppColors.white),
    ),


                scrolledUnderElevation: 0.0,
                backgroundColor: AppColors.primaryBg,
                centerTitle: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Image.asset('assets/logo.png',
                      height:  Responsive.isDesktop(context) ? 50 : 30,
                    ),

                    CustomContainer(
                      PrimaryText(
                        text: "${capitalizeFirstLetter(userDataModel?.data?.companyName ?? '')}",
                        size: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      marginTop: 2,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
                actions: [
                  MyTextWithMenu(imageUrl: userDataModel?.data?.avatar ?? noImg),
                ],
              ) : null,
        body: Responsive.isMobile(context) ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10.0),
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/');
                      },
                      child: SizedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              ImageConstant.appLogo,
                              height: Responsive.isDesktop(context) ? 50 : 35,
                            ),
                            CustomContainer(
                              PrimaryText(
                                text: "${capitalizeFirstLetter(userDataModel?.data?.companyName ?? '')}",
                                size: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              marginTop: 7,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Responsive.isDesktop(context) ? 10 : 5),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(RoutePath.estimateScreen);
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => Estimate()));
                            },
                            child: Container(
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4.0)),
                              height: 45,
                              // width: 120,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 20.0 : 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(headerAss[0]),
                                      height: Responsive.isDesktop(context) ? 20 : 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      headerVal[0],
                                      // textAlign: TextAlign.right,
                                      style: TextStyle(
                                        color: AppColors.primaryBg,
                                        fontFamily: 'Poppins',
                                        fontSize: Responsive.isDesktop(context) ? 18 : 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(Responsive.isDesktop(context) ? 8 : 5),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(RoutePath.billScreen);
                              // Navigator.push(
                              //     context, MaterialPageRoute(builder: (context) => Bill()));
                            },
                            child: Container(
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4.0)),
                              height: 45,
                              // width: 120,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 20.0 : 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(headerAss[1]),
                                      height: Responsive.isDesktop(context) ? 20 : 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(headerVal[1],
                                        // textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: AppColors.primaryBg,
                                          fontFamily: 'Poppins',
                                          fontSize: Responsive.isDesktop(context) ? 18 : 14,
                                          fontWeight: FontWeight.w500,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(Responsive.isDesktop(context) ? 10 : 5),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(RoutePath.warrantyScreen);
                              // Navigator.push(
                              //     context, MaterialPageRoute(builder: (context) => Warranty()));
                            },
                            child: Container(
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4.0)),
                              height: 45,
                              // width: 120,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 20.0 : 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(headerAss[2]),
                                      height: Responsive.isDesktop(context) ? 20 : 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(headerVal[2],
                                        // textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: AppColors.primaryBg,
                                          fontFamily: 'Poppins',
                                          fontSize: Responsive.isDesktop(context) ? 18 : 14,
                                          fontWeight: FontWeight.w500,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(Responsive.isDesktop(context) ? 10 : 5),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(RoutePath.jobSheetScreen);
                              // Navigator.push(
                              //     context, MaterialPageRoute(builder: (context) => JobSheet()));
                            },
                            child: Container(
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4.0)),
                              height: 45,
                              // width: 120,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 15.0 : 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage(headerAss[3]),
                                      height: Responsive.isDesktop(context) ? 20 : 15,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(headerVal[3],
                                        // textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: AppColors.primaryBg,
                                          fontFamily: 'Poppins',
                                          fontSize: Responsive.isDesktop(context) ? 16 : 12,
                                          fontWeight: FontWeight.w500,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (width > 900)
                          Padding(
                            padding: EdgeInsets.all(Responsive.isDesktop(context) ? 10 : 5),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(RoutePath.quickScreen);
                                // Navigator.push(
                                //     context, MaterialPageRoute(builder: (context) => Quick()));
                              },
                              child: Container(
                                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4.0)),
                                height: 45,
                                // width: 120,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 20.0 : 15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: AssetImage(headerAss[4]),
                                        height: Responsive.isDesktop(context) ? 20 : 15,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        headerVal[4],
                                        // textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: AppColors.primaryBg,
                                          fontFamily: 'Poppins',
                                          fontSize: Responsive.isDesktop(context) ? 18 : 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    if (userDataModel != null)
                      MyTextWithMenu(
                        imageUrl: userDataModel?.data?.avatar ?? noImg,
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class MyTextWithMenu extends StatelessWidget {
  final String? imageUrl;

  const MyTextWithMenu({Key? key, required this.imageUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        int endIndex = MediaQuery.of(context).size.width <= 1000 ? 5 : 5;
        if (endIndex > profileMenuItems.length) {
          endIndex = profileMenuItems.length;
        }

        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(100, 100, 0, 0),
          items: profileMenuItems.sublist(0, endIndex).map(
                (e) {
              return profilePopupMenuItem(e.title, e.icon, context, () {
                  if (e.id == 6) {
                    customConfirmationAlertDialog(context, () async {
                      SharedPreferences prefs = await SharedPreferences
                          .getInstance();
                      Get.offAndToNamed(e.screen);
                      prefs.setBool("isLoggedIn", false);
                      GetStorage().remove('userId');
                    }, 'Logout', 'Are you sure you want to logout?', 'Logout');
                  } else {
                    Get.toNamed(e.screen);
                  }
                },
              );
            },
          ).toList(),
        );
      },
      child: CustomContainer(
        Image(
          image: AssetImage(
            ImageConstant.profileIcon,
          ),
          width: Responsive.isMobile(context) ? 35 : 40,
        ),
        alignment: FractionalOffset.centerRight,
        margiRight: 7,
      ),
    );
  }
}

PopupMenuEntry<int> profilePopupMenuItem(String title, String icon, BuildContext context, Function() onSelectItem) {
  return PopupMenuItem<int>(
    value: 6,
    onTap: () {
      onSelectItem();
    },
    child: SizedBox(
      width: 150,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(icon),
            height: Responsive.isDesktop(context) ? 20 : 15,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(
              color: AppColors.primaryBg,
              fontFamily: 'Poppins',
              fontSize: Responsive.isDesktop(context) ? 18 : 14,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    ),
  );
}
