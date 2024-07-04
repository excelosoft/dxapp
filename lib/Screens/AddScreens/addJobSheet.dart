// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_html/html.dart' as html;

import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/component/custom/dropdown_field.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/component/sideMenu.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/constants/validation/basic_validation.dart';
import 'package:responsive_dashboard/dataModel/estimate_list_model.dart';
import 'package:responsive_dashboard/style/colors.dart';

import '../../routes/RoutePath.dart';

class AddJobSheet extends StatefulWidget {
  @override
  State<AddJobSheet> createState() => _AddJobSheetState();
}

class _AddJobSheetState extends State<AddJobSheet> {
  final args = Get.arguments;
  final isJobEdit = Get.parameters['isEdit'];

  final EstimateData? jobData = Get.arguments != null ? Get.arguments['matchingEstimate'] : null;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController phoneNo = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController vechileNo = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController make = TextEditingController();
  TextEditingController segment = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController colorValue = TextEditingController();
  TextEditingController vin = TextEditingController();
  TextEditingController gstNo = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController estDateTime = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController AssignedWorkers = TextEditingController();
  // TextEditingController ceramicCoatingController = TextEditingController();
  List<TextEditingController> controllers = [];
  TextEditingController ppfController = TextEditingController();
  TextEditingController carWashController = TextEditingController();
  TextEditingController alloyCoatingController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  Map<int, TextEditingController> controllersMap = {};

  var selectedServiceList = [];
  var selectedppfServiceList = [];
  var serviceList = [];
  var ppfserviceRateDataList = [];

  List<String> models = [];

  var _intervalValue = '';

  List colors = [];

  var _colorValue = '';

  var modelId;

  // List<bool> isChecked = [];

  List ppfServices = [];

  List projectPhotosUrls = [];
  List photosToUploaded = [];

  bool jobsheetUpdated = false;

  @override
  void initState() {
    super.initState();
    estimatedata();
    if (jobData != Null) {
      print('remarks ======== > ${args}'); remarksController.text = args['remarks']??'';
      // if (controllers.length > 0) {
      //   controllers[0].text = args['description'];
      // }

      name.text = jobData!.name ?? '';
      date.text = jobData?.date ?? '';
      phoneNo.text = jobData?.phone ?? '';
      Address.text = jobData?.address ?? '';
      vechileNo.text = jobData?.vehicleNumber ?? '';
      make.text = jobData?.makeId ?? '';
      year.text = jobData?.year ?? '';
      segment.text = jobData?.segment ?? '';
      estDateTime.text = jobData?.estimatedDeliveryTime ?? '';
      vin.text = jobData?.vin ?? '';
      colorValue.text=jobData?.color??'';
      AssignedWorkers.text = jobData?.assignedWorker ?? '';
      modelId = jobData?.modelId ?? 13;
      model.text = jobData?.modalName ?? "Punch";
    }
  }

  estimatedata() async {
    var responseData = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getModels'),
    );
    print(responseData.body);
    var model = jsonDecode(responseData.body.toString());
    print(model);
    if (model['status'] != 0) {
      List modelData = model['models'];
      modelData.forEach((val) {
        models.add(val['modal_name']);
      });
      _intervalValue = models.first;

      print('modeal -------> ,${jobData?.modalName}');
      if (jobData != null) {
        _intervalValue = jobData?.modalName ?? 'Swift';
        getColors(jobData?.modalName ?? 'Swift');
      }
      // models = model['models'];
      // modelId = '';
      for (var model in modelData) {
        if (model['modal_name'] == _intervalValue) {
          modelId = model['id'].toString();
          break;
        }
      }
    } else {
      models = [];
    }

