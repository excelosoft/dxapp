import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_dashboard/firebase_options.dart';
import 'package:responsive_dashboard/layout.dart';
import 'package:responsive_dashboard/routes/ScreenRouter.dart';
import 'package:responsive_dashboard/style/colors.dart';

import 'config/size_config.dart';
import 'functions/mainger_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MaingerProvide>(
          create: (context) => MaingerProvide(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Detaling Xperts',
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFFED2626,
            <int, Color>{
              50: Color(0x1AED2626),
              100: Color(0x33ED2626),
              200: Color(0x4DED2626),
              300: Color(0x66ED2626),
              400: Color(0x80ED2626),
              500: Color(0xFFED2626),
              600: Color(0x99ED2626),
              700: Color(0xB3ED2626),
              800: Color(0xCCED2626),
              900: Color(0xE6ED2626),
            },
          ),
          scaffoldBackgroundColor: AppColors.primaryBg,
          fontFamily: GoogleFonts.dmSans().fontFamily,
        ),
        // initialRoute: RoutePath.start,
        // initialRoute: RoutePath.login,
        getPages: ScreenRouter.routes,
        //   home: Maintenance(),
        home: LayoutView(),
      ),
    );
  }
}
