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
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toastification/toastification.dart';
import '../component/custom/custom_text.dart';
import '../component/dashboard/tabbar_widget.dart';
import '../component/no_data_found.dart';
import '../constants/app_constant.dart';
import '../constants/string_methods.dart';
import '../dataModel/calendar_model.dart';
import '../functions/date_picker.dart';
import '../routes/RoutePath.dart';
import 'calendar_screen.dart';
import 'event_data.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}
late List<CalendarItem> calendarList;
class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController tabviewController;

  DateTime selectedDate = DateTime.now();
  bool weekCalendarView = false;
  CalendarController calendarController1 = CalendarController();
  CalendarController calendarController2 = CalendarController();
  String currentTimeFormat = 'Day';
  List<String?> currentStatus = [];
  late Stream<CalendarModel?> stream;
  late var _calendarDataSource;
  @override
  void initState() {
    tabviewController = TabController(length: 4, vsync: this, initialIndex: 0);
    stream = estimateStreamCalandar(Duration(seconds: 1));
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void previousMonth() {
    calendarController1.backward?.call();
    calendarController2.backward?.call();
  }

  void nextMonth() {
    calendarController1.forward?.call();
    calendarController2.forward?.call();
  }


  Stream<CalendarModel?> estimateStreamCalandar(Duration interval) async* {
   // while (true) {
      await Future.delayed(interval);
      var response = await ApiProvider().calendarListApi();

      yield response;
   // }
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
    final height = MediaQuery.of(context).size.height;
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
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    StreamBuilder<CalendarModel?>(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: const CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          calendarList  = snapshot.data!.data!;
                          _calendarDataSource=MeetingDataSource(calendarList);

                          // print(EventDataSource(calenderList));


                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  height:height/1.2,
                                  padding: const EdgeInsets.all(15),
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                      child: SfCalendar(
                                      backgroundColor: Colors.white,
                                      view: CalendarView.month,
                                      monthViewSettings: MonthViewSettings(
                                          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                                      dataSource: _calendarDataSource,
                                      onViewChanged: (viewChangedDetails) {
                                        final CalendarView currentView = viewChangedDetails.visibleDates.length > 1 ? CalendarView.month : CalendarView.week;

                                        if (currentView == CalendarView.month) {
                                          weekCalendarView = true;
                                        } else {
                                          weekCalendarView = true;
                                        }

                                        calendarController1.view = currentView;
                                      },
                                      initialDisplayDate: selectedDate,
                                      initialSelectedDate: selectedDate,
                                      viewHeaderHeight: Responsive.isMobile(context) ? 0 : -1,
                                      showTodayButton: Responsive.isMobile(context) ? false : true,
                                      showNavigationArrow: Responsive.isMobile(context) ? false : true,
                                      onTap: (details) {
                                        if (details.appointments == null) return;

                                        final CalendarItem event = details.appointments!.first;

                                        showAddCalendarModal(
                                          context: context,
                                          isEdit: true,
                                          calendarModel: event,
                                        );}
                                  )
                                  ),
                                ),
                              ),
                              // if (!Responsive.isMobile(context)) ...[
                              //   const VerticalDivider(
                              //     indent: 15,
                              //     width: 20,
                              //   ),
                              //   Expanded(
                              //     flex: Responsive.isTablet(context) ? 2 : 1,
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius: BorderRadius.all(Radius.circular(10)),
                              //         ),
                              //         height:height/1.2,
                              //         padding: const EdgeInsets.all(15),
                              //         child: ScrollConfiguration(
                              //             behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                              //             child: SfCalendar(
                              //                 backgroundColor: Colors.white,
                              //                 view: CalendarView.month,
                              //                 monthViewSettings: MonthViewSettings(
                              //                     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                              //                 dataSource: _calendarDataSource,
                              //                 onViewChanged: (viewChangedDetails) {
                              //                   final CalendarView currentView = viewChangedDetails.visibleDates.length > 1 ? CalendarView.month : CalendarView.week;
                              //
                              //                   if (currentView == CalendarView.month) {
                              //                     weekCalendarView = true;
                              //                   } else {
                              //                     weekCalendarView = true;
                              //                   }
                              //
                              //                   calendarController1.view = currentView;
                              //                 },
                              //                 initialDisplayDate: selectedDate,
                              //                 initialSelectedDate: selectedDate,
                              //                 viewHeaderHeight: Responsive.isMobile(context) ? 0 : -1,
                              //                 showTodayButton: Responsive.isMobile(context) ? false : true,
                              //                 showNavigationArrow: Responsive.isMobile(context) ? false : true,
                              //                 onTap: (details) {
                              //                   if (details.appointments == null) return;
                              //
                              //                   final CalendarItem event = details.appointments!.first;
                              //
                              //                   showAddCalendarModal(
                              //                     context: context,
                              //                     isEdit: true,
                              //                     calendarModel: event,
                              //                   );}
                              //             )
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ]
                            ],
                          );
                        }

                        print('erro --${snapshot.error}');
                        return const NoDataFound();
                      },
                    ),
                    // GridView.builder(
                    //   shrinkWrap: true,
                    //   physics: const ScrollPhysics(),
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: Responsive.isMobile(context)
                    //         ? 1
                    //         : Responsive.isTablet(context)
                    //             ? 2
                    //             : 3,
                    //     crossAxisSpacing: 10.0,
                    //     mainAxisSpacing: 20,
                    //     mainAxisExtent: 230,
                    //   ),
                    //   itemCount: 6,
                    //   itemBuilder: (context, index) {
                    //     return Image(
                    //       image: AssetImage('assets/dasCard.png'),
                    //       height: Responsive.isDesktop(context) ? 230 : 140,
                    //       width: Responsive.isMobile(context) ? width : null,
                    //     );
                    //   },
                    // ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                CustomButton(
                          height: 40,
                           width: 200,
                            text: 'Create new +',
    onPressed: () {
                              showAddCalendarModal(
                                context: context,
                              isEdit: false,
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

void showAddCalendarModal({
  required BuildContext context,
  required bool isEdit,
  CalendarItem? calendarModel,
}) {
  final formkey = GlobalKey<FormState>();
  final width = MediaQuery.of(context).size.width;

  TextEditingController descriptionController = TextEditingController(text: isEdit ? calendarModel?.title : '');
  TextEditingController titleController = TextEditingController(text: isEdit ? calendarModel?.title : '');
  TextEditingController dateController = TextEditingController(text: isEdit ? calendarModel?.startDate : '');
  TextEditingController timeController = TextEditingController(text: isEdit ? '1:20 Am' : '');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, innerSetState) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Dialog(
            insetPadding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                // height: 550,
                width: Responsive.isMobile(context) ? width : 650,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          CustomText(
                            softWrap: true,
                            textAlign: TextAlign.center,
                            size: Responsive.isMobile(context) ? 20 : 30,
                            title: 'Add Calendar Item',
                            fontWeight: FontWeight.bold,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      textFieldForWarranty(
                        width: Responsive.isMobile(context) ? width / 3.5 : width,
                        labelColor: Colors.black,
                        context: context,
                        textEditingController: titleController,
                        labelText: "Title",
                        hintext: "Enter Title",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (Responsive.isMobile(context)) ...[
                        Wrap(
                          runSpacing: 10,
                          children: [
                            textFieldForWarranty(
                              labelColor: Colors.black,
                              context: context,
                              textEditingController: dateController,
                              labelText: "Date",
                              hintext: 'DD/MM/YYYY',
                              isRightIcon: true,
                              rightIcon: Icons.calendar_month,
                              readOnly: true,
                              onTap: () {
                                pickFromDateTime(
                                  pickDate: true,
                                  // pickedDate: pickedDate,
                                  context: context,
                                  controller: dateController,
                                  // timeController: timeController,
                                );
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            textFieldForWarranty(
                              context: context,
                              textEditingController: timeController,
                              labelText: "Time",
                              labelColor: Colors.black,
                              isRightIcon: true,
                              isvalidationTrue: true,
                              rightIcon: Icons.watch_later_outlined,
                              readOnly: true,
                              onTap: () {
                                pickFromDateTime(
                                  pickDate: false,
                                  context: context,
                                  controller: timeController,
                                );
                              },
                              hintext: "Estimated Delivery Time",
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: textFieldForWarranty(
                                context: context,
                                labelColor: Colors.black,
                                textEditingController: dateController,
                                labelText: "Date",
                                hintext: 'DD/MM/YYYY',
                                isRightIcon: true,
                                rightIcon: Icons.calendar_month,
                                readOnly: true,
                                onTap: () {
                                  pickFromDateTime(
                                    pickDate: true,
                                    // pickedDate: pickedDate,
                                    context: context,
                                    controller: dateController,
                                    // timeController: timeController,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: textFieldForWarranty(
                                context: context,
                                textEditingController: timeController,
                                labelText: "Time",
                                labelColor: Colors.black,
                                isRightIcon: true,
                                isvalidationTrue: true,
                                rightIcon: Icons.watch_later_outlined,
                                readOnly: true,
                                onTap: () {
                                  pickFromDateTime(
                                    pickDate: false,
                                    context: context,
                                    controller: timeController,
                                  );
                                },
                                hintext: "Estimated Delivery Time",
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(
                        height: 10,
                      ),
                      textFieldForWarranty(
                        width: width,
                        labelColor: Colors.black,
                        labelText: 'Details',
                        context: context,
                        hintext: 'Details',
                        textEditingController: descriptionController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (isEdit)
                              if (Responsive.isMobile(context)) ...[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ),
                              ] else ...[
                                CustomButton(
                                  buttonColor: Colors.red,
                                  text: 'Delete',
                                  onPressed: () async {
                                    final id = calendarModel!.id;

                                    var storeEstimateRes = await ApiProvider().deleteEstimateApi(id!);

                                    if (storeEstimateRes['status'] == "1") {
                                      dateController.text = '';
                                      titleController.text = '';
                                      descriptionController.text = '';
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        title: Text(storeEstimateRes["message"]),
                                        autoCloseDuration: const Duration(seconds: 5),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  width: 80,
                                  height: 39,
                                ),
                              ],
                            const SizedBox(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: CustomButton(
                                buttonColor: AppColors.buttonColor,
                                text: isEdit ? 'Update' : 'Save',
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    if (isEdit) {
                                      Map estimateData = Map();
                                      estimateData["user_id"] = AppConst.getAccessToken();
                                      estimateData["title"] = titleController.text.isNotEmpty ? titleController.text : "N/A";
                                      estimateData["start_date"] = dateController.text.isNotEmpty ? dateController.text : "N/A";
                                      estimateData["end_date"] = dateController.text.isNotEmpty ? dateController.text : "N/A";

                                      var storeEstimateRes = await ApiProvider().updateCalendarEvent(
                                        estimateData,
                                        calendarModel!.id.toString(),
                                      );

                                      if (storeEstimateRes['status'] == "1") {
                                        dateController.text = '';
                                        titleController.text = '';
                                        descriptionController.text = '';
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.success,
                                          title: Text(storeEstimateRes["message"]),
                                          autoCloseDuration: const Duration(seconds: 5),
                                        );
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      Map estimateData = Map();
                                      estimateData["user_id"] = AppConst.getAccessToken();
                                      estimateData["title"] = titleController.text.isNotEmpty ? titleController.text : "N/A";
                                      estimateData["start_date"] = dateController.text.isNotEmpty ? dateController.text : "N/A";
                                      estimateData["end_date"] = dateController.text.isNotEmpty ? dateController.text : "N/A";

                                      var storeEstimateRes = await ApiProvider().createCalendarEvent(
                                        estimateData,
                                      );

                                      if (storeEstimateRes['status'] == "1") {
                                        dateController.text = '';
                                        titleController.text = '';
                                        descriptionController.text = '';
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.success,
                                          title: Text(storeEstimateRes["message"]),
                                          autoCloseDuration: const Duration(seconds: 5),
                                        );
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  }
                                },
                                width: 85,
                                height: 39,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}