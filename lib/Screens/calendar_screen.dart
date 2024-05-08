import 'dart:math';

import 'package:flutter/material.dart';
import 'package:responsive_dashboard/Screens/event_data.dart';
import 'package:responsive_dashboard/component/no_data_found.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:toastification/toastification.dart';

import '../Services/Apis.dart';
import '../component/custom/custom_fields.dart';
import '../component/custom/custom_text.dart';
import '../component/header.dart';
import '../config/responsive.dart';
import '../constants/app_constant.dart';
import '../dataModel/calendar_model.dart';
import '../functions/date_picker.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

 late List<CalendarItem> calendarList;

class _CalendarScreenState extends State<CalendarScreen> {

  late Stream<CalendarModel?> stream;
  late var _calendarDataSource;



  @override
  void initState() {

    stream = estimateStream(Duration(seconds: 1));
    super.initState();
  }

  // late DateTime _displayedMonth;
  DateTime selectedDate = DateTime.now();
  bool weekCalendarView = false;
  CalendarController calendarController1 = CalendarController();
  CalendarController calendarController2 = CalendarController();

  // Future<CalendarModel> estimateStream(Duration interval) async {
  //   await Future.delayed(interval);
  //   return ApiProvider().calendarListApi();
  // }

  Stream<CalendarModel?> estimateStream(Duration interval) async* {
    await Future.delayed(interval);
    var response = await ApiProvider().calendarListApi();

    yield response;
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Header(),
            StreamBuilder<CalendarModel?>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  calendarList  = snapshot.data!.data!;
                  _calendarDataSource=MeetingDataSource(calendarList);
                  DateTime now = DateTime.now();
                  DateTime monthStartDate = DateTime(now.year, now.month, 1);
                  DateTime monthEndDate = DateTime(now.year, now.month + 1, 0);

                  List<CalendarItem> eventsForMonth = calendarList.where((appointment) {
                    DateTime eventDate = DateTime.parse(appointment.startDate!);
                    return eventDate.isAfter(monthStartDate) && eventDate.isBefore(monthEndDate);
                  }).toList();




                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: height / 1.2,
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

                            // child: SfCalendar(
                            //   controller: calendarController1,
                            //   showCurrentTimeIndicator: false,
                            //   dataSource: EventDataSource(calenderList),
                            //   view: CalendarView.month,
                            //   onSelectionChanged: (calendarSelectionDetails) {
                            //     calendarController2.displayDate = calendarSelectionDetails.date;
                            //     calendarController2.selectedDate = calendarSelectionDetails.date;
                            //   },
                            //   onViewChanged: (viewChangedDetails) {
                            //     final CalendarView currentView = viewChangedDetails.visibleDates.length > 1 ? CalendarView.month : CalendarView.week;
                            //
                            //     if (currentView == CalendarView.month) {
                            //       weekCalendarView = true;
                            //     } else {
                            //       weekCalendarView = true;
                            //     }
                            //
                            //     calendarController1.view = currentView;
                            //   },
                            //   allowAppointmentResize: false,
                            //   selectionDecoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: Colors.transparent,
                            //     ),
                            //   ),
                            //   showDatePickerButton: true,
                            //   monthViewSettings:MonthViewSettings(
                            //     appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                            //
                            //   ) ,
                            //  // timeSlotViewSettings: const TimeSlotViewSettings(),
                            //   initialDisplayDate: selectedDate,
                            //   initialSelectedDate: selectedDate,
                            //    viewHeaderHeight: Responsive.isMobile(context) ? 0 : -1,
                            //   showTodayButton: Responsive.isMobile(context) ? false : true,
                            //   showNavigationArrow: Responsive.isMobile(context) ? false : true,
                            //   backgroundColor: Colors.white,
                            //   // allowedViews: const [
                            //   //   CalendarView.day,
                            //   //   CalendarView.week,
                            //   // ],
                            //   onTap: (details) {
                            //     if (details.appointments == null) return;
                            //
                            //     final CalendarItem event = details.appointments!.first;
                            //
                            //     showAddCalendarModal(
                            //       context: context,
                            //       isEdit: true,
                            //       calendarModel: event,
                            //     );
                            //
                            //     selectedDate = details.date!;
                            //     calendarController2.selectedDate = details.date;
                            //     calendarController2.displayDate = details.date;
                            //   },
                            //
                            //   appointmentBuilder: (context, calendarAppointmentDetails) {
                            //     final List<CalendarItem> events = calendarAppointmentDetails.appointments.first;
                            //     return Stack(
                            //       children: events.map((event) {
                            //         final int eventIndex = events.indexOf(event);
                            //         final double topOffset = eventIndex * 20.0; // Adjust this value for vertical positioning
                            //
                            //         return Positioned(
                            //           top: topOffset,
                            //           left: 0,
                            //           child: Container(
                            //             padding: const EdgeInsets.symmetric(horizontal: 10),
                            //             margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 0 : 8),
                            //             height: 20, // Adjust this value for the height of each event box
                            //             width: 120, // Adjust this value for the width of each event box
                            //             decoration: BoxDecoration(
                            //               color: AppColors.buttonColor.withOpacity(0.3),
                            //               borderRadius: BorderRadius.circular(12),
                            //             ),
                            //             child: Center(
                            //               child: Text(
                            //                 capitalizeFirstLetterOfEachWord('hellow' ?? ""),
                            //                 maxLines: 1,
                            //                 overflow: TextOverflow.ellipsis,
                            //                 style: const TextStyle(
                            //                   color: Colors.black,
                            //                   fontSize: 14,
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         );
                            //       }).toList(),
                            //     );
                            //   },
                            // ),
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
                      //       child: Column(
                      //         children: [
                      //           Center(
                      //             child: SfCalendar(
                      //               controller: calendarController2,
                      //               // headerHeight: 0,
                      //               initialDisplayDate: selectedDate,
                      //               initialSelectedDate: selectedDate,
                      //               dataSource: EventDataSource(calenderList),
                      //               cellBorderColor: Colors.transparent,
                      //               view: CalendarView.month,
                      //               backgroundColor: Colors.white,
                      //               onTap: (calendarLongPressDetails) {
                      //                 selectedDate = calendarLongPressDetails.date!;
                      //                 calendarController1.displayDate = calendarLongPressDetails.date;
                      //               },
                      //             ),
                      //           ),
                      //           const Padding(
                      //             padding: EdgeInsets.symmetric(horizontal: 8.0),
                      //             child: Divider(),
                      //           ),
                      //           CustomButton(
                      //             height: 40,
                      //             width: 160,
                      //             text: 'Create new +',
                      //             onPressed: () {
                      //               showAddCalendarModal(
                      //                 context: context,
                      //                 isEdit: false,
                      //               );
                      //             },
                      //           )
                      //         ],
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
          ],
        ),
      ),
    );
  }

  Map<DateTime, List<Appointment>> getAppointments() {
    final List<String> _subjectCollection = <String>[];
    _subjectCollection.add('General Meeting');
    _subjectCollection.add('Plan Execution');
    _subjectCollection.add('Project Plan');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Development Meeting');
    _subjectCollection.add('Scrum');
    _subjectCollection.add('Project Completion');
    _subjectCollection.add('Release updates');
    _subjectCollection.add('Performance Check');

    final List<Color> _colorCollection = <Color>[];
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));

    final Random random = Random();
    var _dataCollection = <DateTime, List<Appointment>>{};
    final DateTime today = DateTime.now();
    final DateTime rangeStartDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: -1000));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1000));
    for (DateTime i = rangeStartDate;
    i.isBefore(rangeEndDate);
    i = i.add(Duration(days: 1 + random.nextInt(2)))) {
      final DateTime date = i;
      final int count = 1 + random.nextInt(3);
      for (int j = 0; j < count; j++) {
        final DateTime startDate = DateTime(
            date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
        final int duration = random.nextInt(3);
        final Appointment meeting = Appointment(
            subject: _subjectCollection[random.nextInt(7)],
            startTime: startDate,
            endTime:
            startDate.add(Duration(hours: duration == 0 ? 1 : duration)),
            color: _colorCollection[random.nextInt(9)],
            isAllDay: false);

        if (_dataCollection.containsKey(date)) {
          final List<Appointment> meetings = _dataCollection[date]!;
          meetings.add(meeting);
          _dataCollection[date] = meetings;
        } else {
          _dataCollection[date] = [meeting];
        }
      }
    }
    return _dataCollection;
  }


}


