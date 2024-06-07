import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/component/custom/dropdown_field.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/component/sideMenu.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/constants/validation/basic_validation.dart';
import 'package:responsive_dashboard/dataModel/bill_list_model.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:toastification/toastification.dart';

import '../../config/responsive.dart';
import '../../functions/date_picker.dart';
import '../../widgets/maintenance_table_widget.dart';

class AddWarrantyCard extends StatefulWidget {
  @override
  State<AddWarrantyCard> createState() => _AddWarrantyCardState();
}

class _AddWarrantyCardState extends State<AddWarrantyCard> {
  final BillListData? billData = Get.arguments;
  final isWarrantyEdit = Get.parameters['isEdit'];

  bool warrantyUpdated = false;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController maintain=TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController vechileNo = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController make = TextEditingController();
  TextEditingController segment = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController vin = TextEditingController();
  TextEditingController gstNo = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController estDate = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController estTime = TextEditingController(
    text: DateFormat('HH:mm').format(DateTime.now()),
  );
  TextEditingController AssignedWorkers = TextEditingController();
  TextEditingController ceramictypeController = TextEditingController();
  TextEditingController ceramicWarrantyController = TextEditingController(text: '5 year');
  TextEditingController ppfTypeController = TextEditingController();
  TextEditingController ppfPackage = TextEditingController();
  TextEditingController ppfWarrantController = TextEditingController();
  TextEditingController carWashTypeController = TextEditingController();
  TextEditingController cardWashWarrantyController = TextEditingController();
  TextEditingController noOfMaintenanceController = TextEditingController();
TextEditingController  selectePackageController = TextEditingController();




  List<String> selectedServiceList = [];

  var serviceList = [];

  List models = [];
  List models1 = [];
  var _intervalValue;

  List colors = [];

  var _colorValue = "";

  var modelId;

  // List<bool> isChecked = [];

  List ppfServices = [];
  bool isPPFVisible = false;
  bool isCeramicVisible = false;
  bool isCarWashVisible = false;

  String isSele = '';
  String selectePackage = '4 year';
  int noOfMaintenance=0;

  @override
  void initState() {
    super.initState();

    if (billData != null) {



      name.text = billData?.name ?? '';
      date.text = billData?.date ?? '';
      phoneNo.text = billData?.phone ?? '';
      Address.text = billData?.address ?? '';
      email.text = billData?.email ?? '';
      gstNo.text = billData?.gst ?? '';
      vechileNo.text = billData?.vehicleNumber ?? '';
      make.text = billData?.makeId ?? '';
      year.text = billData?.year ?? '';
      segment.text = billData?.segment ?? '';
      var splitVal = billData?.estimatedDeliveryTime ?? '';
      var value= splitVal.split(' ');
      estDate.text = value.first;
      estTime.text = value.last;
      vin.text = billData?.vin ?? '';
      AssignedWorkers.text = billData?.assignedWorker ?? '';
      modelId = billData?.modalName ?? 13;
      model.text = billData!.modalName ?? 'Swift';
      selectePackage=billData!.selectServices![0].package.toString()??'4 year';
      selectePackageController.text=billData!.selectServices![0].package.toString();
      RegExp regExp = RegExp(r'\d+');
      Match? match = regExp.firstMatch(billData!.selectServices![0].package.toString());
      //int years = int.parse(selectedPackage.split(' ')[0]??'0');
      int years = match != null ? int.parse(match.group(0)!) : 0;
      updateMaintenanceValue(billData!.selectServices![0].package.toString()??'0');
      divideService(years,value.first);
    }
    estimatedata();
  }
  void updateMaintenanceValue(String? selectedPackage) {
    if (selectedPackage != null) {
      RegExp regExp = RegExp(r'\d+');
      Match? match = regExp.firstMatch(selectedPackage);
      //int years = int.parse(selectedPackage.split(' ')[0]??'0');
      int years = match != null ? int.parse(match.group(0)!) : 0;

      int numberOfMaintenance = 2 * years - 1;
      noOfMaintenance = numberOfMaintenance;
    }
  }

