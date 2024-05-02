// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_dashboard/RoutePath.dart';
// import 'package:responsive_dashboard/component/header.dart';
// import 'package:responsive_dashboard/component/sideMenu.dart';
// import 'package:responsive_dashboard/config/size_config.dart';

// class JobSheet extends StatefulWidget {
//   @override
//   State<JobSheet> createState() => _JobSheetState();
// }

// class _JobSheetState extends State<JobSheet> {
//   GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
//   TextEditingController name = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _drawerKey,
//       drawer: SizedBox(width: 100, child: SideMenu()),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Header(),
//             SizedBox(
//               height: SizeConfig.blockSizeVertical! * 5,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Job Sheet',
//                   style: GoogleFonts.inter(fontSize: 30, color: Colors.white),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 3.5,
//                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
//                   padding: EdgeInsets.symmetric(horizontal: 15),
//                   child: TextField(
//                     controller: name,
//                     decoration: InputDecoration(
//                         hintText: 'Search',
//                         hintStyle: TextStyle(color: Colors.black, fontSize: 18),
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: Colors.black,
//                         )),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Get.toNamed(RoutePath.addJobSheetScreen);
//                     // Navigator.push(
//                     //     context, MaterialPageRoute(builder: (context) => AddJobSheet()));
//                   },
//                   child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(color: Color(0xffED2626), borderRadius: BorderRadius.all(Radius.circular(10))),
//                       child: Text(
//                         "Create Job Sheet",
//                         style: GoogleFonts.inter(fontSize: 17, color: Colors.white),
//                       )),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: SizeConfig.blockSizeVertical! * 5,
//             ),
//             Container(
//               width: SizeConfig.screenWidth!,
//               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Image.asset(
//                           "assets/est.png",
//                           width: 30,
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         Text(
//                           'Warranty Card',
//                           style: GoogleFonts.inter(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//                     decoration: BoxDecoration(color: Color(0xfff7f9fd)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "#",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         Text(
//                           "CUSTOMER NAME",
//                           style: TextStyle(color: Color(0XFF464F60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                         Text(
//                           "MODEL",
//                           style: TextStyle(color: Color(0XFF464f60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                         Text(
//                           "VECHILE NUMBER",
//                           style: TextStyle(color: Color(0XFF464f60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                         Text(
//                           "AMMOUNT",
//                           style: TextStyle(color: Color(0XFF464f60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                         Text(
//                           "AUCTION",
//                           style: TextStyle(color: Color(0XFF464f60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//                     margin: const EdgeInsets.only(bottom: 10),
//                     decoration: BoxDecoration(color: Colors.white),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "1",
//                           style: TextStyle(color: Colors.black),
//                         ),
//                         Text(
//                           "Devendar",
//                           style: TextStyle(color: Color(0XFF464F60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                         Text(
//                           "XUV(Mahindra)",
//                           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
//                         ),
//                         Text(
//                           "RJVJ9540",
//                           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
//                         ),
//                         Text(
//                           "10000",
//                           style: TextStyle(color: Color(0XFF464f60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                         Text(
//                           "AUCTION",
//                           style: TextStyle(color: Color(0XFF464f60), fontWeight: FontWeight.w700, fontSize: 11),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
