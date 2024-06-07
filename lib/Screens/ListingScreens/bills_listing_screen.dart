import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_html/html.dart' as html;

import 'package:intl/intl.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/dataModel/bill_list_model.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../component/no_data_found.dart';
import '../../config/responsive.dart';
import '../../constants/string_methods.dart';
import '../../dataModel/estimate_list_model.dart';
import '../../functions/mainger_provider.dart';
import '../../style/colors.dart';
import '../../utils/image_constants.dart';

class Bill extends StatefulWidget {
  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  late Future<BillsListResponse> billFuture;
  TextEditingController searchController = TextEditingController();
  int _currentPage = 1;
  int _rowsPerPage = 10; // Number of rows per page

  @override
  void initState() {
    getDataforBill();
    super.initState();
  }

  Future<List<EstimateData>> fetchEstimateList() async {
    try {

      EstimateListModel estimateModel = await ApiProvider().getEstimateList();


      if (estimateModel.data == null || estimateModel.data == null) {

        throw Exception('No data available');
      }


      List<EstimateData> estimateDataList = estimateModel.data!;


      return estimateDataList;
    } catch (e) {
      // If an error occurs during the API call, throw an error
      throw Exception('Failed to fetch estimate list: $e');
    }
    // EstimateListModel estimateModel = await ApiProvider().getEstimateList();

    // List<EstimateData> estimateDataList = estimateModel.data!.data ?? [];

    // return estimateDataList;
  }

  void getDataforBill() {
    billFuture = ApiProvider().getBillList();
  }

  @override
  Widget build(BuildContext context) {
    final data=Provider.of<MaingerProvide>(context, listen: true);
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

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        runSpacing: 20,
                        children: [
                          SizedBox(
                            width: 300,
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
                                  'Bills List',
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
                      )

                    ] else ...[
                      Wrap(
                        runSpacing: 20,
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
                                  'Bills List',
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
                      )
                    ],
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

                          if (filteredData.isEmpty) {
                            return NoDataFound();
                          }

                          // Calculate total pages based on filtered data
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
                              // Your search bar and other UI elements...
                              SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                height: MediaQuery.of(context).size.height / 1.6,
                                child: DataTable2 (
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
                                        'VEHICLE NUMBER',
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
                                    paginatedData.length, // Use paginatedData instead of filteredData
                                        (index) {

                                          final actualIndex = startIndex + index + 1;
                                      // Use paginatedData[index] instead of filteredData[index]
                                      String formattedAmount = 'N/A'; // Default value
                                      if (paginatedData[index].totalServicesAmount != null) {
                                        // Assuming the amount is stored as a String that can be parsed to a double
                                        double amount = double.tryParse(paginatedData[index].totalServicesAmount!) ?? 0;
                                        formattedAmount = NumberFormat('#,##0.00', 'en_US').format(amount) + '/-';
                                      }
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              "${actualIndex}.",
                                              style: GoogleFonts.inter(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              capitalizeFirstLetterOfEachWord(paginatedData[index].name ?? 'N/A'),
                                              style: GoogleFonts.inter(color: Colors.black),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              "${capitalizeFirstLetterOfEachWord(paginatedData[index].modalName ?? 'N/A')} (${capitalizeFirstLetterOfEachWord(paginatedData[index].makeId ?? 'N/A')})",
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
                                                    final id = paginatedData[index].id.toString();
                                                  //  _launchInBrowser(Uri.parse('https://excelosoft.com/dxapp/public/bills/$id/pdf',));

                                                    html.window.open('https://excelosoft.com/dxapp/public/bills/$id/pdf', '_blank');
                                                  },
                                                  icon: Icon(Icons.print_outlined),
                                                ),
                                                Visibility(
                                                  visible: data.maingerStatus,
                                                  child: IconButton(
                                                    tooltip: 'Edit',
                                                    onPressed: () async {
                                                      List<EstimateData> estimateList = await fetchEstimateList();
                                                      EstimateData? matchingEstimate;
                                                      for (EstimateData estimate in estimateList) {
                                                        if (estimate.id == paginatedData[index].id) {
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
                                                            'invoiceNo': paginatedData[index].invoiceNo ?? "",
                                                            'barcodeNo': paginatedData[index].serviceBarcode ?? "",
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
                                                ),
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
                                                // Other IconButton widgets
                                              ],
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                )),
                              // Pagination controls
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
                      },
                    ),
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

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios,color: AppColors.buttonColor,),
          color: currentPage > 1 ? Colors.blue : Colors.grey, // Change color based on button availability
          onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
        ),
        Text(
          'Page $currentPage of $totalPages',
          style: TextStyle(color: AppColors.buttonColor),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios,color: AppColors.buttonColor,),
          color: currentPage < totalPages ? Colors.blue : Colors.grey, // Change color based on button availability
          onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
        ),
      ],
    );
  }
}

// class _BillState extends State<Bill> {
//   late Future<BillsListResponse> billFuture;
//   TextEditingController searchController = TextEditingController();
//   int _currentPage = 1;
//   int _rowsPerPage = 10;
//
//   @override
//   void initState() {
//     getDataforBill();
//     super.initState();
//   }
//
//   void getDataforBill() {
//     billFuture = ApiProvider().getBillList();
//   }
//
  Future<List<EstimateData>> fetchEstimateList() async {
    try {

      EstimateListModel estimateModel = await ApiProvider().getEstimateList();


      if (estimateModel.data == null || estimateModel.data == null) {

        throw Exception('No data available');
      }


      List<EstimateData> estimateDataList = estimateModel.data!;


      return estimateDataList;
    } catch (e) {
      // If an error occurs during the API call, throw an error
      throw Exception('Failed to fetch estimate list: $e');
    }
    // EstimateListModel estimateModel = await ApiProvider().getEstimateList();

    // List<EstimateData> estimateDataList = estimateModel.data!.data ?? [];

    // return estimateDataList;
  }


Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw Exception('Could not launch $url');
  }
}