  List<DateTime> serviceDates = [];
  List<DateTime> divideService( int years,String estDatas) {
    DateTime parsedDate = DateTime.parse(estDatas);


   // int yearsCount = int.parse(years.split(' ')[0]);
    int totalMonths = years * 12;

    // Calculate the number of services needed in total
    int totalServices = totalMonths ~/ 6;

    // Calculate the number of months between each service
    int monthsBetweenServices = totalMonths ~/ totalServices;

    // Calculate the first service date
    DateTime currentDate = parsedDate;

    for (int i = 0; i < totalServices; i++) {
      serviceDates.add(currentDate);
      // Move currentDate to the next service date
      currentDate = currentDate.add(Duration(days: monthsBetweenServices * 30));
    }

    return serviceDates;

  }
  estimatedata() async {

    var responseData = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getModels'),
    );
    // print(responseData.body);
    var model = jsonDecode(responseData.body.toString());
    // print(model);
    if (model['status'] != 0) {
      List modelData = model['models'];
      modelData.forEach((val) {
        models.add(val);
        models1.add(val['modal_name'].toString());
      });
      _intervalValue = models.first['modal_name'];
      // models = model['models'];

      if (billData != null) {
        _intervalValue = billData?.modalName?? 'Swift';
        getColors(billData?.modalName ?? 'Swift');
      }

      for (var model in models) {
        if (model['modal_name'] == _intervalValue) {
          // Found the matching model, set the modelId
          modelId = model['id'];
          break; // Exit the loop since we found the matching model
        }
      }
    } else {
      models = [];
    }
    // print('models=======');
    // print(models);

