import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/dataModel/jobsheet_listing_model.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_html/html.dart' as html;

import '../../component/no_data_found.dart';
import '../../config/responsive.dart';
import '../../dataModel/estimate_list_model.dart';
import '../../routes/RoutePath.dart';
import '../../utils/image_constants.dart';

class JobSheet extends StatefulWidget {
  @override
  State<JobSheet> createState() => _JobSheetState();
}

class _JobSheetState extends State<JobSheet> {
  late Future<JobSheetListingModel> jobSheetFuture;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getDataforJobsheet();
    super.initState();
  }

  void getDataforJobsheet() {
    jobSheetFuture = ApiProvider().getJobSheetList();
  }

  Future<List<EstimateData>> fetchEstimateList() async {
    // Fetch the estimate model from the API
    EstimateListModel estimateModel = await ApiProvider().getEstimateList();

    // Extract the list of estimate data from the estimate model
    List<EstimateData> estimateDataList = estimateModel.data ?? [];

    return estimateDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 30),
                child: FutureBuilder<JobSheetListingModel>(
                    future: jobSheetFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.6,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        final jobsheetDataList = snapshot.data?.data;

                        final filteredData = jobsheetDataList!.where((estimate) {
                          final searchQuery = searchController.text.toLowerCase();
                          final nameMatches = estimate.name != null && estimate.name!.toLowerCase().contains(searchQuery);
                          final vehicleNumberMatches = estimate.vehicleNumber != null && estimate.vehicleNumber!.toLowerCase().contains(searchQuery);
                          return nameMatches || vehicleNumberMatches;
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Responsive.isMobile(context) ? 0 : 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    runSpacing: 20,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 300,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              ImageConstant.jobsheetIcon,
                                              width: 30,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Job Sheet List',
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
                                      // ElevatedButton(
                                      //     style: ElevatedButton.styleFrom(
                                      //       backgroundColor: Color(0xFFED2626),
                                      //       padding: EdgeInsets.all(15),
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(8),
                                      //       ),
                                      //     ),
                                      //     onPressed: () {
                                      //       Get.toNamed(RoutePath.addJobSheetScreen);
                                      //       //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                                      //     },
                                      //     child: Text(
                                      //       'Create Job List',
                                      //       style: kLabelStyle,
                                      //     ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    height: MediaQuery.of(context).size.height / 1.6,
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
                                            'Assigned Worker',
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
                                                "${index + 1}.",
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                capitalizeFirstLetterOfEachWord(filteredData[index].name ?? 'N/A'),
                                                style: GoogleFonts.inter(color: Colors.black),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                "${capitalizeFirstLetterOfEachWord(filteredData[index].modalName ?? 'N/A')} (${capitalizeFirstLetterOfEachWord(filteredData[index].makeId ?? 'N/A')})",
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
                                                capitalizeFirstLetterOfEachWord(filteredData[index].assignedWorker ?? 'N/A'),
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    tooltip: 'Print',
                                                    onPressed: () async {
                                                      final id = filteredData[index].id.toString();

                                                      html.window.open('https://excelosoft.com/dxapp/public/jobsheets/$id/pdf', '_blank');
                                                    },
                                                    icon: Icon(Icons.print_outlined),
                                                  ),
                                                  IconButton(
                                                    tooltip: 'Edit',
                                                    onPressed: () async {
                                                      List<EstimateData> estimateList = await fetchEstimateList();
                                                      EstimateData? matchingEstimate;
                                                      for (EstimateData estimate in estimateList) {
                                                        if (estimate.id == filteredData[index].id) {
                                                          matchingEstimate = estimate;
                                                          break;
                                                        }
                                                      }

                                                      if (matchingEstimate != null) {
                                                        Get.toNamed(
                                                          RoutePath.addJobSheetScreen,
                                                          arguments: {
                                                            'matchingEstimate': matchingEstimate,
                                                            'description': filteredData[index].description ?? "",
                                                            'remarks': filteredData[index].remarks,
                                                          },
                                                          parameters: {
                                                            'isEdit': 'true',
                                                          },
                                                        );
                                                      } else {
                                                        toastification.show(
                                                          context: context,
                                                          type: ToastificationType.error,
                                                          title: Text('Something Went Wrong!'),
                                                          autoCloseDuration: const Duration(seconds: 5),
                                                        );
                                                      }
                                                    },
                                                    icon: Icon(Icons.edit_outlined),
                                                  ),
                                                  // IconButton(
                                                  //   onPressed: () async {
                                                  //     customConfirmationAlertDialog(
                                                  //       context,
                                                  //       () async {
                                                  //         final id = filteredData[index].id;
                                                  //         print(id);
                                                  //         await ApiProvider().deleteJobSheetById(id!);
                                                  //         getDataforJobsheet();
                                                  //         Navigator.of(context).pop();
                                                  //         setState(() {});
                                                  //       },
                                                  //       'Delete',
                                                  //       'Are you sure you want to delete?',
                                                  //       'Delete',
                                                  //     );
                                                  //   },
                                                  //   icon: Icon(
                                                  //     Icons.delete_outline_rounded,
                                                  //     color: Colors.red,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      print(snapshot.error);
                      return NoDataFound();
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}