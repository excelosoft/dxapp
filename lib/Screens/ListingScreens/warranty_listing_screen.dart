import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_dashboard/dataModel/bill_list_model.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_html/html.dart' as html;

import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/dataModel/warranty_card_listing_model.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';

import '../../component/no_data_found.dart';
import '../../routes/RoutePath.dart';

class Warranty extends StatefulWidget {
  @override
  State<Warranty> createState() => _WarrantyState();
}

class _WarrantyState extends State<Warranty> {
  late Future<WarrantyCardListingModel> future;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getDataforWarranty();
    super.initState();
  }

  void getDataforWarranty() {
    future = ApiProvider().getWarrantyListing();
  }

  Future<List<BillListData>> fetchBillsList() async {
    // Fetch the estimate model from the API
    BillsListResponse estimateModel = await ApiProvider().getBillList();

    // Extract the list of estimate data from the estimate model
    List<BillListData> estimateDataList = estimateModel.data ?? [];

    return estimateDataList;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: FutureBuilder<WarrantyCardListingModel>(
                    future: future,
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
                        final warrantyDataListing = snapshot.data?.data;

                        final filteredData = warrantyDataListing!.where((estimate) {
                          final searchQuery = searchController.text.toLowerCase();
                          final nameMatches = estimate.name != null && estimate.name!.toLowerCase().contains(searchQuery);
                          final vehicleNumberMatches = estimate.vehicleNumber != null && estimate.vehicleNumber!.toLowerCase().contains(searchQuery);
                          return nameMatches || vehicleNumberMatches;
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              runSpacing: 20,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 270,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        ImageConstant.warrantyIcon,
                                        width: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Warranty Card List',
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
                                //       Get.toNamed(RoutePath.addWarrantyCardScreen);
                                //       //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                                //     },
                                //     child: Text(
                                //       'Create Warranty Card',
                                //       style: kLabelStyle,
                                //     ))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: width,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child: Container(
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
                                        rows: List<DataRow>.generate(filteredData.length, (index) {
                                          final WarrantyData? warrantList = filteredData[index];
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
                                                  capitalizeFirstLetterOfEachWord(warrantList?.name.toString() ?? ''),
                                                  style: GoogleFonts.inter(color: Colors.black),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${capitalizeFirstLetter(warrantList?.modalName ?? 'N/A')} (${capitalizeFirstLetter(warrantList?.makeId ?? 'N/A')})',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  warrantList?.vehicleNumber.toString() ?? "",
                                                  style: GoogleFonts.inter(color: Colors.black),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${capitalizeFirstLetter(warrantList?.selectServicesName ?? 'N/A')} (${warrantList?.selectServicesPackage != null ? capitalizeFirstLetter(warrantList!.selectServicesPackage!.contains('Year') ? warrantList.selectServicesPackage! : warrantList.selectServicesPackage! + ' ' + 'year') : 'N/A'})',
                                                  style: GoogleFonts.inter(color: Colors.black),
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

                                                        html.window.open('https://excelosoft.com/dxapp/public/warrantycards/$id', '_blank');
                                                      },
                                                      icon: Icon(Icons.print_outlined),
                                                    ),
                                                    IconButton(
                                                      tooltip: 'Edit',
                                                      onPressed: () async {
                                                        List<BillListData> estimateList = await fetchBillsList();
                                                        BillListData? matchingEstimate;
                                                        for (BillListData estimate in estimateList) {
                                                          if (estimate.id == filteredData[index].id) {
                                                            matchingEstimate = estimate;
                                                            break;
                                                          }
                                                        }

                                                        if (matchingEstimate != null) {
                                                          Get.toNamed(
                                                            RoutePath.addWarrantyCardScreen,
                                                            arguments: matchingEstimate,
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
                                                    //         await ApiProvider().deleteWarrantyById(id!);
                                                    //         getDataforWarranty();
                                                    //         Navigator.of(context).pop();
                                                    //         setState(() {});
                                                    //       },
                                                    //       'Delete',
                                                    //       'Are you sure you want to delete this warranty?',
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
                                  )
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
          ),
        ],
      ),
    );
  }
}