    var response = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getServices'),
    );
    var data = jsonDecode(response.body.toString());

    if (data['status'] != 0) {
      List services = data['services'];
      services.forEach((element) {
        serviceList.add(element['name']);
      });
    } else {
      serviceList = [];
    }

    var ppfresponse = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getPPFServices'),
    );
    print(ppfresponse.body);
    var ppfdata = jsonDecode(ppfresponse.body.toString());
    print(ppfdata);
    if (ppfdata['status'] != 0) {
      List ppservices = ppfdata['services'];
      ppservices.forEach((element) {
        ppfServices.add(element['ppfservice_name']);
      });
    } else {
      ppfServices = [];
    }
    print('serviceList=======');
    print(serviceList);
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

      // if (jobData != null) {
      //   _colorValue = jobData!.color!;
      // } else {
      _colorValue = colors.first;
      // }
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    SizeConfig().init(context);
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 5,
                    ),
                    Text(
                      'Add Job Sheet',
                      style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        children: [
                          textFieldForWarranty(
                            width: width,
                            context: context,
                            textEditingController: name,
                            labelText: "Name",
                            hintext: "Your Name",
                            isvalidationTrue: true,
                          ),
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
                                _colorValue = colors.first;
                                modelId = data['id'];
                              }
                              setState(() {
                                _intervalValue = value!;
                              });
                            },
                          ),
                          textFieldForWarranty(
                            width: width,
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
                            textEditingController: name,
                            labelText: "Name",
                            hintext: "Your Name",
                            isvalidationTrue: true,
                          ),
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
                                _colorValue = colors.first;
                                modelId = data['id'];
                              }
                              setState(() {
                                _intervalValue = value!;
                              });
                            },
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
                    if (Responsive.isMobile(context)) ...[
                      Wrap(
                        children: [
                          textFieldForWarranty(
                            width: width,
                            context: context,
                            textEditingController: make,
                            labelText: "Make",
                            hintext: "Make",
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            context: context,
                            width: width,
                            textEditingController: vin,
                            labelText: "VIN",
                            hintext: "VIN",
                          ),
                          textFieldForWarranty(
                            width: width,
                            context: context,
                            textEditingController: year,
                            labelText: "Year",
                            hintext: "Year",
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textFieldForWarranty(
                            context: context,
                            textEditingController: make,
                            labelText: "Make",
                            hintext: "Make",
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: vin,
                            labelText: "VIN",
                            hintext: "VIN",
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: year,
                            labelText: "Year",
                            hintext: "Year",
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
                            width: width,
                            context: context,
                            textEditingController: colorValue,
                            labelText: "Segment",
                            hintext: "Segment",
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            width: width,
                            context: context,
                            textEditingController: segment,
                            labelText: "Segment",
                            hintext: "Segment",
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            width: width,
                            context: context,
                            textEditingController: estDateTime,
                            labelText: "Estimated Delivery Date/Time",
                            isRightIcon: true,
                            readOnly: true,
                            rightIcon: Icons.calendar_month,
                            onTap: () {
                              showDateDailog(estDateTime);
                            },
                            hintext: "Estimated Delivery Date/Time",
                          ),
                        ],
                      ),
                    ] else ...[

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textFieldForWarranty(
                            context: context,
                            textEditingController: colorValue,
                            labelText: "Color",
                            hintext: "Color",
                            readOnly: true,
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: segment,
                            labelText: "Segment",
                            hintext: "Segment",
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: estDateTime,
                            labelText: "Estimated Delivery Date/Time",
                            isRightIcon: true,
                            readOnly: true,
                            rightIcon: Icons.calendar_month,
                            onTap: () {
                              showDateDailog(estDateTime);
                            },
                            hintext: "Estimated Delivery Date/Time",
                          ),

                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //
                      //     textFieldForWarranty(
                      //       width: width,
                      //       context: context,
                      //       textEditingController: colorValue,
                      //       labelText: "Segment",
                      //       hintext: "Segment",
                      //       readOnly: true,
                      //     ),
                      //     textFieldForWarranty(
                      //       context: context,
                      //       textEditingController: segment,
                      //       labelText: "Segment",
                      //       hintext: "Segment",
                      //       readOnly: true,
                      //     ),
                      //     textFieldForWarranty(
                      //       context: context,
                      //       textEditingController: estDateTime,
                      //       labelText: "Estimated Delivery Date/Time",
                      //       isRightIcon: true,
                      //       readOnly: true,
                      //       rightIcon: Icons.calendar_month,
                      //       onTap: () {
                      //         showDateDailog(estDateTime);
                      //       },
                      //       hintext: "Estimated Delivery Date/Time",
                      //     ),
                      //   ],
                      // ),
                    ],
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    textFieldForWarranty(
                      width: Responsive.isMobile(context) ? width : null,
                      context: context,
                      textEditingController: AssignedWorkers,
                      labelText: "Assigned Workers",
                      isRightIcon: true,
                      rightIcon: Icons.person,
                      hintext: "Assigned Workers",
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 8,
                    ),
                    if (jobData != null &&
                        jobData!.ppfServices != null &&
                        jobData!.ppfServices!.isNotEmpty &&
                        jobData!.ppfServices![0].services != null &&
                        jobData!.ppfServices![0].services!.isNotEmpty) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (jobData!.ppfServices != null && jobData!.ppfServices!.isNotEmpty) ...[
                            Text(
                              jobData!.ppfServices![0].name ?? "N/A",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runAlignment: WrapAlignment.start,
                              spacing: 10,
                              runSpacing: 10,
                              children: jobData!.ppfServices![0].services!.map((f) {
                                bool isSele = false;
                                final selectedppfServiceList = jobData!.ppfServices?[0].services;
                                if (selectedppfServiceList!.contains(f)) {
                                  isSele = true;
                                }
                                return GestureDetector(
                                  child: Container(
                                      padding: EdgeInsets.only(right: 5.0, top: 8.0, bottom: 8),
                                      decoration: BoxDecoration(
                                        // color: isSele ? Colors.red : Colors.white,
                                        // border: Border.all(color: Color(0xFF282f61), width: 2.0),
                                        borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                                          onPressed: () {
                                            // ppfserviceRateDataList.forEach((element) {});
                                            if (!selectedppfServiceList.contains(f)) {
                                              // if (serviceList.length < 5) {
                                              // selectedppfServiceList.add(f);
                                              // setState(() {});
                                              // ppfAmount.text = (int.parse(ppfAmount.text) +
                                              //     ((selectedPPFRateData != null && selectedPPFRateData["rate"] != null) ? int.parse(selectedPPFRateData["rate"]) : 0))
                                              // .toString();
                                              // totalServiceAmt.value += int.parse(ppfAmount.text);
                                              // calculateTotalBill(totalServiceAmt.value);
                                              // setState(() {});
                                              // print(selectedppfServiceList);
                                              // }
                                            } else {
                                              // ppfAmount.text = (int.parse(ppfAmount.text) -
                                              //         ((selectedPPFRateData != null && selectedPPFRateData["rate"] != null) ? int.parse(selectedPPFRateData["rate"]) : 0))
                                              //     .toString();
                                              // totalServiceAmt.value = totalServiceAmt.value - double.parse(ppfAmount.text);
                                              // calculateTotalBill(totalServiceAmt.value);
                                              // selectedppfServiceList.removeWhere((element) => element == f);
                                              // setState(() {});
                                              // selectedppfServiceList.removeWhere((element) => element == f);
                                              // setState(() {});
                                              // int rateToRemove = int.parse(selectedPPFRateData["rate"] ?? '0');

                                              // print(selectedppfServiceList);
                                              // print(selectedppfServiceList);
                                            }
                                          },
                                          icon: Icon(isSele ? Icons.check_box : Icons.check_box_outline_blank_rounded),
                                          label: Text(
                                            '${f}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                            ),
                                          ))
                                      // Text('${f}',
                                      //   style: TextStyle(
                                      //     color: Colors.white ,
                                      //     fontSize: 16.0,
                                      //   ),
                                      // ),
                                      ),
                                  onTap: () {
                                    if (!selectedppfServiceList.contains(f)) {
                                      // if (serviceList.length < 5) {
                                      selectedppfServiceList.add(f);
                                      setState(() {});
                                      print(selectedppfServiceList);
                                      // }
                                    } else {
                                      selectedppfServiceList.removeWhere((element) => element == f);
                                      setState(() {});
                                      print(selectedppfServiceList);
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 5,
                      ),
                    ],

                    // // Amount Contianer
                    Text(
                      'Services - ',
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 3,
                    ),
                    if (jobData != null && jobData!.selectServices != null)
                      Column(children: [
                        ...jobData!.selectServices!.asMap().entries.map((entry) {
                          int index = entry.key;
                          SelectServices service = entry.value;

                          String savedValue = args['description']??'';
                          List<String> savedValuesList = savedValue.split(',');

                          // Extract the value for the current index
                          String savedValues = index < savedValuesList.length ? savedValuesList[index] : '';// Replace this with your saved value retrieval logic
                          ValueNotifier<String> textValueNotifier = ValueNotifier(savedValues);


                          // Create a TextEditingController with the saved value
                          TextEditingController controller = TextEditingController(text: savedValues);


                          controllersMap[index] = controller;

                          // If there's a stored value for this index, set the controller's text

                          void onTextChanged(String newText) {
                            // Update the saved value
                            savedValue = newText;
                            // Notify listeners about the change
                            textValueNotifier.value = newText;
                            // You may want to save it to a database or another storage mechanism here
                            print('Value changed: $newText');
                          }

                          controller.addListener(() {
                            onTextChanged(controller.text);
                          });

                          return CustomContainer(
                            textFieldForFullWidth(

                              context: context,
                              textEditingController: controller,
                              labelText: '${service.name} ${service.package} ${service.type}',
                              hintext: "Type here...",

                            ),
                            marginbottom: SizeConfig.blockSizeVertical! * 4,
                          );
                        }).toList(),
                        CustomContainer(
                          textFieldForFullWidth(
                            context: context,
                            textEditingController: remarksController,
                            labelText: "Remarks",
                            hintext: "Type here...",
                          ),
                          marginbottom: SizeConfig.blockSizeVertical! * 4,
                        ),
                      ]),

                    // textFieldForFullWidth(
                    //   context: context,
                    //   textEditingController: ceramicCoatingController,
                    //   labelText: "1. Ceramic Coating 5 year gloss",
                    //   hintext: "type here...",
                    // ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 4,
                    // ),
                    // textFieldForFullWidth(
                    //   context: context,
                    //   textEditingController: ppfController,
                    //   labelText: "2. PPF",
                    //   hintext: "type here...",
                    // ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 2,
                    // ),
                    // textFieldForFullWidth(
                    //   context: context,
                    //   textEditingController: carWashController,
                    //   labelText: "3. Car Wash",
                    //   hintext: "type here...",
                    // ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 2,
                    // ),
                    // textFieldForFullWidth(
                    //   context: context,
                    //   textEditingController: alloyCoatingController,
                    //   labelText: "4. alloy coating",
                    //   hintext: "type here...",
                    // ),
                    // SizedBox(
                    //   height: SizeConfig.blockSizeVertical! * 2,
                    // ),
                    // textFieldForFullWidth(
                    //   context: context,
                    //   textEditingController: remarksController,
                    //   labelText: "5. Remarks -",
                    //   hintext: "type here...",
                    // ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical! * 4,
                    ),
                    ImageContainerForJobSheet(
                      projectPhotosUrls: projectPhotosUrls,
                      imagesToUploaded: photosToUploaded,
                    ),

                    StatefulBuilder(builder: (context, setstate) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (jobsheetUpdated)
                            CustomButton(
                              buttonColor: Colors.blue,
                              text: 'Print Job Sheet',
                              onPressed: () async {
                                final id = jobData!.id.toString();
                                https://excelosoft.com/dxapp/public/jobsheets/112/pdf
                                html.window.open('https://excelosoft.com/dxapp/public/jobsheets/$id/pdf', '_blank');
                              },
                              width: 180,
                              height: 35,
                            ),
                          SizedBox(
                            width: 20,
                          ),
                          CustomButton(
                            text: isJobEdit == null ? "Create Job Sheet" : 'Update Job Sheet',
                            onPressed: () async {
                              Map<String, dynamic> jobDataMap = {
                                "estimateId": jobData?.id,
                                "name": name.text.isNotEmpty ? name.text : "N/A",
                                "date": date.text.isNotEmpty ? date.text : "N/A",
                                "email": email.text.isNotEmpty ? email.text : "N/A",
                                "phone": phoneNo.text.isNotEmpty ? phoneNo.text : "N/A",
                                "address": Address.text.isNotEmpty ? Address.text : "N/A",
                                "vehicle_number": vechileNo.text.isNotEmpty ? vechileNo.text : "N/A",
                                "model_id": modelId,
                                "make_id": make.text.isNotEmpty ? make.text : "N/A",
                                "year": year.text.isNotEmpty ? year.text : "N/A",
                                "color": colorValue.text.isNotEmpty ? colorValue.text : "N/A",
                                "vin": vin.text.isNotEmpty ? vin.text : "N/A",
                                "gst": gstNo.text.isNotEmpty ? gstNo.text : "N/A",
                                "segment": segment.text.isNotEmpty ? segment.text : "N/A",
                                "select_services_name": jobData?.selectServices?.map((e) => e.name).toList(),
                                "select_services_type": jobData?.selectServices?.map((e) => e.type).toList(),
                                "select_services_package": jobData?.selectServices?.map((e) => e.package).toList(),
                                "select_services_amount": jobData?.selectServices?.map((e) => e.amount).toList(),
                                "services_selected": jobData?.selectServices?.map((e) => e.name).toList(),

                                // "ppf_services_name": jobData?.ppfServices?.map((e) => e.name).toList(),
                                // "ppf_services_type": jobData?.selectServices?.map((e) => e.type).toList(),
                                // "ppf_services_package": jobData?.selectServices?.map((e) => e.package).toList(),
                                // "ppf_services_amount": jobData?.selectServices?.map((e) => e.amount).toList(),
                                // "ppf_services_selected": jobData?.selectServices?.map((e) => e.name).toList(),

                                "modal_name": jobData?.modalName,
                                //"description": controllers.length > 0 ? controllers[0].text : "",
                                "carphoto": photosToUploaded,
                                "assigned_worker": AssignedWorkers.text,
                                "estimated_delivery_time": estDateTime.text.toString(),
                                "remarks": remarksController.text,
                              };
                              List<String> controllerValues = controllersMap.values.map((controller) => controller.text).toList();

// Convert the list of controller values to a single string
                              String allValuesAsString = controllerValues.join(',');

// Add the single string to the jobDataMap
                              jobDataMap["description"] = allValuesAsString;
                              var response = await ApiProvider().storeJobSheet(jobDataMap);
                              if (response['status'] == "1") {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.success,
                                  title: Text(response["message"]),
                                  autoCloseDuration: const Duration(seconds: 5),
                                );
                                if (isJobEdit == null) {
                                  Get.toNamed(RoutePath.jobSheetScreen);
                                } else {
                                  jobsheetUpdated = true;
                                  setstate(() {});
                                }
                              } else {
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.error,
                                  title: Text(response["message"]),
                                  autoCloseDuration: const Duration(seconds: 5),
                                );
                              }
                            },
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
        ],
      ),
    );
  }
}

