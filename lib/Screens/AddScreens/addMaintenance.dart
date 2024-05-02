import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/dataModel/warranty_card_listing_model.dart';
import 'package:responsive_dashboard/widgets/maintenance_table_widget.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:toastification/toastification.dart';

import '../../Services/Apis.dart';
import '../../component/custom/dropdown_field.dart';
import '../../component/header.dart';
import '../../config/responsive.dart';
import '../../constants/validation/basic_validation.dart';
import '../../routes/RoutePath.dart';

class AddMaintenance extends StatefulWidget {
  @override
  State<AddMaintenance> createState() => _AddMaintenanceState();
}

class _AddMaintenanceState extends State<AddMaintenance> {
  List<WarrantyData>? maintenanceData;

  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController phoneNo = TextEditingController();
  TextEditingController vechileNo = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController make = TextEditingController();
  TextEditingController segment = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController ceramicCoatingPackageController = TextEditingController();
  TextEditingController maintanenceDateController = TextEditingController();
  TextEditingController selectMaintenenceController = TextEditingController();
  TextEditingController chargeController = TextEditingController(text: '1500');
  TextEditingController searchController = TextEditingController();

  List<WarrantyData> searchResult = [];

  List<String> models = [];

  String selectedServiceForMaintenance = '';

  var _intervalValue = '';

  List colors = [];

  int numberOfMaintenance = 0;

  String invoiceNumber = '';

  var maintenancecharge = 0.0.obs;
  var taxAmount = 0.0.obs;
  var totalPayableAmt = 0.0.obs;

  @override
  void initState() {
    super.initState();

    if (maintenanceData == null) {
      fetchMaintenanceData();
    }
    fetchInvoiceList();
    estimatedata();
  }

  fetchInvoiceList() async {
    final res = await ApiProvider().getNewInvoiceNumber();
    invoiceNumber = '#DX$res';
    return res;
  }

  Future<void> fetchMaintenanceData() async {
    try {
      WarrantyCardListingModel fetchedData = await ApiProvider().getWarrantyListing();

      print(fetchedData);

      maintenanceData = fetchedData.data;
    } catch (e) {
      // Handle any errors that occur during the API call
      print("Error fetching maintenance data: $e");
    }
  }

  estimatedata() async {
    var responseData = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getModels'),
    );
    var model = jsonDecode(responseData.body.toString());
    if (model['status'] != 0) {
      List modelData = model['models'];
      modelData.forEach((val) {
        models.add(val['modal_name']);
      });
      _intervalValue = models.first;
      // models = model['models'];
    } else {
      models = [];
    }
    // var response = await http.get(
    //   Uri.parse('https://excelosoft.com/dxapp/public/api/getServices'),
    // );
    // print(response.body);
    // var data = jsonDecode(response.body.toString());
    // print(data);
    // if (data['status'] != 0) {
    //   List services = data['services'];
    //   services.forEach((element) {
    //     serviceList.add(element['name']);
    //   });
    // } else {
    //   serviceList = [];
    // }
    // print('serviceList=======');
    // print(serviceList);

