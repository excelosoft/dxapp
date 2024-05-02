// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabviewController;
  final Function(int) onTabChanged;

  const TabBarWidget({
    Key? key,
    required this.tabviewController,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      // margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          50,
        ),
      ),
      child: SizedBox(
        // width: fromProject ? 500 : width,
        child: TabBar(
            onTap: (value) {
              onTabChanged(value);
            },
            controller: tabviewController,
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            // indicatorPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            splashBorderRadius: BorderRadius.circular(50),
            indicator: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(50),
            ),
            tabs: [
              Tab(
                child: Text(
                  'Day',
                  style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                child: Text(
                  'Week',
                  style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                child: Text(
                  "Month",
                  style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Tab(
                child: Text(
                  "Year",
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
      ),
    );
  }
}