class ImageContainerForJobSheet extends StatefulWidget {
  final List projectPhotosUrls;
  final List imagesToUploaded;

  const ImageContainerForJobSheet({
    Key? key,
    required this.projectPhotosUrls,
    required this.imagesToUploaded,
  }) : super(key: key);

  @override
  State<ImageContainerForJobSheet> createState() => _ImageContainerForJobSheetState();
}

class _ImageContainerForJobSheetState extends State<ImageContainerForJobSheet> {
  Future<void> selectImage(context, bool fromGallery) async {
    if (fromGallery) {
      List<XFile>? pickedImages = await ImagePicker().pickMultiImage(maxWidth: 1000, maxHeight: 1000);
      if (pickedImages.isNotEmpty) {
        for (var i = 0; i < pickedImages.length; i++) {
          var webUrl = await pickedImages[i].readAsBytes();
          var imageUrl = File(pickedImages[i].path);
          widget.imagesToUploaded.add(imageUrl.path);
          if (kIsWeb) {
            widget.projectPhotosUrls.add(webUrl);
          } else {
            widget.projectPhotosUrls.add(imageUrl);
          }
          setState(() {});
        }
      }
    } else {
      XFile? pickedImage = await ImagePicker().pickImage(maxWidth: 1000, maxHeight: 1000, source: ImageSource.camera);
      var webUrl = await pickedImage?.readAsBytes();
      var imageUrl = File(pickedImage!.path);
      if (kIsWeb) {
        widget.projectPhotosUrls.add(webUrl);
      } else {
        widget.projectPhotosUrls.add(imageUrl);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)
              CustomInkWell(
                onTap: () {
                  selectImage(context, false);
                },
                child: Container(
                  width: 110,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.camera,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            SizedBox(width: 7),
            CustomInkWell(
              onTap: () {
                selectImage(context, true);
              },
              child: Container(
                width: 110,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 120,
          width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width * 0.3 : MediaQuery.of(context).size.width * 0.5,
          child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.projectPhotosUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.grey[300],
                        child: SizedBox(
                          width: 220,
                          height: 140,
                          child: kIsWeb
                              ? Image.memory(
                                  widget.projectPhotosUrls[index],
                                  fit: BoxFit.fill,
                                )
                              : Image.file(
                                  widget.projectPhotosUrls[index],
                                  fit: BoxFit.fill,
                                ),
                        ))
                  ],
                );
              }),
        ),
      ],
    );
  }
}
