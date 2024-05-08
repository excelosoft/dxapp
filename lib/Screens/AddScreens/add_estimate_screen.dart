import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/Services/BaseUrl.dart';
import 'package:responsive_dashboard/Services/request_url.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/component/custom/dropdown_field.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/constants/app_constant.dart';
import 'package:responsive_dashboard/constants/string_methods.dart';
import 'package:responsive_dashboard/constants/utils/text_utility.dart';
import 'package:responsive_dashboard/constants/validation/basic_validation.dart';
import 'package:responsive_dashboard/functions/date_picker.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/utils/loginUtility.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:toastification/toastification.dart';

import '../../dataModel/estimate_list_model.dart';

class EstimateAdd extends StatefulWidget {
  @override
  _EstimateAddState createState() => _EstimateAddState();
}

class _EstimateAddState extends State<EstimateAdd> {
  final EstimateData? data = Get.arguments;
  bool estimateUpdated = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController phoneNo = TextEditingController();
  TextEditingController addressController = TextEditingController();
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
  TextEditingController assignedWorkerController = TextEditingController();
  // TextEditingController ppfType = TextEditingController();
  TextEditingController ppfPackage = TextEditingController();
  TextEditingController ppfAmount = TextEditingController(text: "0");
  TextEditingController couponCodeController = TextEditingController();

  clearAllFields() {
    couponCodeController.clear();
    make.clear();
    date.clear();
    phoneNo.clear();
    ppfAmount.clear();
    // ppfType.clear();
    assignedWorkerController.clear();
    ppfPackage.clear();
    name.clear();
    addressController.clear();
    date.clear();
    gstNo.clear();
    email.clear();
    color.clear();
    model.clear();
    vechileNo.clear();
    _intervalValue = "";
    _colorValue = "";
    segment.clear();
    year.clear();
    estDate.clear();
    estTime.clear();
    vin.clear();
  }

  List<SelectServices> selectedServiceList = [];
  var selectedppfServiceList = [];
  var serviceList = [];
  List<String> models = [];
  var modelId;
  int discountForUser = 0;
  var _intervalValue;
  String errorText = "";
  Color errorColor = AppColors.buttonColor;
  List colors = [];
  bool isloadingForApplyButton = false;
  var _colorValue;
  var ppfType;
  // List<bool> isChecked = [];
  List ppfServices = [];

  Map<String, dynamic> selectedResponseServerRes = Map<String, dynamic>();
  List servicesByNameData = [];
  // List<TextEditingController> serviceTypeControllers = [];
  // List<TextEditingController> packageTimeControllers = [];
  // List<TextEditingController> rateControllers = [];
  var totalServiceAmt = 0.0.obs;
  var discountAmt = 0.0.obs;
  var totalTaxebleAmt = 0.0.obs;
  var totalApplicaleTaxAmt = 0.0.obs;
  var totalPayableAmt = 0.0.obs;
  var discountAmount = 0.0.obs;

  @override
  void initState() {
    super.initState();
    estimatedata();

    if (data != null) {
      print('data ====');
      name.text = data?.name ?? '';
      date.text = data?.date ?? '';
      var esti = data?.estimatedDeliveryTime ?? '';
      var splitData = esti.split(' ');
      estDate.text = splitData.first;
      estTime.text = splitData.last;
      phoneNo.text = data?.phone ?? '';
      addressController.text = data?.address ?? '';
      email.text = data?.email ?? '';
      vechileNo.text = data?.vehicleNumber ?? '';
      model.text = data?.modalName ?? '';
      make.text = data?.makeId ?? '';
      year.text = data?.year ?? '';
      color.text = data?.color ?? '';
      vin.text = data?.vin ?? '';
      gstNo.text = data?.gst ?? '';
      segment.text = data?.segment ?? '';
      assignedWorkerController.text = data?.assignedWorker ?? '';
      // selectedServiceList = data?.selectServices ?? [];

      data?.selectServices?.forEach((e) {
        print(e.name);
        return makeServicesFields(e.name, false);
      });

      selectedppfServiceList = data?.ppfServices?.isNotEmpty == true ? data!.ppfServices![0].services ?? [] : [];
      // print(data?.totalServiceAmount);
      // print(data?.totalDiscount);
      // print(data?.totalServiceAmount);
      // print(data?.totalTaxebleAmt);
      // print(data!.totalApplicaleTaxAmt);
      // print(data!.totalPayableAmt);
      print("select Services ${data!.selectServices}");
      print("ppf services ${data!.ppfServices}");

      ppfAmount.text = data?.ppfServices?.isNotEmpty == true ? data!.ppfServices![0].amount ?? 'N/A' : '0';
      ppfType = data?.ppfServices?.isNotEmpty == true ? data!.ppfServices![0].type ?? 'N/A' : '0';
      ppfPackage.text = data?.ppfServices?.isNotEmpty == true ? data!.ppfServices![0].package ?? 'N/A' : '';
      // selectedServiceList.map((e) => maxeServicesFields(e));

      // totalServiceAmt.value = double.parse(data?.totalServicesAmount ?? '0');
      // discountAmount.value = double.parse(data?.totalDiscount != null
      //     ? data!.totalDiscount!.isEmpty
      //         ? "0"
      //         : data!.totalDiscount!
      //     : '0');
      // discountAmt.value = totalServiceAmt.value * (discountAmount.value / 100);
      // totalTaxebleAmt.value = double.parse(data!.totalTaxableAmount ?? '0');
      // totalApplicaleTaxAmt.value = double.parse(data!.totalApplicableTax ?? '0');
      // totalPayableAmt.value = double.parse(data!.totalPayableAmount ?? '0');

      totalServiceAmt.value = double.parse(data?.totalServicesAmount != null && data!.totalServicesAmount!.isNotEmpty ? data!.totalServicesAmount! : '0');
      discountAmount.value = double.parse(data?.totalDiscount != null && data!.totalDiscount!.isNotEmpty ? data!.totalDiscount! : '0');
      discountAmt.value = totalServiceAmt.value * (discountAmount.value / 100);
      totalTaxebleAmt.value = double.parse(data?.totalTaxableAmount != null && data!.totalTaxableAmount!.isNotEmpty ? data!.totalTaxableAmount! : '0');
      totalApplicaleTaxAmt.value = double.parse(data?.totalApplicableTax != null && data!.totalApplicableTax!.isNotEmpty ? data!.totalApplicableTax! : '0');
      totalPayableAmt.value = double.parse(data?.totalPayableAmount != null && data!.totalPayableAmount!.isNotEmpty ? data!.totalPayableAmount! : '0');

      couponCodeController.text = data!.couponCode ?? 'No Offer';
    }
  }

