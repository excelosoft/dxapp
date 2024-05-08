// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:responsive_dashboard/constants/utils/text_utility.dart';
import 'package:responsive_dashboard/style/colors.dart';

import '../constants/string_methods.dart';

class MaintenanceDetailTableWidget extends StatelessWidget {
  final int numberOfMaintenance;
  List<DateTime> serviceDueDates = [];
  final List<String> doneDate;

  MaintenanceDetailTableWidget({
    Key? key,
    required this.numberOfMaintenance,
    required this.serviceDueDates,
    required this.doneDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> arr = List.generate(numberOfMaintenance, (index) => '${getOrdinal(index + 1)} Maintenance');
    List<DateTime> validServiceDates =  serviceDueDates.sublist(1);
    return Container(
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
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(color: Colors.black),
            children: [
              _buildTableRow(
                context,
                ['MAINTENANCE', 'DUE DATE', 'Done ON'],
                color: AppColors.buttonColor,
              ),
              ...List.generate(
                numberOfMaintenance,
                    (index) => _buildTableRow(
                  context,
                  [
                    arr[index], // Maintenance entry

                    _getFormattedDate(serviceDueDates.length > index ? validServiceDates[index] : null),// Service date

                  doneDate[index],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime? date) {
    if (date != null) {
      return "${date.day} ${_getMonthName(date.month)} ${date.year}";
    } else {
      return 'N/A';
    }
  }
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  TableRow _buildTableRow(BuildContext context, List<String> rowData, {Color? color}) {
    return TableRow(
      children: rowData.map((cellData) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: AppText(
            textAlign: TextAlign.center,
            text: cellData,
            textColor: color,
            fontsize: 18,
            fontWeight: FontWeight.w700,
          ),
        );
      }).toList(),
    );
  }
}
class WarrantyDetailTableWidget extends StatelessWidget {
  final int numberOfMaintenance;
  List<DateTime> serviceDates = [];


   WarrantyDetailTableWidget({
    Key? key,
    required this.numberOfMaintenance,
    required this.serviceDates,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> arr = List.generate(numberOfMaintenance, (index) => '${getOrdinal(index + 1)} Maintenance');
    List<DateTime> validServiceDates = serviceDates.sublist(1);
    return Container(
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
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(color: Colors.black),
            children: [
              _buildTableRow(
                context,
                ['MAINTENANCE', 'DUE DATE',],
                color: AppColors.buttonColor,
              ),
              ...List.generate(
                numberOfMaintenance,
                    (index) => _buildTableRow(
                  context,
                  [
                    arr[index], // Maintenance entry
                        // Due date (replace with actual due date logic)
                    _getFormattedDate(serviceDates.length > index ? validServiceDates[index] : null),// Service date
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _getFormattedDate(DateTime? date) {
    if (date != null) {
      return "${date.day} ${_getMonthName(date.month)} ${date.year}";
    } else {
      return 'N/A';
    }
  }
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  TableRow _buildTableRow(BuildContext context, List<String> rowData, {Color? color}) {
    return TableRow(
      children: rowData.map((cellData) {
        return Container(
          padding: EdgeInsets.all(10.0),
          child: AppText(
            textAlign: TextAlign.center,
            text: cellData,
            textColor: color,
            fontsize: 18,
            fontWeight: FontWeight.w700,
          ),
        );
      }).toList(),
    );
  }
}