void showAddCalendarModal({
  required BuildContext context,
  required bool isEdit,
  CalendarItem? calendarModel,
}) {
  final formkey = GlobalKey<FormState>();
  final width = MediaQuery
      .of(context)
      .size
      .width;

  TextEditingController descriptionController = TextEditingController(
      text: isEdit ? calendarModel?.title : '');
  TextEditingController titleController = TextEditingController(
      text: isEdit ? calendarModel?.title : '');
  TextEditingController dateController = TextEditingController(
      text: isEdit ? calendarModel?.startDate : '');
  TextEditingController timeController = TextEditingController(
      text: isEdit ? '1:20 Am' : '');

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
                        width: Responsive.isMobile(context)
                            ? width / 3.5
                            : width,
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
                      ] else
                        ...[
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
                              ] else
                                ...[
                                  CustomButton(
                                    buttonColor: Colors.red,
                                    text: 'Delete',
                                    onPressed: () async {
                                      final id = calendarModel!.id;

                                      var storeEstimateRes = await ApiProvider()
                                          .deleteEstimateApi(id!);

                                      if (storeEstimateRes['status'] == "1") {
                                        dateController.text = '';
                                        titleController.text = '';
                                        descriptionController.text = '';
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.success,
                                          title: Text(
                                              storeEstimateRes["message"]),
                                          autoCloseDuration: const Duration(
                                              seconds: 5),
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
                                      estimateData["user_id"] =
                                          AppConst.getAccessToken();
                                      estimateData["title"] =
                                      titleController.text.isNotEmpty
                                          ? titleController.text
                                          : "N/A";
                                      estimateData["start_date"] =
                                      dateController.text.isNotEmpty
                                          ? dateController.text
                                          : "N/A";
                                      estimateData["end_date"] =
                                      dateController.text.isNotEmpty
                                          ? dateController.text
                                          : "N/A";

                                      var storeEstimateRes = await ApiProvider()
                                          .updateCalendarEvent(
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
                                          title: Text(
                                              storeEstimateRes["message"]),
                                          autoCloseDuration: const Duration(
                                              seconds: 5),
                                        );
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      Map estimateData = Map();
                                      estimateData["user_id"] =
                                          AppConst.getAccessToken();
                                      estimateData["title"] =
                                      titleController.text.isNotEmpty
                                          ? titleController.text
                                          : "N/A";
                                      estimateData["start_date"] =
                                      dateController.text.isNotEmpty
                                          ? dateController.text
                                          : "N/A";
                                      estimateData["end_date"] =
                                      dateController.text.isNotEmpty
                                          ? dateController.text
                                          : "N/A";

                                      var storeEstimateRes = await ApiProvider()
                                          .createCalendarEvent(
                                        estimateData,
                                      );

                                      if (storeEstimateRes['status'] == "1") {
                                        dateController.text = '';
                                        titleController.text = '';
                                        descriptionController.text = '';
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.success,
                                          title: Text(
                                              storeEstimateRes["message"]),
                                          autoCloseDuration: const Duration(
                                              seconds: 5),
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

class MeetingDataSource extends CalendarDataSource {
  final List<CalendarItem> appointments;


  MeetingDataSource(this.appointments,);

  @override
  DateTime getStartTime(int index) {
    return DateTime.parse(appointments[index].startDate!);
  }

  @override
  DateTime getEndTime(int index) {
    return DateTime.parse(appointments[index].endDate!);
  }

  @override
  String getSubject(int index) {
    return appointments[index].title!;
  }


  Color getColor(int index) {
    // You can customize the event color here if needed
    return AppColors.buttonColor;
  }

  @override
  bool isAllDay(int index) {
    // You can set this to true if your events are all-day events
    return false;
  }
}