  var ppfserviceRateDataList = [];

  getColors(String selectedModel) async {
    var responseData = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$selectedModel'),
    );
    var model = jsonDecode(responseData.body.toString());

    if (model['status'] != 0) {
      var modelData = model['model'];
      List<String> allColors = List.from(modelData['colors_name']);

      Set<String> uniqueColors = Set.from(allColors);

      colors = uniqueColors.toList();

      if (data != null) {
        _colorValue = data!.color.toString();
      } else {
        _colorValue = colors.first;
      }
    }
    setState(() {});
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

      if (data != null) {
        _intervalValue = data!.modalName ?? 'Swift';
        getColors(data!.modalName ?? 'Swift');
      }

      // models = model['models'];
    } else {
      models = [];
    }

    // if (data != null) {
    //   _intervalValue = data!.modalName ?? 'Swift';
    //   getColors(data!.modalName ?? 'Swift');
    // }

    ApiProvider().getAllServices().then((value) => {
          if (value.status == 1)
            {
              // print(value.services![0].toJson()),
              value.services?.forEach((element) {
                serviceList.add(element.name);
                setState(() {});
              })
            }
          else
            {
              serviceList = [],
            }
        });

    var ppfresponse = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getPPFServices'),
    );
    var ppfdata = jsonDecode(ppfresponse.body.toString());
    if (ppfdata['status'] != 0) {
      List ppservices = ppfdata['services'];
      ppservices.forEach((element) {
        ppfServices.add(element['ppfservice_name']);
      });
      setState(() {});
    } else {
      ppfServices = [];
    }

    var ppfRateResponse = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getPpfServicesRate'),
    );
    var ppfRateData = jsonDecode(ppfRateResponse.body.toString());
    List ppfRateList = ppfRateData["services"];
    ppfserviceRateDataList = ppfRateList;
    setState(() {});
  }

  makeServicesFields(f, todo) async {
    if (selectedServiceList.isEmpty || !selectedServiceList.any((element) => element.name == f)) {
      print('add');
      // if (serviceList.length < 5) {
      //    setState(() {});

      var dataRes = await ApiProvider().getServiceByName(f, segment.text);

      selectedServiceList.add(SelectServices(
          name: dataRes["services"][0]['service_name'],
          type: dataRes["services"][0]['service_type'],
          amount: dataRes["services"][0]['rate'],
          package: dataRes["services"][0]['package_time']));
      // print('data res ---  ${dataRes}');

      servicesByNameData = dataRes["services"];

      List servicesList = dataRes["services"];

      List serviceTypeData = [];
      List packageTimeData = [];

      List rateData = [];
      Map controllerMap = Map();

      servicesList.toSet().forEach((element) {
        TextEditingController a = TextEditingController();
        TextEditingController b = TextEditingController();
        TextEditingController c = TextEditingController();
        if (element["service_type"] != null) {
          a.text = element["service_type"];
          if (controllerMap["service_type"] == null) {
            controllerMap["service_type"] = a;
          }
          if (!serviceTypeData.contains(element["service_type"])) {
            serviceTypeData.add(element["service_type"]);
          }
        }
        if (element["package_time"] != null) {
          b.text = element["package_time"];
          if (controllerMap["package_time"] == null) {
            controllerMap["package_time"] = b;
          }
          if (!packageTimeData.contains(element["package_time"])) {
            packageTimeData.add(element["package_time"]);
          }
        }
        if (element["rate"] != null) {
          c.text = element["rate"];
          if (controllerMap["rate"] == null) {
            controllerMap["rate"] = c;
            if (todo) {
              totalServiceAmt.value = totalServiceAmt.value + double.parse(c.text);
              calculateTotalBill(totalServiceAmt.value);
            }
          }
          if (!rateData.contains(element["rate"])) {
            rateData.add(element["rate"]);
          }
        }
      });
      Map<String, dynamic> dataMap = Map<String, dynamic>();
      dataMap["serviceTypeData"] = serviceTypeData;
      dataMap["packageTimeData"] = packageTimeData;
      dataMap["rateData"] = rateData;
      // dataMap["serviceTypeControllers"] = serviceTypeControllers;
      // dataMap["packageTimeControllers"] = packageTimeControllers;
      // dataMap["rateControllers"] = rateControllers;
      dataMap["controllerMap"] = controllerMap;
      selectedResponseServerRes[f] = dataMap;
      setState(() {});
    } else {
      print('remove');

      selectedServiceList.removeWhere((element) => element.name == f);
      totalServiceAmt.value = totalServiceAmt.value - double.parse(selectedResponseServerRes[f!]["controllerMap"]["rate"].text);
      calculateTotalBill(totalServiceAmt.value);
      selectedResponseServerRes.remove(f);
      setState(() {});
      // print(selectedServiceList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    SizeConfig().init(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 5,
                      ),
                      Text(
                        'Create Estimate',
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 4,
                      ),
                      //1 row
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
                            textFieldForWarranty(
                              context: context,
                              width: width,
                              textEditingController: date,
                              labelText: "Date",
                              readOnly: true,
                              isRightIcon: true,
                              isvalidationTrue: true,
                              rightIcon: Icons.calendar_month,
                              onTap: () {
                                pickFromDateTime(
                                  pickDate: true,
                                  context: context,
                                  controller: date,
                                );
                              },
                              hintext: "Date",
                            ),
                            textFieldForWarranty(
                              context: context,
                              width: width,
                              textEditingController: phoneNo,
                              labelText: "Phone No.",
                              isRightIcon: true,
                              rightIcon: Icons.phone,
                              hintext: "Phone No.",
                              isvalidationTrue: true,
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
                              readOnly: true,
                              isRightIcon: true,
                              isvalidationTrue: true,
                              rightIcon: Icons.calendar_month,
                              onTap: () {
                                pickFromDateTime(
                                  pickDate: true,
                                  context: context,
                                  controller: date,
                                );
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
                              isvalidationTrue: true,
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
                            textFieldForWarranty(
                              context: context,
                              width: width,
                              textEditingController: addressController,
                              labelText: "Address",
                              hintext: "Address",
                            ),
                            textFieldForWarranty(
                              context: context,
                              width: width,
                              textEditingController: email,
                              labelText: "Email",
                              hintext: "Email",
                            ),
                            textFieldForWarranty(
                              context: context,
                              width: width,
                              textEditingController: vechileNo,
                              labelText: "Vechile No.",
                              hintext: "Vechile No.",
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          textFieldForWarranty(
                            context: context,
                            textEditingController: addressController,
                            labelText: "Address",
                            hintext: "Address",
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: email,
                            labelText: "Email",
                            hintext: "Email",
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: vechileNo,
                            labelText: "Vechile No.",
                            hintext: "Vechile No.",
                          ),
                        ])
                      ],

                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 4,
                      ),

                      //3 row
                      if (Responsive.isMobile(context)) ...[
                        Wrap(
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
                                if (selectedServiceList.isNotEmpty) {
                                  data?.selectServices?.forEach((e) {
                                    print(e.name);
                                    return makeServicesFields(e.name, false);
                                  });
                                }
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
                                print('this block work ====');
                                setState(() {
                                    selectedServiceList = [];
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
                              textEditingController: segment,
                              labelText: "Segment",
                              hintext: "Segment",
                              readOnly: true,
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.circular(10),
                            //   ),
                            //   width: MediaQuery.of(context).size.width / 3.5,
                            //   child: DropdownSearch<String>(
                            //     popupProps: PopupProps.menu(
                            //       showSelectedItems: true,
                            //       showSearchBox: true,
                            //       disabledItemFn: (String s) => s.startsWith('I'),
                            //     ),
                            //     items: models,
                            //     dropdownDecoratorProps: DropDownDecoratorProps(
                            //       dropdownSearchDecoration: InputDecoration(
                            //         fillColor: Colors.white, hintText: "Select Model",
                            //         // label: Text('Select Model'),
                            //       ),
                            //     ),
                            //     onChanged: (data) => print(data),
                            //     selectedItem: "Brazil",
                            //   ),
                            // ),
                            CustomSearchableDropdownFormField<String>(
                              width: MediaQuery.of(context).size.width / 3.5,
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
                                print(responseData.body);
                                var model = jsonDecode(responseData.body.toString());
                                print(model);
                                if (model['status'] != 0) {
                                  var data = model['model'];
                                  make = TextEditingController(text: '${data['make_name']}');
                                  segment = TextEditingController(text: '${data['segment_name']}');
                                  colors = data['colors_name'];
                                  _colorValue = colors.first;
                                  modelId = data['id'];
                                }
                                setState(() {
                                  selectedServiceList.clear();
                                  _intervalValue = value!;
                                });
                              },
                            ),
                            // CustomDropdownFormField<String>(
                            //   width: MediaQuery.of(context).size.width / 3.5,
                            //   isMandatory: true,
                            //   labelFontWeight: FontWeight.w500,
                            //   label: 'Select Model',
                            //   hintText: "Select Model",
                            //   value: _intervalValue,
                            //   items: models,
                            //   validator: (value) => validateForNormalFeild(value: value, props: "Select Model"),
                            //   onChanged: (value) async {
                            //     print("Testtt");
                            //     var responseData = await http.post(
                            //       Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$value'),
                            //     );
                            //     print(responseData.body);
                            //     var model = jsonDecode(responseData.body.toString());
                            //     print(model);
                            //     if (model['status'] != 0) {
                            //       var data = model['model'];
                            //       make = TextEditingController(text: '${data['make_name']}');
                            //       segment = TextEditingController(text: '${data['segment_name']}');
                            //       colors = data['colors_name'];
                            //       _colorValue = colors.first;
                            //       modelId = data['id'];
                            //     }
                            //     setState(() {
                            //       _intervalValue = value!;
                            //     });
                            //   },
                            // ),

                            textFieldForWarranty(
                              context: context,
                              textEditingController: make,
                              labelText: "Make",
                              hintext: "Make",
                              readOnly: true,
                            ),
                            textFieldForWarranty(
                              context: context,
                              textEditingController: segment,
                              labelText: "Segment",
                              hintext: "Segment",
                              readOnly: true,
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
                              value: colors.contains(_colorValue)
                                  ? _colorValue
                                  : colors.isNotEmpty
                                      ? colors.first
                                      : null,
                              items: colors,
                              // validator: (value) => validateForNormalFeild(value: value, props: "Color"),
                              onChanged: (value) async {
                                setState(() {
                                  _colorValue = value!;
                                });
                              },
                            ),
                            textFieldForWarranty(
                              width: width,
                              context: context,
                              textEditingController: vin,
                              labelText: "VIN",
                              hintext: "VIN",
                            ),
                            textFieldForWarranty(
                              width: width,
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
                              width: MediaQuery.of(context).size.width / 3.5,
                              labelFontWeight: FontWeight.w500,
                              label: 'Select Color',
                              hintText: "Select Color",
                              value: colors.contains(_colorValue)
                                  ? _colorValue
                                  : colors.isNotEmpty
                                      ? colors.first
                                      : null,
                              items: colors,
                              // validator: (value) => validateForNormalFeild(value: value, props: "Color"),
                              onChanged: (value) async {
                                setState(() {
                                  _colorValue = value!;
                                });
                              },
                            ),
                            textFieldForWarranty(
                              context: context,
                              textEditingController: vin,
                              labelText: "VIN",
                              hintext: "VIN",
                            ),
                            textFieldForWarranty(
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

                      //4 row
                      if (Responsive.isMobile(context)) ...[
                        Wrap(
                          children: [
                            textFieldForWarranty(
                              width: width,
                              context: context,
                              textEditingController: year,
                              labelText: "Year",
                              hintext: "Year",
                              isDigitOnly: true,
                            ),
                            Row(
                              children: [
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width / 2.3 : MediaQuery.of(context).size.width / 7,
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
                                SizedBox(
                                  width: 4,
                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width / 2.3 : MediaQuery.of(context).size.width / 7,
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
                            // textFieldForWarranty(
                            //   width: width,
                            //   context: context,
                            //   textEditingController: AssignedWorkers,
                            //   labelText: "Assigned Workers",
                            //   isRightIcon: true,
                            //   rightIcon: Icons.person,
                            //   hintext: "Assigned Workers",
                            // ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textFieldForWarranty(
                              context: context,
                              textEditingController: year,
                              labelText: "Year",
                              hintext: "Year",
                              isDigitOnly: true,
                            ),
                            // SizedBox(
                            //   width: width / 20,
                            // ),
                            textFieldForWarranty(
                              context: context,
                              textEditingController: estDate,
                              labelText: "Estimated Delivery Date",
                              isRightIcon: true,
                              isvalidationTrue: true,
                              rightIcon: Icons.calendar_month,
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
                              rightIcon: Icons.calendar_month,
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
                      if (selectedServiceList.isNotEmpty) ...[
                        Row(
                          children: [
                            Text(
                              'Selected Services - ',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical! * 2,
                        ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: selectedServiceList.length,
                            itemBuilder: (BuildContext context, int index) {
                              TextEditingController amountController = TextEditingController();
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ${selectedServiceList[index].name} ',
                                      style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        buildServiceFields(
                                          selectedServiceList[index].name,
                                          amountController,
                                          index,
                                        ),
                                        SizedBox(
                                          height: SizeConfig.blockSizeVertical! * 4,
                                        ), // Optional: Add a divider between each set of input fields
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],

                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 5,
                      ),
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
                      serviceList.isEmpty
                          ? Text(
                              'No Service add , please add service to make estimate',
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          : Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runAlignment: WrapAlignment.start,
                              spacing: 10,
                              runSpacing: 10,
                              children: serviceList.map((f) {
                                bool isSele = false;
                                if (selectedServiceList.any((e) => e.name == f)) {
                                  isSele = true;
                                }

                                return CustomInkWell(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: isSele ? Colors.red : Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      ),
                                      child: Text(
                                        capitalizeFirstLetterOfEachWord(f),
                                        style: TextStyle(
                                          color: isSele ? Colors.white : Colors.black,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      // return;
                                      if (segment.text.isEmpty) {
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.error,
                                          title: Text('Please select model first!'),
                                          autoCloseDuration: const Duration(seconds: 5),
                                        );
                                        return;
                                      }
                                      makeServicesFields(f, true);
                                    });
                              }).toList(),
                            ),

                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 8,
                      ),
                      Text(
                        'Partial PPF',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomDropdownFormField<String>(
                              width: MediaQuery.of(context).size.width / 3.5,
                              hintText: "Type",
                              label: "Type",
                              value: ppfType,
                              items: ["Gloss", "Matte", "Black", "Coloured"],
                              onChanged: ((value) {
                                setState(() {
                                  ppfType = value;
                                });
                              })),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: ppfPackage,
                            labelText: "Package",
                            hintext: "Package",
                          ),
                          textFieldForWarranty(
                            context: context,
                            textEditingController: ppfAmount,
                            labelText: "Amount",
                            hintext: "Amount",
                          ),
                        ],
                      ),
                      // : SizedBox.shrink(),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 2,
                      ),
                      serviceList == []
                          ? Text(
                              'No partial ppf add',
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                            )
                          : Wrap(
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.start,
                              runAlignment: WrapAlignment.start,
                              spacing: 10,
                              runSpacing: 10,
                              children: ppfServices.map((f) {
                                bool isSele = false;

                                if (selectedppfServiceList.contains(f)) {
                                  isSele = true;
                                }

                                return GestureDetector(
                                  child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                        // color: isSele ? Colors.red : Colors.white,
                                        // border: Border.all(color: Color(0xFF282f61), width: 2.0),
                                        borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
                                            ),
                                      ),
                                      child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                                          onPressed: () {
                                            var selectedPPFRateData;
                                            ppfserviceRateDataList.forEach((element) {
                                              if (element["ppfservice_id"] == f) {
                                                selectedPPFRateData = element;
                                              }
                                            });
                                            print("selectedPPFRateData $selectedPPFRateData");
                                            print("selectedPPFRateData $selectedppfServiceList");
                                            if (!selectedppfServiceList.contains(f)) {
                                              // if (serviceList.length < 5) {
                                              selectedppfServiceList.add(f);
                                              setState(() {});
                                              ppfAmount.text = (int.parse(ppfAmount.text) +
                                                      ((selectedPPFRateData != null && selectedPPFRateData["rate"] != null) ? int.parse(selectedPPFRateData["rate"]) : 0))
                                                  .toString();
                                              totalServiceAmt.value += int.parse(ppfAmount.text);
                                              calculateTotalBill(totalServiceAmt.value);
                                              setState(() {});
                                              // }
                                            } else {
                                              // ppfAmount.text = (int.parse(ppfAmount.text) -
                                              //         ((selectedPPFRateData != null && selectedPPFRateData["rate"] != null) ? int.parse(selectedPPFRateData["rate"]) : 0))
                                              //     .toString();
                                              // totalServiceAmt.value = totalServiceAmt.value - double.parse(ppfAmount.text);
                                              // calculateTotalBill(totalServiceAmt.value);
                                              // selectedppfServiceList.removeWhere((element) => element == f);
                                              // setState(() {});
                                              selectedppfServiceList.removeWhere((element) => element == f);
                                              setState(() {});
                                              int rateToRemove = int.parse(selectedPPFRateData["rate"] ?? '0');
                                             // ppfAmount.text = (int.parse(ppfAmount.text) - rateToRemove).toString();
                                              totalServiceAmt.value -= rateToRemove;
                                              calculateTotalBill(totalServiceAmt.value);
                                              print(selectedppfServiceList);
                                              // print(selectedppfServiceList);
                                            }
                                          },
                                          icon: Icon(isSele ? Icons.check_box : Icons.check_box_outline_blank_rounded),
                                          label: Text(
                                            capitalizeFirstLetterOfEachWord(f),
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
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 8,
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Total Services Amount ',
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
                                          totalServiceAmt.value.toStringAsFixed(2),
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomContainer(
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textFieldForWarranty(
                                          width: MediaQuery.of(context).size.width / 6,
                                          context: context,
                                          textEditingController: couponCodeController,
                                          hintext: "Coupon Code",
                                          labelText: "Coupon Code",
                                          showLabel: false,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        isloadingForApplyButton
                                            ? CircularProgressIndicator()
                                            : CustomButton(
                                                text: "Apply",
                                                onPressed: () async {
                                                  setState(() {
                                                    isloadingForApplyButton = true;
                                                  });
                                                  Map<String, dynamic> couponCodes = await postRequest(
                                                    url: BaseUrl.getCouponCodeApi,
                                                    headers: ApiHeaders.apiHeader,
                                                    body: {"code": couponCodeController.text},
                                                  );
                                                  if (couponCodes["status"] == '1') {
                                                    discountAmount.value = couponCodes["data"]["discount"];
                                                    calculateTotalBill(totalServiceAmt.value);
                                                    errorText = "${discountAmount.value}% discount applied";
                                                    errorColor = Colors.green;
                                                    isloadingForApplyButton = false;
                                                    setState(() {});
                                                  } else {
                                                    setState(() {
                                                      discountAmount.value = 0;
                                                      discountAmt.value = 0;
                                                      errorColor = Colors.red;
                                                      if (couponCodeController.text.isEmpty) {
                                                        errorText = "Please enter coupon code";
                                                      } else {
                                                        errorText = "This code is not applicable";
                                                      }
                                                      isloadingForApplyButton = false;
                                                    });
                                                  }
                                                },
                                                width: 80,
                                                height: 35,
                                              ),
                                      ],
                                    ),
                                    width: MediaQuery.of(context).size.width / 2.5,
                                    alignment: Alignment.topLeft,
                                  ),
                                  Container(
                                    width: 10,
                                    child: Text(
                                      '- ',
                                      style: GoogleFonts.inter(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Container(
                                        width: MediaQuery.of(context).size.width / 2.5,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${discountAmt.value > 0 ? '-' : ''}${discountAmt.value.abs().toStringAsFixed(2)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              errorText.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        CustomContainer(
                                          AppText(
                                            text: errorText,
                                            textColor: errorColor,
                                            fontsize: 12,
                                          ),
                                          marginTop: 5,
                                          width: MediaQuery.of(context).size.width / 2.5,
                                        ),
                                        SizedBox(),
                                        SizedBox(width: MediaQuery.of(context).size.width / 2.5),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Total Taxable Amount ',
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
                                          totalTaxebleAmt.value.toStringAsFixed(2),
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 2.5,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Total Applicale Tax (18%)',
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
                                          '${totalApplicaleTaxAmt.value > 0 ? '+' : ''}${totalApplicaleTaxAmt.value.abs().toStringAsFixed(2)}',
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                          totalPayableAmt.value.toStringAsFixed(2),
                                          style: GoogleFonts.inter(
                                            fontSize: 22,
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                      Divider(),
                      StatefulBuilder(builder: (context, setstate) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (estimateUpdated)
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: EdgeInsets.all(15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final id = data!.id.toString();
                                    // https: //excelosoft.com/dxapp/public/estimates/116/pdf
                                    html.window.open('https://excelosoft.com/dxapp/public/estimates/$id/pdf', '_blank');
                                    // final id = data!.id;
                                    // html.window.open('https://excelosoft.com/dxapp/public/api/getEstimatesPDF/$id', '_blank');
                                  },
                                  child: Text(
                                    'Print Estimate',
                                    style: kLabelStyle,
                                  )),
                            SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFED2626),
                                  padding: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  // stringify(arr) {
                                  //   return '"{${arr.map((e) => '"$e"').join(', ')}}"';
                                  // }

                                  // print(totalServiceAmt.value);
                                  // print(couponCodeController.text);
                                  // print(discountAmount.value);
                                  // print(totalTaxebleAmt.value);
                                  // print(totalTaxebleAmt.value);
                                  if (_formKey.currentState!.validate()) {
                                    Map estimateData = Map();
                                    estimateData["user_id"] = AppConst.getAccessToken();
                                    estimateData["name"] = name.text;
                                    estimateData["date"] = date.text.toString();
                                    estimateData["email"] = email.text;
                                    estimateData["phone"] = phoneNo.text;
                                    estimateData["address"] = addressController.text;
                                    estimateData["vehicle_number"] = vechileNo.text;
                                    estimateData["model_id"] = modelId ?? data!.modelId;
                                    estimateData["make_id"] = make.text.isNotEmpty ? make.text : "N/A";
                                    estimateData["year"] = year.text;
                                    estimateData["color"] = _colorValue.isNotEmpty ? _colorValue : "N/A";
                                    estimateData["vin"] = vin.text;
                                    estimateData["gst"] = gstNo.text;
                                    estimateData["segment"] = segment.text;
                                    estimateData["estimated_delivery_time"] = estDate.text.toString() + ' ' + estTime.text.toString();
                                    estimateData["assigned_worker"] = assignedWorkerController.text;

                                    // if (data == null) {
                                    var typeArr = [];
                                    var amountArr = [];
                                    var timeArr = [];
                                    selectedResponseServerRes.forEach((key, value) {
                                      if (value["controllerMap"]["service_type"] != null) {
                                        typeArr.add(
                                            value["controllerMap"]["service_type"]?.text.isNotEmpty ? value["controllerMap"]["service_type"].text.toString() : "N/A");
                                      }
                                      if (value["controllerMap"]["package_time"] != null) {
                                        timeArr.add(
                                            value["controllerMap"]["package_time"]?.text.isNotEmpty ? value["controllerMap"]["package_time"].text.toString() : "N/A");
                                      }
                                      if (value["controllerMap"]["rate"] != null) {
                                        amountArr.add(value["controllerMap"]["rate"].text.isNotEmpty ? value["controllerMap"]["rate"].text.toString() : "N/A");
                                      }
                                    });
                                    estimateData["select_services_type"] = ['N/A'];

                                    estimateData["select_services_package"] = timeArr;
                                    estimateData["select_services_amount"] = amountArr;
                                    // } else {
                                    //   estimateData["select_services_type"] = data!.selectServices?.map((e) => e.type ?? 'N/A').toList();
                                    //   estimateData["select_services_package"] = data!.selectServices?.map((e) => e.package.toString()).toList();
                                    //   estimateData["select_services_amount"] = data!.selectServices?.map((e) => e.amount).toList();
                                    // }

                                    estimateData["services_selected"] = selectedServiceList.map((e) => e.name).toList();

                                    estimateData["select_services_name"] = selectedServiceList.map((e) => e.name).toList();

                                    // estimateData["ppf_services_type"] = ppfType.text.isNotEmpty ? ppfType.text : "N/A";
                                    estimateData["ppf_services_type"] = [ppfType != null ? ppfType : "N/A"];
                                    estimateData["ppf_services_package"] = [ppfPackage.text.isNotEmpty ? ppfPackage.text.toString() : "N/A"];
                                    estimateData["ppf_services_amount"] = [ppfAmount.text];
                                    estimateData["ppf_services_name"] = selectedppfServiceList.length > 0 ? ["Partial PPF"] : [];
                                    estimateData["ppf_services_selected"] = selectedppfServiceList.map((e) => e).toList();

                                    estimateData["total_services_amount"] = totalServiceAmt.value;
                                    estimateData["coupon_code"] = couponCodeController.text.toString();
                                    estimateData["total_discount"] = discountAmount.value;
                                    estimateData["total_taxable_amount"] = totalTaxebleAmt.value;
                                    estimateData["total_applicable_tax"] = totalApplicaleTaxAmt.value;
                                    estimateData["total_payable_amount"] = totalPayableAmt.value;

                                    // return;

                                    var storeEstimateRes;
                                    if (data != null) {
                                      print('update ------- ${data!.id}');
                                      estimateData["id"] = data!.id;
                                      storeEstimateRes = await ApiProvider().updateEstimateApi(estimateData, data!.id.toString());
                                      estimateUpdated = true;
                                      setstate(() {});
                                    } else {
                                      print('Store ------ ');
                                      storeEstimateRes = await ApiProvider().storeEstimateApi(estimateData);
                                    }
                                    print('Store ------ $storeEstimateRes');
                                    if (storeEstimateRes['status'] == "1") {
                                      // clearAllFields();
                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        title: Text(storeEstimateRes["message"]),
                                        autoCloseDuration: const Duration(seconds: 5),
                                      );
                                      if (data == null)
                                        Get.toNamed(RoutePath.estimateScreen);
                                    }
                                  }
                                },
                                child: Text(
                                  data != null ? 'Update Estimate' : 'Create Estimate',
                                  style: kLabelStyle,
                                )),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void calculateTotalBill(double totalServiceAmount) {
    //Clear the old data
    discountAmt.value = 0.0;
    totalTaxebleAmt.value = 0.0;
    totalApplicaleTaxAmt.value = 0.0;
    totalPayableAmt.value = 0.0;
    if (discountAmount.value > 0) {
      discountAmt.value = totalServiceAmount * (discountAmount.value / 100);
    }
    totalTaxebleAmt.value = totalServiceAmt.value - discountAmt.value;
    totalApplicaleTaxAmt.value = (totalTaxebleAmt.value * 18) / 100;
    totalPayableAmt.value = totalTaxebleAmt.value + totalApplicaleTaxAmt.value;
  }

  Widget buildServiceFields(String? name, TextEditingController? amountController, int index) {
    // List<String> dropdownItems = [];
    // if (data != null && data!.selectServices != null && data!.selectServices!.isNotEmpty) {
    //   for (final service in data!.selectServices!) {
    //     if (service.package != null) {
    //       dropdownItems.add(service.package!);
    //     }
    //   }
    // }
    // if (data != null) {
    //   print('type =-------${data?.selectServices?[index].type}');
    //   print('typeLisr =-------${data?.selectServices?.map((e) => e.type ?? 'Null').toList()}');

    //   return Row(
    //     mainAxisSize: MainAxisSize.min,
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       // data!.selectServices == null || data!.selectServices!.isEmpty
    //       //     ? Container()
    //       //     : CustomDropdownFormField<String>(
    //       //         width: MediaQuery.of(context).size.width / 3.5,
    //       //         hintText: "Service Type",
    //       //         label: "Type",
    //       //         value: data?.selectServices?[index].type ?? 'Gloss',
    //       //         items: data?.selectServices?.map((e) => e.type ?? 'Gloss').toList() ?? [],
    //       //         onChanged: ((value) {
    //       //           // setState(() {
    //       //           //   data[name]["controllerMap"]["service_type"].text = value!;
    //       //           // });
    //       //         }),
    //       //       ),
    //       SizedBox(
    //         width: 30,
    //       ),
    //       data!.selectServices == null || data!.selectServices!.isEmpty
    //           ? Container()
    //           : CustomDropdownFormField<String>(
    //               width: MediaQuery.of(context).size.width / 3.5,
    //               hintText: "Select Package Time (Year)",
    //               label: "Package",
    //               value: data?.selectServices?[index].package,
    //               items: Set.from(data?.selectServices?.map((e) => e.package ?? '') ?? []).toList(),
    //               // items: dropdownItems,
    //               onChanged: ((value) {
    //                 print('selected rate $servicesByNameData');
    //                 print('selected services $selectedResponseServerRes');
    //                 final index = selectedResponseServerRes[name]["packageTimeData"].indexOf(value);
    //                 selectedResponseServerRes[name]["controllerMap"]["rate"].text = selectedResponseServerRes[name]["rateData"][index];
    //                 selectedResponseServerRes[name]["controllerMap"]["package_time"].text = value!;
    //                 setState(() {});
    //               }),
    //             ),
    //       SizedBox(
    //         width: 30,
    //       ),
    //       data!.selectServices == null || data!.selectServices!.isEmpty
    //           ? Container()
    //           : textFieldForWarranty(
    //               width: MediaQuery.of(context).size.width / 3.5,
    //               context: context,
    //               // textEditingController: amountController ??
    //               //     TextEditingController(
    //               //       text: data?.selectServices?[index].amount,
    //               //     ),
    //               textEditingController: selectedResponseServerRes[name]["controllerMap"]["rate"],
    //               labelText: "Amount",
    //               hintext: "Amount",
    //             ),
    //     ],
    //   );
    // } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (selectedResponseServerRes[name] != null && selectedResponseServerRes[name!]["serviceTypeData"].isNotEmpty)
          CustomDropdownFormField<String>(
            width: MediaQuery.of(context).size.width / 3.5,
            hintText: "Select Service Type'",
            label: "Type",
            value: selectedResponseServerRes[name]["controllerMap"]["service_type"].text,
            items: selectedResponseServerRes[name]["serviceTypeData"],
            onChanged: ((value) {
              setState(() {
                print('selected rate $servicesByNameData');
                final index = selectedResponseServerRes[name]["serviceTypeData"].indexOf(value);
                selectedResponseServerRes[name]["controllerMap"]["rate"].text = selectedResponseServerRes[name]["rateData"][index];
                selectedResponseServerRes[name]["controllerMap"]["service_type"].text = value!;
              });
            }),
          ),
        (selectedResponseServerRes[name] != null && selectedResponseServerRes[name!]["serviceTypeData"].isNotEmpty) ? SizedBox(width: 10) : Container(),
        (selectedResponseServerRes[name] != null && selectedResponseServerRes[name!]["packageTimeData"].isNotEmpty)
            ? CustomDropdownFormField<String>(
                width: MediaQuery.of(context).size.width / 3.5,
                hintText: "Select Package Time (Year)",
                label: "Package",
                value: selectedResponseServerRes[name]["controllerMap"]["package_time"].text,
                items: selectedResponseServerRes[name]["packageTimeData"],
                onChanged: ((value) {
                  setState(() {
                    print(selectedResponseServerRes);
                    final index = selectedResponseServerRes[name]["packageTimeData"].indexOf(value);
                    selectedResponseServerRes[name]["controllerMap"]["rate"].text = selectedResponseServerRes[name]["rateData"][index];
                    selectedResponseServerRes[name]["controllerMap"]["package_time"].text = value!;
                  });
                }),
              )
            : Container(),
        SizedBox(
          width: 30,
        ),
        textFieldForWarranty(
          context: context,
          textEditingController: selectedResponseServerRes[name]["controllerMap"]["rate"],
          labelText: "Amount",
          hintext: "Amount",
        ),
      ],
    );
    // }
  }
}
