import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import 'package:responsive_dashboard/component/no_data_found.dart';

import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_dashboard/component/custom/custom_confirmation_model.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/dataModel/estimate_list_model.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/utils/loginUtility.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';

class Estimate extends StatefulWidget {
  @override
  _EstimateState createState() => _EstimateState();
}

class _EstimateState extends State<Estimate> {
  late Future<EstimateListModel> estimateFuture;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    getdataForEstimate();

    super.initState();
  }

  void getdataForEstimate() {
    estimateFuture = ApiProvider().getEstimateList();
    print(estimateFuture);
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
              padding: EdgeInsets.all(30),
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
                                  ImageConstant.estimateIcon,
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Estimate List',
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
                              Get.toNamed(RoutePath.estimateAddScreen);
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                            },
                            child: Text(
                              'Create Estimate',
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
                                  ImageConstant.estimateIcon,
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Estimate List',
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
                              Get.toNamed(RoutePath.estimateAddScreen);
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                            },
                            child: Text(
                              'Create Estimate',
                              style: kLabelStyle,
                            ),
                          )
                        ],
                      ),
                    ],
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<EstimateListModel>(
                        future: estimateFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height / 1.8,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasData) {
                            final estimateDataList = snapshot.data?.data;
                            print(estimateDataList);
                            final filteredData = estimateDataList!.where((estimate) {
                              final searchQuery = searchController.text.toLowerCase();
                              final nameMatches = estimate.name != null && estimate.name!.toLowerCase().contains(searchQuery);
                              final vehicleNumberMatches = estimate.vehicleNumber != null && estimate.vehicleNumber!.toLowerCase().contains(searchQuery);
                              return nameMatches || vehicleNumberMatches;
                            }).toList();
                            print(filteredData[0].date);
                            return Container(
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
                                    label: Text(
                                      '#',
                                      style: GoogleFonts.inter(color: Colors.grey),
                                    ),
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
                                      'EST. AMOUNT',
                                      style: GoogleFonts.inter(color: Colors.grey),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Created Date',
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
                                    if (filteredData[index].totalPayableAmount != null) {
                                      // Assuming the amount is stored as a String that can be parsed to a double
                                      double amount = double.tryParse(filteredData[index].totalPayableAmount ?? '0') ?? 0;
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
                                            formattedAmount,
                                            style: GoogleFonts.inter(color: Colors.black),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            filteredData[index].date ?? 'N/A',
                                            style: GoogleFonts.inter(color: Colors.black),
                                          ),
                                        ),
                                        DataCell(
                                          ListView(
                                            scrollDirection: Axis.horizontal,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              IconButton(
                                                tooltip: 'Print',
                                                onPressed: () async {
                                                  final id = filteredData[index].id.toString();
                                                  // https: //excelosoft.com/dxapp/public/estimates/116/pdf
                                                  html.window.open('https://excelosoft.com/dxapp/public/estimates/$id/pdf', '_blank');
                                                },
                                                icon: Icon(Icons.print_outlined),
                                              ),
                                              IconButton(
                                                tooltip: 'Edit',
                                                onPressed: filteredData[index].billsStatus == 1
                                                    ? null : () async {
                                                  print('filteredData[index] ===');
                                                  print(filteredData[index].estimatedDeliveryTime);
                                                  print(filteredData[index].date);
                                                  Get.toNamed(
                                                    RoutePath.estimateAddScreen,
                                                    arguments: filteredData[index],
                                                    parameters: {
                                                      'isEdit': 'true',
                                                    },
                                                  );
                                                },
                                                icon: Icon(Icons.edit_outlined),
                                                color: filteredData[index].billsStatus == 1 ? Colors.grey : Colors.black,
                                              ),
                                              IconButton(
                                                tooltip: 'Delete',
                                                onPressed: filteredData[index].billsStatus == 1
                                                    ? null
                                                    : () async {
                                                        customConfirmationAlertDialog(
                                                          context,
                                                          () async {
                                                            final id = filteredData[index].id;

                                                            await ApiProvider().deleteEstimateApi(id!);
                                                            getdataForEstimate();
                                                            Navigator.of(context).pop();
                                                            setState(() {});
                                                          },
                                                          'Delete',
                                                          'Are you sure you want to delete?',
                                                          'Delete',
                                                        );
                                                      },
                                                icon: Icon(
                                                  Icons.delete_outline_rounded,
                                                  color: filteredData[index].billsStatus == 1 ? Colors.grey : Colors.red,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: 'Bill',
                                                onPressed: () async {
                                                  Get.toNamed(
                                                    RoutePath.addBillScreen,
                                                    arguments: filteredData[index],
                                                  );
                                                },
                                                icon: Icon(Icons.receipt_long_outlined),
                                              ),
                                              IconButton(
                                                tooltip: 'JobSheet',
                                                onPressed: () async {
                                                  Get.toNamed(
                                                    RoutePath.addJobSheetScreen,
                                                    arguments: {
                                                      'matchingEstimate': filteredData[index],
                                                      'description': "",
                                                      'remarks': '',
                                                    },
                                                  );
                                                },
                                                icon: Icon(Icons.description_outlined),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
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
