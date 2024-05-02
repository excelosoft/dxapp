// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintenanceTotalAmountCalculation extends StatefulWidget {
  final String maintenancecharge;

  const MaintenanceTotalAmountCalculation({
    Key? key,
    required this.maintenancecharge,
  }) : super(key: key);

  @override
  State<MaintenanceTotalAmountCalculation> createState() => _MaintenanceTotalAmountCalculationState();
}

class _MaintenanceTotalAmountCalculationState extends State<MaintenanceTotalAmountCalculation> {
  var maintenancecharge = 0.0.obs;
  var taxAmount = 0.0.obs;
  var totalPayableAmt = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Maintenance Charge',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                      ),
                    )),
                Container(
                    width: 10,
                    child: Text(
                      '- ',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                      ),
                    )),
                Obx(
                  () => Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      alignment: Alignment.centerRight,
                      child: Text(
                        maintenancecharge.value.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 22,
                        ),
                      )),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tax(18%)',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                      ),
                    )),
                Container(
                    width: 10,
                    child: Text(
                      '- ',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                      ),
                    )),
                Obx(
                  () => Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      alignment: Alignment.centerRight,
                      child: Text(
                        taxAmount.value.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 22,
                        ),
                      )),
                )
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total Payable Amount',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                      ),
                    )),
                Container(
                    width: 10,
                    child: Text(
                      '- ',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                      ),
                    )),
                Obx(
                  () => Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      alignment: Alignment.centerRight,
                      child: Text(
                        totalPayableAmt.value.toString().toString(),
                        style: GoogleFonts.inter(
                          fontSize: 22,
                        ),
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
