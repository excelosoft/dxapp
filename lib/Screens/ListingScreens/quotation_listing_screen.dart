import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:google_fonts/google_fonts.dart';

import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/component/sideMenu.dart';
import 'package:responsive_dashboard/dataModel/quatation_model.dart';
import 'package:responsive_dashboard/utils/loginUtility.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';

import '../../Services/Apis.dart';
import '../../component/custom/custom_confirmation_model.dart';
import '../../component/no_data_found.dart';
import '../../config/responsive.dart';
import '../../functions/mainger_provider.dart';
import 'bills_listing_screen.dart';

class QuotationListing extends StatefulWidget {
  @override
  State<QuotationListing> createState() => _QuotationListingState();
}

class _QuotationListingState extends State<QuotationListing> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  late QuatationModel quatationModel;
  late List<QuotationData> backUpData;
  TextEditingController searchController = TextEditingController();

  int _currentPage = 1;
  int _rowsPerPage = 10; // Number of rows per page
  late Future<QuatationModel> quotationFuture;

  @override
  void initState() {
    getDataForQuotation();
    super.initState();
  }

  void getDataForQuotation() {
    quotationFuture = ApiProvider().getQuickQuationApi();
  }

  @override
  Widget build(BuildContext context) {
    final data=Provider.of<MaingerProvide>(context, listen: true);
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        runSpacing: 20,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstant.quickQuotationIcon,
                                  width: 40,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Quick Quotation List',
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
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: 50,
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
                                Get.toNamed(RoutePath.addQuickScreen);
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                              },
                              child: Text(
                                "Create Quick Quation",
                                style: kLabelStyle,
                              ))
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Row(
                              children: [
                                Image.asset(
                                  ImageConstant.quickQuotationIcon,
                                  width: 40,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Quick Quotation List',
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
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: 50,
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
                                Get.toNamed(RoutePath.addQuickScreen);
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => EstimateAdd()));
                              },
                              child: Text(
                                "Create Quick Quation",
                                style: kLabelStyle,
                              ))
                        ],
                      ),
                    ],
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<QuatationModel>(
                        future: quotationFuture,
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
                            final quiotationDataList = snapshot.data?.data;

                            final filteredData = quiotationDataList!.where((estimate) {
                              final searchQuery = searchController.text.toLowerCase();
                              final nameMatches = estimate.segment != null && estimate.segment!.toLowerCase().contains(searchQuery);
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

                              children: [
                                Container(
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
                                            'SEGMENT',
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
                                            'Services',
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
                                        paginatedData.length,
                                        (index) => DataRow(
                                          cells: [
                                            DataCell(
                                              Text(
                                                "${startIndex+index + 1}.",
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                capitalizeFirstLetterOfEachWord(filteredData[index].segment ?? 'N/A'),
                                                style: GoogleFonts.inter(color: Colors.black),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                capitalizeFirstLetterOfEachWord(filteredData[index].model ?? 'N/A'),
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                filteredData[index].vehicleNumber.toString(),
                                                style: GoogleFonts.inter(color: Colors.black),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                capitalizeFirstLetterOfEachWord(filteredData[index].services?.replaceAll('"', '') ?? 'N/A'),
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
                                                      html.window.open(' https://excelosoft.com/dxapp/public/quickquotations/$id/pdf', '_blank');
                                                    },
                                                    icon: Icon(Icons.print_outlined),
                                                  ),
                                                  Visibility(
                                                    visible: data.maingerStatus,
                                                    child: IconButton(
                                                      tooltip: 'Edit',
                                                      onPressed: () async {
                                                        Get.toNamed(
                                                          RoutePath.addQuickScreen,
                                                          arguments: filteredData[index],
                                                          parameters: {
                                                            'isEdit': 'true',
                                                          },
                                                        );
                                                      },
                                                      icon: Icon(Icons.edit_outlined),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: data.maingerStatus,
                                                    child: IconButton(
                                                      tooltip: 'Delete',
                                                      onPressed: () async {
                                                        customConfirmationAlertDialog(
                                                          context,
                                                          () async {
                                                            final id = filteredData[index].id;
                                                            print(id);
                                                            await ApiProvider().deleteQuickQuatation(id!);
                                                            getDataForQuotation();
                                                            Navigator.of(context).pop();
                                                            setState(() {});
                                                          },
                                                          'Delete',
                                                          'Are you sure you want to delete this Quotation?',
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
                                        ),
                                      ),
                                    ),
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
