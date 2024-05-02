import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/dataModel/estimate_list_model.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';
import '../component/dashboard/tabbar_widget.dart';
import '../component/no_data_found.dart';
import '../constants/string_methods.dart';
import '../routes/RoutePath.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController tabviewController;
  String currentTimeFormat = 'Day';
  List<String?> currentStatus = [];

  @override
  void initState() {
    tabviewController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
  }

  void showDateDailog() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        // controller.text = formatter.format(pickedDate);
      },
    );
  }

  Stream<EstimateListModel> estimateStream(Duration interval) async* {
    while (true) {
      await Future.delayed(interval);
      var response = await ApiProvider().getEstimateList();
      yield response;
    }
  }

  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = MediaQuery.of(context).size.width;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 3,
                    ),
                    Row(
                      children: [
                        CustomButton(
                          width: Responsive.isMobile(context) ? 180 : 220,
                          height: 39,
                          text: '15 March 2024',
                          leftIcon: Icons.calendar_month_outlined,
                          textColor: Colors.black,
                          lefticonColor: Colors.black,
                          // textAlign: TextAlign.start,
                          buttonColor: Colors.white,

                          borderRadius: 30,
                          onPressed: () {
                            showDateDailog();
                          },
                        ),
                        if (!Responsive.isMobile(context)) ...[
                          Spacer(),
                          SizedBox(
                            width: 500,
                            child: TabBarWidget(
                              tabviewController: tabviewController,
                              onTabChanged: (e) {
                                // setState(() {
                                // });
                              },
                            ),
                          ),
                        ] else ...[
                          Spacer(),
                          PopupMenuButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            initialValue: '',
                            tooltip: '',
                            padding: EdgeInsets.zero,
                            color: Colors.white.withOpacity(1),
                            offset: const Offset(10, 40),
                            itemBuilder: (context) {
                              return filterList
                                  .map((e) => popupMenuItem(
                                        e.toString(),
                                        selectedValue: 'Day',
                                      ))
                                  .toList();
                            },
                            onSelected: (value) {
                              setState(() {
                                currentTimeFormat = value.toString();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: IntrinsicWidth(
                                child: Row(
                                  children: [
                                    Text(
                                      currentTimeFormat,
                                      style: GoogleFonts.inter(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.expand_more_outlined,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Responsive.isMobile(context)
                            ? 1
                            : Responsive.isTablet(context)
                                ? 2
                                : 3,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 230,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Image(
                          image: AssetImage('assets/dasCard.png'),
                          height: Responsive.isDesktop(context) ? 230 : 140,
                          width: Responsive.isMobile(context) ? width : null,
                        );
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    FutureBuilder<EstimateListModel>(
                        // StreamBuilder<EstimateListModel>(
                        future: ApiProvider().getEstimateList(),
                        // stream: estimateStream(Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox(
                              height: 400,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          if (snapshot.hasData) {
                            print('build');
                            List<EstimateData> data = snapshot.data?.data ?? [];

                            currentStatus = data.map((e) => e.currentStatus ?? 'Deleivered').toList();

                            if (selectedFilter != null) {
                              data = data.where((item) => item.currentStatus == selectedFilter).toList();
                            }

                            return Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          ImageConstant.warrantyIcon,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          'Current Status',
                                          style: GoogleFonts.inter(
                                            fontSize: 30,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                      ),
                                      child: Container(
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
                                            DataColumn2(
                                              label: Text(
                                                'EST. DELIVERY TIME',
                                                style: GoogleFonts.inter(color: Colors.grey),
                                              ),
                                              size: ColumnSize.L,
                                            ),
                                            DataColumn2(
                                              label: Row(
                                                children: [
                                                  PopupMenuButton(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    initialValue: '',
                                                    tooltip: '',
                                                    padding: EdgeInsets.zero,
                                                    color: Colors.white.withOpacity(1),
                                                    offset: const Offset(10, 40),
                                                    itemBuilder: (context) {
                                                      // currentStatus = data![index].currentStatus!;

                                                      return dropDownStatusDataList
                                                          .map((e) => popupMenuItem(
                                                                e.toString(),
                                                                selectedValue: selectedFilter,
                                                              ))
                                                          .toList();
                                                    },
                                                    onSelected: (value) async {
                                                      selectedFilter = value.toString();
                                                      // setState(() {});
                                                    },
                                                    child: IntrinsicWidth(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Status',
                                                            style: GoogleFonts.inter(
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.filter_list,
                                                            color: Colors.grey,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              size: ColumnSize.L,
                                            ),
                                            DataColumn2(
                                              label: Text(
                                                'ASSIGNED WORKER',
                                                style: GoogleFonts.inter(color: Colors.grey),
                                              ),
                                              size: ColumnSize.L,
                                            ),
                                          ],
                                          rows: List<DataRow>.generate(
                                            data.length,
                                            (index) {
                                              return DataRow(
                                                onSelectChanged: (value) {
                                                  Get.toNamed(
                                                    RoutePath.estimateAddScreen,
                                                    arguments: data[index],
                                                    parameters: {
                                                      'isEdit': 'true',
                                                    },
                                                  );
                                                },
                                                cells: [
                                                  DataCell(
                                                    GestureDetector(
                                                      onTap: () {
                                                        print('hello');
                                                      },
                                                      child: Text(
                                                        "${index + 1}.",
                                                        style: GoogleFonts.inter(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      capitalizeFirstLetterOfEachWord(data[index].name ?? "N/A"),
                                                      style: GoogleFonts.inter(color: Colors.black),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      '${capitalizeFirstLetterOfEachWord(data[index].segment ?? 'N/A')} ${capitalizeFirstLetterOfEachWord(data[index].makeId ?? 'N/A')}',
                                                      style: GoogleFonts.inter(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      data[index].vehicleNumber ?? 'N/A',
                                                      style: GoogleFonts.inter(color: Colors.black),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      data[index].estimatedDeliveryTime ?? 'N/A',
                                                      style: GoogleFonts.inter(color: Colors.black),
                                                    ),
                                                  ),
                                                  DataCell(
                                                    StatefulBuilder(builder: (context, setstate) {
                                                      return PopupMenuButton(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        initialValue: '',
                                                        tooltip: '',
                                                        padding: EdgeInsets.zero,
                                                        color: Colors.white.withOpacity(1),
                                                        offset: const Offset(10, 40),
                                                        itemBuilder: (context) {
                                                          // currentStatus = data![index].currentStatus!;

                                                          return dropDownStatusDataList
                                                              .map((e) => popupMenuItem(
                                                                    e.toString(),
                                                                    selectedValue: currentStatus[index],
                                                                  ))
                                                              .toList();
                                                        },
                                                        onSelected: (value) async {
                                                          currentStatus[index] = value.toString();
                                                          setstate(() {});

                                                          ApiProvider().changeStatusForEstimate(data[index].id.toString(), value.toString());
                                                        },
                                                        child: IntrinsicWidth(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                currentStatus[index] ?? data[index].currentStatus!,
                                                                style: GoogleFonts.inter(
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              Icon(
                                                                Icons.expand_more_outlined,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                  DataCell(
                                                    Text(
                                                      capitalizeFirstLetterOfEachWord(data[index].assignedWorker ?? 'N/A'),
                                                      style: GoogleFonts.inter(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         PrimaryText(
          //           text: 'Balance',
          //           size: 16,
          //           fontWeight: FontWeight.w400,
          //           color: AppColors.secondary,
          //         ),
          //         PrimaryText(text: '\$1500', size: 30, fontWeight: FontWeight.w800),
          //       ],
          //     ),
          //     PrimaryText(
          //       text: 'Past 30 DAYS',
          //       size: 16,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.secondary,
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: SizeConfig.blockSizeVertical! * 3,
          // ),
          // Container(
          //   height: 180,
          //   child: BarChartCopmponent(),
          // ),
          // SizedBox(
          //   height: SizeConfig.blockSizeVertical! * 5,
          // ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     PrimaryText(text: 'History', size: 30, fontWeight: FontWeight.w800),
          //     PrimaryText(
          //       text: 'Transaction of lat 6 month',
          //       size: 16,
          //       fontWeight: FontWeight.w400,
          //       color: AppColors.secondary,
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: SizeConfig.blockSizeVertical! * 3,
          // ),
          // HistoryTable(),
          // if (!Responsive.isDesktop(context)) PaymentDetailList()
        ],
      ),
    );
  }
}

List<String> dropDownStatusDataList = [
  'Deleivered',
  'In Progress',
  'Not Deleivered',
  'Closed',
];

List<String> filterList = [
  'Day',
  'Week',
  'Month',
  'Year',
];

PopupMenuEntry<String> popupMenuItem(
  String title, {
  String? selectedValue,
}) {
  return PopupMenuItem(
    onTap: null,
    value: title,
    height: 5,
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Center(
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selectedValue == title ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: GoogleFonts.dmSans().fontFamily,
                letterSpacing: 0.4,
                fontSize: 13,
                color: selectedValue == title ? Colors.black : const Color(0xFF454545),
              ),
            ),
            if (selectedValue == title)
              Icon(
                Icons.done,
                size: 20,
                color: AppColors.black,
              )
          ],
        ),
      ),
    ),
  );
}
