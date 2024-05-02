import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_dashboard/layout.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';

import '../config/responsive.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YourSideDrawer();
  }
}

class YourSideDrawer extends StatelessWidget {
  final List<String> headerAss = [
    ImageConstant.estimateIcon,
    ImageConstant.billsIcon,
    ImageConstant.warrantyIcon,
    ImageConstant.jobsheetIcon,
    ImageConstant.quickQuotationIcon,
  ];

  final List<String> headerVal = [
    'Estimate',
    'Bill',
    'Warranty',
    'Job Sheet',
    'Quick Quotations', // Assuming this is the text for quick quotations
  ];

  final List<String> routePaths = [
    '/estimate',
    '/bill',
    '/warranty',
    '/jobSheet',
    '/quick',
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: headerVal.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(Responsive.isDesktop(context) ? 10 : 5),
            child: InkWell(
              onTap: () {
                Get.toNamed(routePaths[index]);
                drawerKey.currentState!.closeDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                height: 45,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Responsive.isDesktop(context) ? 20.0 : 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage(headerAss[index]),
                        height: Responsive.isDesktop(context) ? 20 : 15,
                      ),
                      SizedBox(width: 10),
                      Text(
                        headerVal[index],
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
          );
        },
      ),
    );
  }
}
