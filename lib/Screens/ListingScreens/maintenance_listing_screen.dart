import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/dataModel/maintenceModel.dart';
import 'package:responsive_dashboard/utils/loginUtility.dart';
import '../../Services/request_url.dart';
import '../../component/custom/custom_confirmation_model.dart';
import '../../component/no_data_found.dart';
import '../../functions/mainger_provider.dart';
import '../../utils/image_constants.dart';
import 'bills_listing_screen.dart';

class MaintenanceListingScreen extends StatefulWidget {
  @override
  State<MaintenanceListingScreen> createState() => _MaintenanceListingScreenState();
}

class _MaintenanceListingScreenState extends State<MaintenanceListingScreen> {
  late Future <MaintanceModel> estimateFuture;
  TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  int _rowsPerPage = 10;
  @override
  void initState() {



    getDataForMaintence();
    super.initState();
  }


  void getDataForMaintence() async{

      try {
         estimateFuture=  ApiProvider().getMaintenceList();

      } catch (e) {
        print('Error fetching maintenance data: $e');
        // Handle the error gracefully, such as showing an error message to the user
      }

  }

  @override
  Widget build(BuildContext context) {
    final data=Provider.of<MaingerProvide>(context, listen: true);
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
                    ]
                    else ...[
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
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
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

                            if (filteredData.isEmpty) {
                              return NoDataFound();
                            }


                            final totalPages = (filteredData.length / _rowsPerPage).ceil();

                            // Ensure that current page index is within valid range
                            _currentPage = (_currentPage > totalPages) ? totalPages : _currentPage;

                            // Calculate start and end index for the current page
                            final startIndex = (_currentPage - 1) * _rowsPerPage;
                            final endIndex = startIndex + _rowsPerPage;

                            // Ensure that endIndex is within the valid range of data indices
                            final endValidIndex = endIndex.clamp(0, filteredData.length);

                            // Slice the filtered data to get the data for the current page
                            final paginatedData = filteredData.sublist(startIndex, endValidIndex);

                            if (paginatedData.isEmpty && _currentPage > 1) {
                              // If there's no data on the current page and it's not the first page,
                              // decrement the current page value to navigate back to the previous page.
                              setState(() {
                                _currentPage--;
                              });
                              return SizedBox(); // Return an empty SizedBox as the UI will be updated after setState
                            }


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
                                          'VEHICLE NUMBER',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'WARRANTY',
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
                                    rows: List<DataRow>.generate(paginatedData.length, (index) {
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
                                              capitalizeFirstLetter(paginatedData[index].name.toString()),
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${capitalizeFirstLetter(paginatedData[index].modalName ?? 'N/A')} (${capitalizeFirstLetter(filteredData[index].makeId ?? 'N/A')})',
                                              style: GoogleFonts.inter(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              paginatedData[index].vehicleNumber ?? 'N/A',
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${paginatedData[index].selectServicesName}(${paginatedData[index].selectServicesPackage})',
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
                                                     final id = paginatedData[index].id.toString();

                                                     html.window.open('https://excelosoft.com/dxapp/public/maintenances/$id/pdf', '_blank');
                                                  },
                                                  icon: Icon(Icons.print_outlined),
                                                ),
                                                Visibility(
                                                  visible: data.maingerStatus,
                                                  child: IconButton(
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
                                                ),
                                                Visibility(
                                                  visible: data.maingerStatus,
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      customConfirmationAlertDialog(
                                                        context,
                                                        () async {
                                                          final id = paginatedData[index].id;
                                                          await ApiProvider().deleteEstimateApi(id!);
                                                          getDataForMaintence();
                                                          Navigator.of(context).pop();
                                                          setState(() {});
                                                        },
                                                        'Delete',
                                                        'Are you sure you want to delete this maintainance?',
                                                        'Delete',
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_outline_rounded,
                                                      color: Colors.red,
                                                    ),
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

                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: PaginationControls(
                                        currentPage: _currentPage,
                                        totalPages: totalPages,
                                        onPageChanged: (int newPage) {
                                          setState(() {
                                            _currentPage = newPage;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
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