    // var ppfresponse = await http.get(
    //   Uri.parse('https://excelosoft.com/dxapp/public/api/getPPFServices'),
    // );
    // print(ppfresponse.body);
    // var ppfdata = jsonDecode(ppfresponse.body.toString());
    // print(ppfdata);
    // if (ppfdata['status'] != 0) {
    //   List ppservices = ppfdata['services'];
    //   ppservices.forEach((element) {
    //     ppfServices.add(element['ppfservice_name']);
    //   });
    // } else {
    //   ppfServices = [];
    // }
    // print('serviceList=======');
    // print(serviceList);
    // // isChecked = List<bool>.filled(serviceList.length, false);
    setState(() {});
  }

  void showDateDailog(TextEditingController controller) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      // initialDate: DateTime.now(),
      // firstDate: DateTime.now(),
      // lastDate: DateTime(DateTime.now().year + 1),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        controller.text = formatter.format(pickedDate);
      },
    );
  }

  List<WarrantyData> searchMaintenance(searchQuery) {
    List<WarrantyData> maintenanceList = maintenanceData ?? [];
    List<WarrantyData> result = maintenanceList
        .where((maintenance) =>
            maintenance.name != null && maintenance.name!.toLowerCase().contains(searchQuery) ||
            maintenance.vehicleNumber != null && maintenance.vehicleNumber!.toLowerCase().contains(searchQuery))
        .toList();

    if (result.isNotEmpty) {
      final res = result[0];
      print(res);
      name.text = res.name ?? '';
      date.text = res.date ?? '';
      phoneNo.text = res.phone ?? '';
      model.text = res.modalName ?? '';
      make.text = res.makeId ?? '';
      vechileNo.text = res.vehicleNumber ?? '';
      color.text = res.color ?? '';
      year.text = res.year ?? '';
      ceramicCoatingPackageController.text = res.selectServicesPackage ?? '';
      selectedServiceForMaintenance = res.selectServicesName ?? '';
      numberOfMaintenance = int.parse(res.maintenanceNumber ?? '0');
      // maintanenceDateController.text = res.dueDate ?? [];
      maintenancecharge.value = double.parse(chargeController.text);
      taxAmount.value = maintenancecharge.value * 0.18;
      totalPayableAmt.value = maintenancecharge.value + taxAmount.value;
    } else {
      toastification.show(
        context: context,
        title: Text('No Warranty Card found with $searchQuery'),
        type: ToastificationType.error,
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<String> arr = List.generate(numberOfMaintenance, (index) => '${index + 1} Maintenance');

    print('arr, $arr');
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: Responsive.isMobile(context) ? 15 : 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2,
                    ),
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        runSpacing: 20,
                        alignment: WrapAlignment.spaceBetween,
                        runAlignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Maintenance',
                            style: GoogleFonts.poppins(
                              fontSize: Responsive.isMobile(context) ? 20 : 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                              CustomButton(
                                text: "Search",
                                onPressed: () {
                                  searchResult = searchMaintenance(searchController.text.toLowerCase());
                                  setState(() {});
                                },
                                width: Responsive.isMobile(context) ? 160 : 180,
                                height: 35,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add Maintenance',
                            style: GoogleFonts.poppins(
                              fontSize: Responsive.isMobile(context) ? 20 : 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                              CustomButton(
                                text: "Search",
                                onPressed: () {
                                  searchResult = searchMaintenance(searchController.text.toLowerCase());
                                  setState(() {});
                                },
                                width: 180,
                                height: 35,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                    if (searchResult.isNotEmpty) ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          Text(
                            'Invoice No. - $invoiceNumber',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          if (Responsive.isMobile(context)) ...[
                            Wrap(
                              children: [
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: name,
                                  labelText: "Name",
                                  hintext: "Your Name",
                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: date,
                                  labelText: "Delivery Date/Time",
                                  readOnly: true,
                                  isRightIcon: true,
                                  rightIcon: Icons.calendar_month,
                                  onTap: () {
                                    showDateDailog(date);
                                  },
                                  hintext: "Date",
                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: phoneNo,
                                  labelText: "Phone No.",
                                  isRightIcon: true,
                                  rightIcon: Icons.phone,
                                  hintext: "Phone No.",
                                  isDigitOnly: true,
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: name,
                                  labelText: "Name",
                                  hintext: "Your Name",
                                ),
                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: date,
                                  labelText: "Delivery Date/Time",
                                  readOnly: true,
                                  isRightIcon: true,
                                  rightIcon: Icons.calendar_month,
                                  onTap: () {
                                    showDateDailog(date);
                                  },
                                  hintext: "Date",
                                ),
                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: phoneNo,
                                  labelText: "Phone No.",
                                  isRightIcon: true,
                                  rightIcon: Icons.phone,
                                  hintext: "Phone No.",
                                  isDigitOnly: true,
                                ),
                              ],
                            ),
                          ],
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          if (Responsive.isMobile(context)) ...[
                            Wrap(
                              children: [
                                CustomSearchableDropdownFormField<String>(
                                  width: width,
                                  isMandatory: true,
                                  labelFontWeight: FontWeight.w500,
                                  label: 'Select Model',
                                  hintText: "Select Model",
                                  value: _intervalValue,
                                  items: models,
                                  validator: (value) => validateForNormalFeild(value: value, props: "Select Model"),
                                  onChanged: (value) async {
                                    var responseData = await http.post(
                                      Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$value'),
                                    );
                                    var model = jsonDecode(responseData.body.toString());
                                    if (model['status'] != 0) {
                                      var data = model['model'];
                                      make = TextEditingController(text: '${data['make_name']}');
                                      segment = TextEditingController(text: '${data['segment_name']}');
                                      colors = data['colors_name'];
                                      // _colorValue = colors.first;
                                      // modelId = data['id'];
                                    }
                                    setState(() {
                                      _intervalValue = value!;
                                    });
                                  },
                                ),
                                textFieldForWarranty(
                                  width: width,
                                  context: context,
                                  textEditingController: make,
                                  labelText: "Make",
                                  hintext: "Make",
                                  readOnly: true,
                                ),
                                textFieldForWarranty(
                                  width: width,
                                  context: context,
                                  textEditingController: vechileNo,
                                  labelText: "Vehicle NO.",
                                  hintext: "Vehicle NO.",
                                ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomSearchableDropdownFormField<String>(
                                  width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                  isMandatory: true,
                                  labelFontWeight: FontWeight.w500,
                                  label: 'Select Model',
                                  hintText: "Select Model",
                                  value: _intervalValue,
                                  items: models,
                                  validator: (value) => validateForNormalFeild(value: value, props: "Select Model"),
                                  onChanged: (value) async {
                                    var responseData = await http.post(
                                      Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$value'),
                                    );
                                    var model = jsonDecode(responseData.body.toString());
                                    if (model['status'] != 0) {
                                      var data = model['model'];
                                      make = TextEditingController(text: '${data['make_name']}');
                                      segment = TextEditingController(text: '${data['segment_name']}');
                                      colors = data['colors_name'];
                                      // _colorValue = colors.first;
                                      // modelId = data['id'];
                                    }
                                    setState(() {
                                      _intervalValue = value!;
                                    });
                                  },
                                ),
                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: make,
                                  labelText: "Make",
                                  hintext: "Make",
                                  readOnly: true,
                                ),
                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: vechileNo,
                                  labelText: "Vehicle NO.",
                                  hintext: "Vehicle NO.",
                                ),
                              ],
                            ),
                          ],
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          if (Responsive.isMobile(context)) ...[
                            Wrap(
                              children: [
                                textFieldForWarranty(
                                  context: context,
                                  width: width,
                                  textEditingController: color,
                                  labelText: "Color",
                                  hintext: "Color",
                                  readOnly: true,
                                ),
                                SizedBox(
                                  width: width / 20,
                                ),
                                textFieldForWarranty(
                                  width: width,
                                  context: context,
                                  textEditingController: year,
                                  labelText: "Year",
                                  hintext: "Year",
                                  isDigitOnly: true,
                                ),
                                Spacer(),
                              ],
                            ),
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: color,
                                  labelText: "Color",
                                  hintext: "Color",
                                  readOnly: true,
                                ),
                                SizedBox(
                                  width: width / 20,
                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                  context: context,
                                  textEditingController: year,
                                  labelText: "Year",
                                  hintext: "Year",
                                  isDigitOnly: true,
                                ),
                                Spacer(),
                              ],
                            ),
                          ],
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 8,
                          ),
                          Row(
                            children: [
                              Text(
                                'Service Details -',
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 3,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                selectedServiceForMaintenance,
                                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              textFieldForWarranty(
                                context: context,
                                textEditingController: ceramicCoatingPackageController,
                                labelText: "Package",
                                hintext: "Package",
                                readOnly: true,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          if (numberOfMaintenance > 0)
                            MaintenanceDetailTableWidget(
                              numberOfMaintenance: numberOfMaintenance,
                              dueDate: '24-23-23',
                              doneDate: '',
                            ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          if (numberOfMaintenance > 0) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDropdownFormField<String>(
                                  width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                  labelFontWeight: FontWeight.w500,
                                  label: "Select Maintenance",
                                  hintText: "Select Maintenance",
                                  value: '',
                                  items: arr,
                                  onChanged: (value) async {},
                                ),
                                // textFieldForWarranty(
                                //   context: context,
                                //   textEditingController: selectMaintenenceController,
                                //   labelText: "Select Maintenance",
                                //   hintext: "Select Maintenance",
                                //   isDigitOnly: true,
                                // ),

                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: maintanenceDateController,
                                  labelText: "Date",
                                  isRightIcon: true,
                                  readOnly: true,
                                  rightIcon: Icons.calendar_month,
                                  onTap: () {
                                    showDateDailog(maintanenceDateController);
                                  },
                                  hintext: "Date",
                                ),
                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: chargeController,
                                  labelText: "Charge",
                                  hintext: "Charge",
                                  isDigitOnly: true,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 4,
                            ),
                          ],
                          Container(
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
                                              maintenancecharge.value.toStringAsFixed(2).toString(),
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
                                              '+${taxAmount.value.toStringAsFixed(2).toString()}',
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
                                              totalPayableAmt.value.toStringAsFixed(2).toString(),
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
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          CustomContainer(
                            CustomButton(
                              text: "Generate Main Bill",
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map estimateData = Map();
                                  estimateData["name"] = name.text;
                                  estimateData["date"] = date.text;
                                  estimateData["email"] = '';
                                  estimateData["address"] = '';
                                  estimateData["vin"] = '';
                                  estimateData["gst"] = '';
                                  estimateData["estimated_delivery_time"] = '';
                                  estimateData["assigned_worker"] = '';
                                  estimateData["phone"] = phoneNo.text;
                                  estimateData["vehicle_number"] = vechileNo.text;
                                  estimateData["model_name"] = model.text;
                                  estimateData["model_id"] = model.text;
                                  estimateData["make_id"] = make.text;
                                  estimateData["year"] = year.text;
                                  estimateData["color"] = color.text;
                                  estimateData["segment"] = segment.text;

                                  estimateData["select_services_name"] = selectedServiceForMaintenance;
                                  estimateData["select_services_amount"] = chargeController.text;
                                  estimateData["select_services_package"] = ceramicCoatingPackageController.text;

                                  estimateData["ppf_services_type"] = '';
                                  estimateData["ppf_services_package"] = '';
                                  estimateData["ppf_services_amount"] = '';
                                  estimateData["ppf_services_name"] = "";
                                  estimateData["ppf_services_selected"] = '';

                                  estimateData["total_taxable_amount"] = taxAmount.value;
                                  estimateData["total_payable_amount"] = totalPayableAmt.value;

                                  estimateData["total_payable_amount"] = totalPayableAmt.value;

                                  estimateData["maintenance_number"] = taxAmount.value;
                                  estimateData["due_date"] = totalPayableAmt.value;

                                  estimateData["done_date"] = totalPayableAmt.value;
                                  estimateData["charges"] = totalPayableAmt.value;

                                  var storeEstimateRes = await ApiProvider().storeMaintenance(
                                    estimateData,
                                    maintenanceData![0].id.toString(),
                                  );

                                  if (storeEstimateRes['status'] == "1") {
                                    ApiProvider().storeInvoiceNumber(
                                      invoiceNumber,
                                      maintenanceData![0].id.toString(),
                                    );
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.success,
                                      title: Text(storeEstimateRes["message"]),
                                      autoCloseDuration: const Duration(seconds: 5),
                                    );
                                    Get.toNamed(RoutePath.maintenanceScreen);
                                  }
                                }
                              },
                              width: 180,
                              height: 35,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
