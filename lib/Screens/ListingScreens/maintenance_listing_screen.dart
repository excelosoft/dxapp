import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_html/html.dart' as html;

import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/dataModel/maintenceModel.dart';
import 'package:responsive_dashboard/utils/loginUtility.dart';
import '../../component/custom/custom_confirmation_model.dart';
import '../../component/no_data_found.dart';
import '../../utils/image_constants.dart';

class MaintenanceListingScreen extends StatefulWidget {
  @override
  State<MaintenanceListingScreen> createState() => _MaintenanceListingScreenState();
}

class _MaintenanceListingScreenState extends State<MaintenanceListingScreen> {
  late Future<MaintanceModel> estimateFuture;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getDataForMaintence();
    super.initState();
  }

  void getDataForMaintence() {
    estimateFuture = ApiProvider().getMaintenceList();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Header(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        runSpacing: 20,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstant.maintenanceIcon,
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Maintenance List',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 261,
                            height: 32,
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFED2626),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              print("clickeddd");
                              Get.toNamed(RoutePath.addMaintenanceScreen);
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                            },
                            child: Text(
                              'Create Maintenance',
                              style: kLabelStyle,
                            ),
                          )
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstant.maintenanceIcon,
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Maintenance List',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 261,
                            height: 32,
                            child: TextField(
                              controller: searchController,
                              onChanged: (value) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFED2626),
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Get.toNamed(
                                RoutePath.addMaintenanceScreen,
                              );
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                            },
                            child: Text(
                              'Create Maintenance',
                              style: kLabelStyle,
                            ),
                          )
                        ],
                      ),
                    ],
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<MaintanceModel>(
                        future: estimateFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasData) {
                            final maintenanceDataList = snapshot.data?.data;

                            final filteredData = maintenanceDataList!.where((estimate) {
                              final searchQuery = searchController.text.toLowerCase();
                              final nameMatches = estimate.name != null && estimate.name!.toLowerCase().contains(searchQuery);
                              final vehicleNumberMatches = estimate.vehicleNumber != null && estimate.vehicleNumber!.toLowerCase().contains(searchQuery);
                              return nameMatches || vehicleNumberMatches;
                            }).toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  height: MediaQuery.of(context).size.height / 2,
                                  child: DataTable2(
                                    columnSpacing: 12,
                                    horizontalMargin: 12,
                                    minWidth: 600,
                                    columns: [
                                      DataColumn2(
                                        label: Text('#', style: GoogleFonts.inter(color: Colors.grey)),
                                        size: ColumnSize.S,
                                      ),
                                      DataColumn2(
                                        label: Text(
                                          'CUSTOMER NAME',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'MODAL',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'VECHILE NUMBER',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Warranty',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                      ),
                                      DataColumn2(
                                        label: Text(
                                          'AUCTION',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                        size: ColumnSize.L,
                                      ),
                                    ],
                                    rows: List<DataRow>.generate(filteredData.length, (index) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              "${index + 1}",
                                              style: GoogleFonts.inter(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              capitalizeFirstLetter(filteredData[index].name.toString()),
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${capitalizeFirstLetter(filteredData[index].modalName ?? 'N/A')} (${capitalizeFirstLetter(filteredData[index].makeId ?? 'N/A')})',
                                              style: GoogleFonts.inter(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              filteredData[index].vehicleNumber ?? 'N/A',
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${filteredData[index].selectServicesName}(${filteredData[index].selectServicesPackage})',
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            ListView(
                                              scrollDirection: Axis.horizontal,
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    // final id = filteredData[index].id.toString();

                                                    // html.window.open('https://excelosoft.com/dxapp/public/maintenances/$id/pdf', '_blank');
                                                  },
                                                  icon: Icon(Icons.print_outlined),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    // Get.toNamed(
                                                    //   RoutePath.estimateAddScreen,
                                                    //   arguments: filteredData.data?.data?[index],
                                                    //   parameters: {
                                                    //     'isEdit': 'true',
                                                    //   },
                                                    // );
                                                  },
                                                  icon: Icon(Icons.edit_outlined),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    // customConfirmationAlertDialog(
                                                    //   context,
                                                    //   () async {
                                                    //     final id = filteredData[index].id;
                                                    //     await ApiProvider().deleteEstimateApi(id!);
                                                    //     getDataForMaintence();
                                                    //     Navigator.of(context).pop();
                                                    //     setState(() {});
                                                    //   },
                                                    //   'Delete',
                                                    //   'Are you sure you want to delete this maintainance?',
                                                    //   'Delete',
                                                    // );
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outline_rounded,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            );
                          }

                          print(snapshot.error);
                          return NoDataFound();
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
