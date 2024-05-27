
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Services/Apis.dart';
import '../component/header.dart';
import '../component/no_data_found.dart';
import '../config/responsive.dart';
import '../config/size_config.dart';
import '../constants/string_methods.dart';
import '../dataModel/invantary_model.dart';
import '../dataModel/maintenceModel.dart';
import '../functions/mainger_provider.dart';
import '../routes/RoutePath.dart';
import '../utils/image_constants.dart';
import '../utils/loginUtility.dart';
import 'ListingScreens/bills_listing_screen.dart';

class InventoryReview extends StatefulWidget {


  @override
  State<InventoryReview> createState() => _InventoryReviewState();
}

class _InventoryReviewState extends State<InventoryReview> {
  late Future<List<InvantaryData>> estimateFuture;
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
      estimateFuture =  ApiProvider().fetchBarcodeListForInvontray();
      print(estimateFuture); // or whatever you want to do with the data
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
                                  'Inventory Review',
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
                                  'Inventory Review',
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

                        ],
                      ),
                    ],
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<InvantaryData>>(
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
                            final maintenanceDataList = snapshot.data;

                            final filteredData = maintenanceDataList!.where((estimate) {
                              final searchQuery = searchController.text.toLowerCase();
                              final nameMatches = estimate.serviceName != null && estimate.serviceName!.toLowerCase().contains(searchQuery);
                              final vehicleNumberMatches = estimate.serviceName != null && estimate.serviceName!.toLowerCase().contains(searchQuery);
                              return nameMatches || vehicleNumberMatches;
                            }).toList();

                            if (filteredData.isEmpty) {
                              return NoDataFound();
                            }



                            final groupedData = <String, Map<String, int>>{};
                            for (var estimate in filteredData) {
                              final key = '${estimate.serviceName} ${estimate.packageTime}';
                              if (!groupedData.containsKey(key)) {
                                groupedData[key] = {'totalCount': 0, 'usedCount': 0};
                              }
                              groupedData[key]!['totalCount'] = groupedData[key]!['totalCount']! + 1;
                              if (estimate.qty == '0') {
                                groupedData[key]!['usedCount'] = groupedData[key]!['usedCount']! + 1;
                              }
                            }

                            final groupedDataList = groupedData.entries.map((entry) {
                              final parts = entry.key.split(' ');
                              return {
                                'serviceName': parts[0],
                                'packageTime': parts.sublist(1).join(' '),
                                'totalCount': entry.value['totalCount']!,
                                'usedCount': entry.value['usedCount']!,
                              };
                            }).toList();

                            final totalPages = (groupedDataList.length / _rowsPerPage).ceil();
                            _currentPage = (_currentPage > totalPages) ? totalPages : _currentPage;
                            final startIndex = (_currentPage - 1) * _rowsPerPage;
                            final endIndex = startIndex + _rowsPerPage;
                            final endValidIndex = endIndex.clamp(0, groupedDataList.length);

                            final paginatedData = groupedDataList.sublist(startIndex, endValidIndex);

                            if (paginatedData.isEmpty && _currentPage > 1) {
                              setState(() {
                                _currentPage--;
                              });
                              return SizedBox();
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
                                          'Items',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                        size: ColumnSize.L,
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'GOT',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'USED',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'REMAINING',
                                          style: GoogleFonts.inter(color: Colors.grey),
                                        ),
                                      ),

                                    ],
                                    rows: List<DataRow>.generate(paginatedData.length, (index) {
                                      int remain=int.parse(paginatedData[index]['totalCount'].toString())-int.parse(paginatedData[index]['usedCount'].toString());
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
                                              '${paginatedData[index]['serviceName']} ${paginatedData[index]['packageTime']}',
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${paginatedData[index]['totalCount']}',

                                              style: GoogleFonts.inter(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${paginatedData[index]['usedCount']}',
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${remain}',
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),

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
