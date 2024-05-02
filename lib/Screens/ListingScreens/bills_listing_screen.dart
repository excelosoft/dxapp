import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_html/html.dart' as html;

import 'package:intl/intl.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/dataModel/bill_list_model.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import '../../component/no_data_found.dart';
import '../../config/responsive.dart';
import '../../constants/string_methods.dart';
import '../../dataModel/estimate_list_model.dart';
import '../../utils/image_constants.dart';

class Bill extends StatefulWidget {
  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  late Future<BillsListResponse> billFuture;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getDataforBill();
    super.initState();
  }

  void getDataforBill() {
    billFuture = ApiProvider().getBillList();
  }

  Future<List<EstimateData>> fetchEstimateList() async {
    try {
      // Make the API call to fetch the estimate list
      EstimateListModel estimateModel = await ApiProvider().getEstimateList();

      // Check if the response contains data
      if (estimateModel.data == null || estimateModel.data == null) {
        // If no data is returned from the API, throw an error
        throw Exception('No data available');
      }

      // Extract the list of estimate data from the response
      List<EstimateData> estimateDataList = estimateModel.data!;

      // Return the list of estimate data
      return estimateDataList;
    } catch (e) {
      // If an error occurs during the API call, throw an error
      throw Exception('Failed to fetch estimate list: $e');
    }
    // EstimateListModel estimateModel = await ApiProvider().getEstimateList();

    // List<EstimateData> estimateDataList = estimateModel.data!.data ?? [];

    // return estimateDataList;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 10 : 30),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<BillsListResponse>(
                        future: billFuture,
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
                            final billsDataList = snapshot.data?.data;

                            final filteredData = billsDataList!.where((estimate) {
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
                                  // runAlignment: WrapAlignment.spaceBetween,
                                  // alignment: WrapAlignment.spaceBetween,
                                  // crossAxisAlignment: WrapCrossAlignment.end,
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            ImageConstant.billsIcon,
                                            width: 30,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Bill List',
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
                                    //   style: ElevatedButton.styleFrom(
                                    //     backgroundColor: Color(0xFFED2626),
                                    //     padding: EdgeInsets.all(15),
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.circular(8),
                                    //     ),
                                    //   ),
                                    //   onPressed: () {
                                    //     Get.toNamed(RoutePath.addBillScreen);
                                    //     //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                                    //   },
                                    //   child: Text(
                                    //     'Create Bill',
                                    //     style: kLabelStyle,
                                    //   ),
                                    // )
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
                                          'EST. AMOUNT',
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
                                    rows: List<DataRow>.generate(
                                      filteredData.length,
                                      (index) {
                                        String formattedAmount = 'N/A'; // Default value
                                        if (filteredData[index].totalServicesAmount != null) {
                                          // Assuming the amount is stored as a String that can be parsed to a double
                                          double amount = double.tryParse(filteredData[index].totalServicesAmount!) ?? 0;
                                          formattedAmount = NumberFormat('#,##0.00', 'en_US').format(amount) + '/-';
                                        }
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
                                                formattedAmount,
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

                                                      html.window.open('https://excelosoft.com/dxapp/public/bills/$id/pdf', '_blank');
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
                                                          RoutePath.addBillScreen,
                                                          arguments: matchingEstimate,
                                                          parameters: {
                                                            'isEdit': 'true',
                                                            'invoiceNo': filteredData[index].invoiceNo ?? "",
                                                            'barcodeNo': filteredData[index].serviceBarcode ?? "",
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
                                                  //         await ApiProvider().deleteBillsById(id!);
                                                  //         getDataforBill();
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
                                                  IconButton(
                                                    tooltip: 'Warranty',
                                                    onPressed: () async {
                                                      Get.toNamed(
                                                        RoutePath.addWarrantyCardScreen,
                                                        arguments: filteredData[index],
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.shield_moon_outlined,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
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
          )
        ],
      ),
    );
  }
}
