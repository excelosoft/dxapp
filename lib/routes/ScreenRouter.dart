import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:responsive_dashboard/Screens/calendar_screen.dart';
import 'package:responsive_dashboard/layout.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/Screens/ListingScreens/bills_listing_screen.dart';
import 'package:responsive_dashboard/Screens/ListingScreens/estimate_listing_screen.dart';
import 'package:responsive_dashboard/Screens/ListingScreens/warranty_listing_screen.dart';
import 'package:responsive_dashboard/Screens/AddScreens/addJobSheet.dart';
import 'package:responsive_dashboard/Screens/AddScreens/addMaintenance.dart';
import 'package:responsive_dashboard/Screens/AddScreens/add_quotation_screen.dart';
import 'package:responsive_dashboard/Screens/ListingScreens/maintenance_listing_screen.dart';
import 'package:responsive_dashboard/Screens/ListingScreens/offers_listing_screen.dart';
import 'package:responsive_dashboard/Screens/profile_screen.dart';
import 'package:responsive_dashboard/Screens/ListingScreens/quotation_listing_screen.dart';
import 'package:responsive_dashboard/Screens/AuthScreens/login_screen.dart';

import '../Screens/AddScreens/add_bill_screen.dart';
import '../Screens/AddScreens/add_estimate_screen.dart';
import '../Screens/ListingScreens/jobsheet_listing_screen.dart';
import '../Screens/AddScreens/addWarrantyCard.dart';

class ScreenRouter {
  static List<GetPage> routes = [
    GetPage(name: RoutePath.start, page: () => LayoutView()),
    GetPage(name: RoutePath.calendar, page: () => CalendarScreen()),
    GetPage(name: RoutePath.login, page: () => LoginScreen()),
    GetPage(name: RoutePath.dashboardScreen, page: () => LayoutView()),
    GetPage(name: RoutePath.profileScreen, page: () => ProfileScreen()),
    GetPage(name: RoutePath.estimateScreen, page: () => Estimate()),
    GetPage(name: RoutePath.estimateAddScreen, page: () => EstimateAdd()),
    GetPage(name: RoutePath.billScreen, page: () => Bill()),
    GetPage(name: RoutePath.addBillScreen, page: () => BillAdd()),
    GetPage(name: RoutePath.warrantyScreen, page: () => Warranty()),
    GetPage(name: RoutePath.addWarrantyCardScreen, page: () => AddWarrantyCard()),
    GetPage(name: RoutePath.jobSheetScreen, page: () => JobSheet()),
    GetPage(name: RoutePath.addJobSheetScreen, page: () => AddJobSheet()),
    GetPage(name: RoutePath.quickScreen, page: () => QuotationListing()),
    GetPage(name: RoutePath.addQuickScreen, page: () => AddQuick()),
    GetPage(name: RoutePath.maintenanceScreen, page: () => MaintenanceListingScreen()),
    GetPage(name: RoutePath.addMaintenanceScreen, page: () => AddMaintenance()),
    GetPage(name: RoutePath.offersScreen, page: () => OffersListingScreen()),
  ];
}