    var response = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getServices'),
    );
    // print(response.body);
    var data = jsonDecode(response.body.toString());
    // print(data);
    if (data['status'] != 0) {
      List services = data['services'];
      services.forEach((element) {
        serviceList.add(element['name']);
      });
    } else {
      serviceList = [];
    }
    // print('serviceList=======');
    // print(serviceList);

    var ppfresponse = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getPPFServices'),
    );
    // print(ppfresponse.body);
    var ppfdata = jsonDecode(ppfresponse.body.toString());
    // print(ppfdata);
    if (ppfdata['status'] != 0) {
      List ppservices = ppfdata['services'];
      ppservices.forEach((element) {
        ppfServices.add(element['ppfservice_name']);
      });
    } else {
      ppfServices = [];
    }
    // print('serviceList=======');
    // print(serviceList);
    // isChecked = List<bool>.filled(serviceList.length, false);
    setState(() {});
  }

  getColors(String selectedModel) async {
    var responseData = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$selectedModel'),
    );
    var model = jsonDecode(responseData.body.toString());
    if (model['status'] != 0) {
      var modelData = model['model'];
      colors = modelData['colors_name'];
      print(billData!.color);
      print('items , $colors');

      _colorValue = colors.first;
    }
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

  // String? _errorText;

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    setState(() {
      if (value.isEmpty) {
        // _errorText = 'Field cannot be empty';
      } else if (value.length > 10) {
        // _errorText = 'Maximum length exceeded';
      } else {
        // _errorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(billData);
    SizeConfig().init(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu()),
      body: Form(
        key: _formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add Warranty Card',
                          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    // 1 row
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        children: [
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: name,
                            labelText: "Name",
                            hintext: "Your Name",
                            isvalidationTrue: true,
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: date,
                            labelText: "Date",
                            isRightIcon: true,
                            readOnly: true,
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
                            isvalidationTrue: true,
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
                            isvalidationTrue: true,
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: date,
                            labelText: "Date",
                            isRightIcon: true,
                            isvalidationTrue: true,
                            readOnly: true,
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
                            isvalidationTrue: true,
                          ),
                        ],
                      ),
                    ],

                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),

                    //2 row
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        children: [
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: Address,
                            labelText: "Address",
                            isvalidationTrue: true,
                            hintext: "Address",
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: email,
                            labelText: "Email",
                            isvalidationTrue: true,
                            hintext: "Email",
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: vechileNo,
                            labelText: "Vechile No.",
                            hintext: "Vechile No.",
                            isvalidationTrue: true,
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textFieldForWarranty(
                            context: context,
                            textEditingController: Address,
                            labelText: "Address",
                            hintext: "Address",
                            isvalidationTrue: true,
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: email,
                            labelText: "Email",
                            hintext: "Email",
                            isvalidationTrue: true,
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: vechileNo,
                            labelText: "Vechile No.",
                            hintext: "Vechile No.",
                            isvalidationTrue: true,
                          ),
                        ],
                      ),
                    ],
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),

                    //3 row
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        children: [
                          CustomDropdownFormField<String>(
                            width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                            isMandatory: true,
                            labelFontWeight: FontWeight.w500,
                            label: 'Select Model',
                            hintText: "Select Model",
                            value: _intervalValue,
                            items: models,
                            validator: (value) => validateForNormalFeild(value: value, props: "Select Model"),
                            onChanged: (value) async {
                              print("Testtt");
                              var responseData = await http.post(
                                Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$value'),
                              );
                              print(responseData.body);
                              var model = jsonDecode(responseData.body.toString());
                              print(model);
                              if (model['status'] != 0) {
                                var data = model['model'];
                                make = TextEditingController(text: '${data['make_name']}');
                                segment = TextEditingController(text: '${data['segment_name']}');
                                colors = data['colors_name'];
                                _colorValue = colors.first;
                              }
                              setState(() {
                                _intervalValue = value!;
                              });
                            },
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: make,
                            labelText: "Make",
                            hintext: "Make",
                            isvalidationTrue: true,
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: year,
                            labelText: "Year",
                            hintext: "Year",
                            isvalidationTrue: true,
                            isDigitOnly: true,
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdownFormField<String>(
                            width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                            isMandatory: true,
                            labelFontWeight: FontWeight.w500,
                            label: 'Select Model',
                            hintText: "Select Model",
                            value: _intervalValue.toString(),
                            items: models1,
                            validator: (value) => validateForNormalFeild(value: value, props: "Select Model"),
                            onChanged: (value) async {
                              print("Testtt");
                              var responseData = await http.post(
                                Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$value'),
                              );
                              print(responseData.body);
                              var model = jsonDecode(responseData.body.toString());
                              print(model);
                              if (model['status'] != 0) {
                                var data = model['model'];
                                make = TextEditingController(text: '${data['make_name']}');
                                segment = TextEditingController(text: '${data['segment_name']}');
                                colors = data['colors_name'];
                                _colorValue = colors.first;
                              }
                              setState(() {
                                _intervalValue = value!;
                              });
                            },
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: make,
                            labelText: "Make",
                            hintext: "Make",
                            isvalidationTrue: true,
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: year,
                            labelText: "Year",
                            hintext: "Year",
                            isvalidationTrue: true,
                            isDigitOnly: true,
                          ),
                        ],
                      ),
                    ],

                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    //4 row
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        children: [
                          CustomDropdownFormField<String>(
                            width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                            labelFontWeight: FontWeight.w500,
                            label: 'Select Color',
                            hintText: "Select Color",
                            value: _colorValue,
                            items: colors,
                            // validator: (value) => validateForNormalFeild(value: value, props: "Color"),
                            onChanged: (value) async {
                              setState(() {
                                _colorValue = value!;
                              });
                            },
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: vin,
                            labelText: "VIN",
                            hintext: "VIN",
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: gstNo,
                            labelText: "GST No.",
                            hintext: "GST No.",
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdownFormField<String>(
                            width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,

                            labelFontWeight: FontWeight.w500,
                            label: 'Select Color',
                            hintText: "Select Color",
                            value: _colorValue,
                            items: colors,
                            // validator: (value) => validateForNormalFeild(value: value, props: "Color"),
                            onChanged: (value) async {
                              setState(() {
                                _colorValue = value!;
                              });
                            },
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: vin,
                            labelText: "VIN",
                            hintext: "VIN",
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: gstNo,
                            labelText: "GST No.",
                            hintext: "GST No.",
                          ),
                        ],
                      ),
                    ],

                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),

                    //5 row
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        children: [
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: segment,
                            labelText: "Segment",
                            hintext: "Segment",
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: estDate,
                            labelText: "Estimated Delivery Date",
                            isRightIcon: true,
                            isvalidationTrue: true,
                            rightIcon: Icons.calendar_month_outlined,
                            readOnly: true,
                            onTap: () {
                              // showDateDailog(estDate);
                              pickFromDateTime(
                                pickDate: true,
                                context: context,
                                controller: estDate,
                              );
                            },
                            hintext: "Estimated Delivery Date",
                          ),
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: estTime,
                            labelText: "Estimated Delivery Time",
                            isRightIcon: true,
                            isvalidationTrue: true,
                            rightIcon: Icons.watch_later_outlined,
                            readOnly: true,
                            onTap: () {
                              pickFromDateTime(
                                pickDate: false,
                                context: context,
                                controller: estTime,
                              );
                            },
                            hintext: "Estimated Delivery Time",
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textFieldForWarranty(
                            width: Responsive.isMobile(context) ? width : null,
                            context: context,
                            textEditingController: segment,
                            labelText: "Segment",
                            hintext: "Segment",
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: estDate,
                            labelText: "Estimated Delivery Date",
                            isRightIcon: true,
                            isvalidationTrue: true,
                            rightIcon: Icons.calendar_month_outlined,
                            readOnly: true,
                            onTap: () {
                              // showDateDailog(estDate);
                              pickFromDateTime(
                                pickDate: true,
                                context: context,
                                controller: estDate,
                              );
                            },
                            hintext: "Estimated Delivery Date",
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: estTime,
                            labelText: "Estimated Delivery Time",
                            isRightIcon: true,
                            isvalidationTrue: true,
                            rightIcon: Icons.watch_later_outlined,
                            readOnly: true,
                            onTap: () {
                              pickFromDateTime(
                                pickDate: false,
                                context: context,
                                controller: estTime,
                              );
                            },
                            hintext: "Estimated Delivery Time",
                          ),
                        ],
                      ),
                    ],
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    if (selectedServiceList.isNotEmpty)
                      Row(
                        children: [
                          Text(
                            'Services - ',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 2,
                    ),
                    if (billData != null && billData!.selectServices != null)
                      CustomContainer(
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runAlignment: WrapAlignment.start,
                          // spacing: 10,
                          runSpacing: 20,
                          children: billData!.selectServices!.map((f) {


                            List<String> allowedServices = ['Graphene Coating', 'Ceramic Coating'];

                            // selectedServiceList = billData!.selectServices!.where((service) {
                            //   // Check if the service is one of the allowed services
                            //   if (allowedServices.contains(service)) {
                            //     return true;
                            //   }

                            //   // Check if the service contains 'PPF' (case-insensitive)
                            //   if (service.toLowerCase().contains('ppf')) {
                            //     return true;
                            //   }

                            //   return false;
                            // }).toList();
                            selectedServiceList = billData!.selectServices!.where((service) {
                                  if (service.name != null) {
                                    return allowedServices.contains(service.name) || service.name!.toLowerCase().contains('ppf');
                                  }
                                  return false;
                                }).map((service) => service.name!).toList();

                            isSele = selectedServiceList.isNotEmpty ? selectedServiceList.first : '';

                            // if (selectedServiceList.contains(f)) {
                            //   // isSele = true;
                            // }

                            if (
                            f.name == 'Ceramic Coating' || f.name == 'Graphene Coating' || f.name!.contains('PPF')) {
                              return StatefulBuilder(
                                builder: (context, setstate) {
                                  return Container(
                                      // padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        // color: isSele ? Colors.red : Colors.white,
                                        // border: Border.all(color: Color(0xFF282f61), width: 2.0),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                                            onPressed: () {
                                              if (isSele == f.name) {
                                                isSele = '';
                                              } else {
                                                isSele = f.name ?? "";
                                              }
                                              setstate(() {});
                                              // if (!selectedServiceList.contains(f)) {
                                              //   selectedServiceList.add(f);
                                              //   setstate(() {});
                                              //   print(selectedServiceList);
                                              // } else {
                                              //   selectedServiceList.removeWhere((element) => element == f);
                                              //   setstate(() {});
                                              //   print(selectedServiceList);
                                              // }
                                            },
                                            icon: Icon(
                                              isSele == f.name ? Icons.check_box : Icons.check_box_outline_blank_rounded,
                                            ),
                                            label: Text(
                                              '${f.name}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: buildServiceFields(
                                              billData, isSele == f.name, selectePackage,
                                            ),
                                          ),



                                        ],
                                      )


                                      // Text('${f}',
                                      //   style: TextStyle(
                                      //     color: Colors.white ,
                                      //     fontSize: 16.0,
                                      //   ),
                                      // ),
                                      );
                                },
                              );
                            }
                            return SizedBox();
                          }).toList(),

                        ),
                      ),






                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 1,
                    ),
                    Visibility(
                      visible: isCeramicVisible,
                      child: Responsive.isMobile(context)
                          ? Wrap(
                              children: [
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: ceramictypeController,
                                  labelText: "Type",
                                  isRightIcon: true,
                                  hintext: "Type",
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       'Type',
                                //       style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                                //     ),
                                //     SizedBox(
                                //       height: 10,
                                //     ),
                                //     Container(
                                //       width: MediaQuery.of(context).size.width / 3.5,
                                //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                //       padding: EdgeInsets.symmetric(horizontal: 15),
                                //       child: TextFormField(
                                //         controller: year,
                                //         decoration: InputDecoration(hintText: '5 Year'),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Warranty Year',
                                      style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: TextFormField(
                                        controller: ceramicWarrantyController,
                                        decoration: InputDecoration(hintText: '5 Year'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3.5,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: ceramictypeController,
                                  labelText: "Type",
                                  isRightIcon: true,
                                  hintext: "Type",
                                ),
                                // Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       'Type',
                                //       style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                                //     ),
                                //     SizedBox(
                                //       height: 10,
                                //     ),
                                //     Container(
                                //       width: MediaQuery.of(context).size.width / 3.5,
                                //       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                //       padding: EdgeInsets.symmetric(horizontal: 15),
                                //       child: TextFormField(
                                //         controller: year,
                                //         decoration: InputDecoration(hintText: '5 Year'),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Warranty Year',
                                      style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      padding: EdgeInsets.symmetric(horizontal: 15),
                                      child: TextFormField(
                                        controller: ceramicWarrantyController,
                                        decoration: InputDecoration(hintText: '5 Year'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3.5,
                                ),
                              ],
                            ),
                    ),
                    StatefulBuilder(builder: (context, setstate) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (warrantyUpdated)
                            CustomButton(
                              buttonColor: Colors.blue,
                              onPressed: () async {
                                final id = billData!.id.toString();
                                html.window.open('https://excelosoft.com/dxapp/public/warrantycards/$id', '_blank');

                                // html.window.open('https://excelosoft.com/dxapp/public/api/getWarrantyCardsPDF/$id', '_blank');
                              },
                              text: "Print Warranty",
                              width: 180,
                              height: 35,
                            ),
                          SizedBox(
                            width: 20,
                          ),
                          CustomButton(
                            onPressed: () async {

                              DateTime? parsedDate = DateTime.tryParse(estDate.text);
                              TimeOfDay? parsedTime;

// Parse time
                              List<String> timeParts = estTime.text.split(':');
                              if (timeParts.length == 2) {
                                int hour = int.tryParse(timeParts[0]) ?? 0;
                                int minute = int.tryParse(timeParts[1]) ?? 0;
                                parsedTime = TimeOfDay(hour: hour, minute: minute);
                              }

                              String estimatedDeliveryTime = "N/A";
                              if (parsedDate != null && parsedTime != null) {
                                DateTime deliveryDateTime = DateTime(
                                  parsedDate.year,
                                  parsedDate.month,
                                  parsedDate.day,
                                  parsedTime.hour,
                                  parsedTime.minute,
                                );
                                estimatedDeliveryTime = deliveryDateTime.toString();
                              }


                              // warrantyData["maintenance_number"] = totalMaintenance.toString();
                              if (_formKey.currentState!.validate()) {
                                Map<String, dynamic> warrantyData = {};
                                warrantyData["name"] = name.text.toString();
                                warrantyData["date"] = date.text.toString();
                                warrantyData["email"] = email.text.toString();
                                 warrantyData["phone"] = phoneNo.text.toString();
                                warrantyData["address"] = Address.text.toString();
                                warrantyData["vehicle_number"] = vechileNo.text.toString();
                                 warrantyData["model_id"] = modelId.toString();
                                warrantyData["modal_name"] = model.text.toString();
                                warrantyData["make_id"] = make.text.toString();
                                warrantyData["year"] = year.text.toString();
                                warrantyData["color"] = _colorValue;
                                warrantyData["vin"] = vin.text.toString();
                                warrantyData["gst"] = gstNo.text.toString();
                                warrantyData["segment"] = segment.text.toString();

                                warrantyData["assigned_worker"] = AssignedWorkers.text.toString();
                                // warrantyData["customer_id"] = billData?.id.toString();

                                // warrantyData["select_services_name"] = billData?.selectServicesName;
                                // warrantyData["select_services_type"] = billData?.selectServicesType;
                                // warrantyData["select_services_amount"] = billData?.selectServicesAmount;
                                // warrantyData["select_services_package"] = billData?.selectServicesPackage;
                                // warrantyData["ppf_services_name"] = billData?.ppfServicesName;
                                // warrantyData["ppf_services_type"] = billData?.ppfServicesType;
                                // warrantyData["ppf_services_package"] = billData?.ppfServicesPackage;

                                warrantyData["select_services_name"] = billData?.selectServices?.map((service) => service.name).toList() ?? [];
                                warrantyData["select_services_type"] = billData?.selectServices?.map((service) => service.type).toList() ?? [];
                                warrantyData["select_services_amount"] = billData?.selectServices?.map((service) => service.amount).toList() ?? [];
                                warrantyData["select_services_package"] = billData?.selectServices?.map((service) => service.package).toList() ?? [];

                                warrantyData["ppf_services_name"] = billData?.ppfServices?.map((service) => service.name).toList() ?? [];
                                warrantyData["ppf_services_type"] = billData?.ppfServices?.map((service) => service.type).toList() ?? [];
                                warrantyData["ppf_services_package"] = billData?.ppfServices?.map((service) => service.package).toList() ?? [];

                                warrantyData["estimated_delivery_time"] =   estDate.text.toString()+ ' ' +estTime.text.toString();


                                // int years = int.parse(selectePackage.split(' ')[0]); // Extract the number of years
                                // DateTime currentDate = DateTime.now();
                                // DateTime estimatedDeliveryDate = currentDate.add(Duration(days: years * 365));
                                //
                                // int differenceInMonths = currentDate.difference(estimatedDeliveryDate).inDays ~/ 30;
                                // int totalMaintenance = (differenceInMonths / 6).ceil().abs();
                                //
                                // Duration maintenanceInterval = Duration(days: 180);
                                // List<String> dueDates = [];
                                // List<String> doneDates = List.filled(totalMaintenance, "");
                                //
                                // DateTime currentDueDate = estimatedDeliveryDate;
                                // for (int i = 0; i < totalMaintenance; i++) {
                                //   dueDates.add(currentDueDate.toString());
                                //   currentDueDate = currentDueDate.add(maintenanceInterval);
                                // }

                                warrantyData["maintenance_number"] = noOfMaintenance.toString();
                                List<String> serviceDateStrings = serviceDates.map((dateTime) => dateTime.toIso8601String().split('T')[0]).toList();
                                warrantyData["due_date"] = serviceDateStrings;
                                warrantyData["done_date"] = [];

                                var storeEstimateRes;

                                if (billData != null) {
                                  storeEstimateRes = await ApiProvider().storeWarrantyCard(warrantyData, billData!.id.toString());
                                }
                                if (storeEstimateRes['status'] == "1") {
                                  setState(() {});
                                  toastification.show(
                                    context: context,
                                    type: ToastificationType.success,
                                    title: Text(storeEstimateRes["message"]),
                                    autoCloseDuration: const Duration(seconds: 5),
                                  );
                                  if (isWarrantyEdit != null) {
                                    warrantyUpdated = true;
                                    setstate(() {});
                                  } else {
                                    Get.toNamed(RoutePath.warrantyScreen);
                                  }
                                }
                              }
                            },
                            text: "Update Warranty",
                            width: 180,
                            height: 35,
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildServiceFields(
      BillListData? selectedResponseServerRes,
      bool isSelected,
      String selectePackage,

  ) {
    if (isSelected) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textFieldForWarranty(
                width: MediaQuery.of(context).size.width / 3.5,
                context: context,
                textEditingController:selectePackageController ,
                labelText: "Package",
                hintext: "selectePackage",
              ),

              // CustomDropdownFormField<String>(
              //   width: MediaQuery.of(context).size.width / 3.5,
              //   hintText: "Select Package Time (Year)",
              //   label: "Package",
              //   value: selectePackage,
              //   items: ['1 year', '2 year', '3 year', '4 year', '5 year'],
              //   onChanged: (value) {
              //     selectePackage = value!;
              //     // Extract the number of years selected
              //     int years = int.parse(value.split(' ')[0]);
              //     // Calculate the number of maintenance
              //     int numberOfMaintenance = 2 * years - 1;
              //     // Set the calculated number of maintenance to the text controller
              //
              //   },
              // ),
              SizedBox(
                width: 30,
              ),
              // textFieldForWarranty(
              //   width: MediaQuery.of(context).size.width / 3.5,
              //   context: context,
              //   textEditingController:noOfMaintenanceController ,
              //   labelText: "No. of Maintenance",
              //   hintext: "Maintenance",
              // ),
              //
              // SizedBox(
              //   width: 30,
              // ),
              // SizedBox(height: 200,
              //   width: 300,
              //   child: ListView.builder(
              //     itemCount: serviceDates.length,
              //     itemBuilder: (context, index) {
              //       DateTime date = serviceDates[index];
              //       return ListTile(
              //         title: Row(
              //           children: [
              //             Text(
              //               "${_getIndexWithOrdinal(index + 1)} :- ",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //
              //             Text(
              //               "${date.day} ${_getMonthName(date.month)} ${date.year}",
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //
              //       );
              //     },
              //   ),
              // ),
              if (noOfMaintenance >= 0)
                Container(

                  width: MediaQuery.sizeOf(context).width*.5,
                  child: WarrantyDetailTableWidget(
                    numberOfMaintenance: noOfMaintenance,
                     serviceDates: serviceDates ,

                  ),
                ),

            ],
          ),

        ],
      );
    }
    return Container();
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

  String _getIndexWithOrdinal(int index) {
    if (index >= 10 && index <= 20) {
      return '$index' + 'th';
    }
    switch (index % 10) {
      case 1:
        return '$index' + 'st';
      case 2:
        return '$index' + 'nd';
      case 3:
        return '$index' + 'rd';
      default:
        return '$index' + 'th';
    }
  }

}
