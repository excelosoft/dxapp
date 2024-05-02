// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:responsive_dashboard/constants/utils/text_utility.dart';
import 'package:responsive_dashboard/style/colors.dart';

import '../constants/string_methods.dart';

class MaintenanceDetailTableWidget extends StatelessWidget {
  final int numberOfMaintenance;
  final String dueDate;
  final String doneDate;

  const MaintenanceDetailTableWidget({
    Key? key,
    required this.numberOfMaintenance,
    required this.dueDate,
    required this.doneDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> arr = List.generate(numberOfMaintenance, (index) => '${getOrdinal(index + 1)} Maintenance');
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
              ...arr
                  .map(
                    (e) => _buildTableRow(
                      context,
                      [e, dueDate, doneDate],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
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
