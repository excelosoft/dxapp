import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:responsive_dashboard/component/custom/dropdown_field.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/component/sideMenu.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/constants/validation/basic_validation.dart';
import 'package:responsive_dashboard/dataModel/estimate_list_model.dart';

import 'package:responsive_dashboard/utils/loginUtility.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:toastification/toastification.dart';

import '../../Services/Apis.dart';
import '../../component/custom/custom_fields.dart';
import '../../config/responsive.dart';
import '../../functions/date_picker.dart';
import '../../routes/RoutePath.dart';

class BillAdd extends StatefulWidget {
  @override
  State<BillAdd> createState() => _BillAddState();
}

class _BillAddState extends State<BillAdd> {
  final _formKey = GlobalKey<FormState>();
  bool billUpdated = false;

  final EstimateData? data = Get.arguments;
  final isBillEdit = Get.parameters['isEdit'];
  final paramsBarcode = Get.parameters['barcodeNo'];
  final paramsInvoice = Get.parameters['invoiceNo'];


  // var ppfType;

  TextEditingController ppfPackage = TextEditingController();
  TextEditingController ppfType = TextEditingController();
  TextEditingController ppfAmount = TextEditingController(text: "0");
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController phoneNoController = TextEditingController();
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
    //text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController estTime = TextEditingController(
    text: DateFormat('HH:mm').format(DateTime.now()),
  );
  TextEditingController assignedWorkersController = TextEditingController();
  TextEditingController ceramictypeController = TextEditingController();
  TextEditingController ceramicWarrantyController = TextEditingController();
  TextEditingController ppfTypeController = TextEditingController();
  TextEditingController ppfWarrantController = TextEditingController();
  TextEditingController carWashTypeController = TextEditingController();
  TextEditingController cardWashWarrantyController = TextEditingController();
  TextEditingController ceremiCoatingController = TextEditingController();
  TextEditingController ceramicBarcodeController = TextEditingController();
  TextEditingController grapheneBarcodeController = TextEditingController();

  clearAllFields() {
    make.clear();
    dateController.clear();
    phoneNoController.clear();
    ppfAmount.clear();
    ppfType.clear();
    assignedWorkersController.clear();
    ppfPackage.clear();
    nameController.clear();
    addressController.clear();
    dateController.clear();
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

  String invoiceNumber = '';

  var serviceList = [];

  List<String> models = [];

  var _intervalValue = '';

  List colors = [];

  var _colorValue = '';

  var modelId;

  List ppfServices = [];

  String counponCode = '';

  var totalServiceAmt = 0.0.obs;
  var discountAmt = 0.0.obs;
  var totalTaxebleAmt = 0.0.obs;
  var totalApplicaleTaxAmt = 0.0.obs;
  var totalPayableAmt = 0.0.obs;
  var discountAmount = 0.0.obs;

  var ppfserviceRateDataList = [];

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

  getModels() async {
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
        _intervalValue = data?.modalName ?? 'Swift';
        getColors(data?.modalName ?? 'Swift');
      }

      // models = model['models'];
    } else {
      models = [];
    }
  }

  getColors(String selectedModel) async {
    var responseData = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$selectedModel'),
    );
    var model = jsonDecode(responseData.body.toString());

    if (model['status'] != 0) {
      var modelData = model['model'];
      colors = modelData['colors_name'];

      // if (data != null) {
      // //   _colorValue = data!.color!;
      // // } else {
      _colorValue = colors.first;
      // }
    }
    setState(() {});
  }

  getServices() async {
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
  }

  getPPFServices() async {
    var ppfresponse = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getPPFServices'),
    );
    var ppfdata = jsonDecode(ppfresponse.body.toString());
    if (ppfdata['status'] != 0) {
      List ppservices = ppfdata['services'];
      ppservices.forEach((element) {
        ppfServices.add(element['ppfservice_name']);
      });
    } else {
      ppfServices = [];
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchInvoiceList();
    getModels();
    getServices();
    getPPFServices();
    if (data != null) {
      nameController.text = data?.name ?? '';
      dateController.text = data?.date ?? '';
      phoneNoController.text = data?.phone ?? '';
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
      List<String> splitList = data?.estimatedDeliveryTime?.split(' ') ?? [];

      estDate.text=splitList[0];
      estTime.text=splitList[1];

      assignedWorkersController.text = data?.assignedWorker ?? '';
      modelId = data?.modelId;
      // segment.text = data?.segment ?? '';
      // segment.text = data?.segment ?? '';

      // print(data?.totalServiceAmount);
      // print(data?.totalDiscount);
      // print(data?.totalServiceAmount);
      // print(data?.totalTaxebleAmt);
      // print(data!.totalApplicaleTaxAmt);
      // print(data!.totalPayableAmt);
if(data!.selectServices![0].name=='Graphene Coating'){

       grapheneBarcodeController = TextEditingController(text: paramsBarcode);
}else{
  ceramicBarcodeController = TextEditingController(text:paramsBarcode );
}

      ppfAmount.text = data?.ppfServices?.isNotEmpty == true ? data!.ppfServices![0].amount ?? 'N/A' : '0';
      ppfType.text = data?.ppfServices?.isNotEmpty == true ? data!.ppfServices![0].type ?? 'N/A' : '0';
      ppfPackage.text = data?.ppfServices?.isNotEmpty == true ? data!.ppfServices![0].package ?? 'N/A' : '';

      totalServiceAmt.value = double.parse(data?.totalServicesAmount != null && data!.totalServicesAmount!.isNotEmpty ? data!.totalServicesAmount! : '0');
      discountAmt.value = double.parse(data?.totalDiscount != null && data!.totalDiscount!.isNotEmpty ? data!.totalDiscount! : '0');
      //discountAmt.value = totalServiceAmt.value * (discountAmount.value / 100);
      totalTaxebleAmt.value = double.parse(data?.totalTaxableAmount != null && data!.totalTaxableAmount!.isNotEmpty ? data!.totalTaxableAmount! : '0');
      totalApplicaleTaxAmt.value = double.parse(data?.totalApplicableTax != null && data!.totalApplicableTax!.isNotEmpty ? data!.totalApplicableTax! : '0');
      totalPayableAmt.value = double.parse(data?.totalPayableAmount != null && data!.totalPayableAmount!.isNotEmpty ? data!.totalPayableAmount! : '0');
      counponCode = data!.couponCode ?? 'No Offer';

      print(totalServiceAmt.value);
      print(data?.couponCode);
      print(discountAmt.value);
      print(discountAmount.value);
      print(totalTaxebleAmt.value);
      print(totalApplicaleTaxAmt.value);
      print(totalPayableAmt.value);
    }
    super.initState();
  }

  // String generateInvoiceNumber() {
  //   // var random = Random();
  //   // int randomNumber = random.nextInt(99999) + 10000;

  //   // return 'Invoice No. - #DX$randomNumber';
  // }

  fetchInvoiceList() async {
    final res = await ApiProvider().getNewInvoiceNumber();
    invoiceNumber = '#DX$res';
    return res;
  }

  @override
  Widget build(BuildContext context) {
    // var data = Get.arguments as Data1;

    SizeConfig().init(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: SizedBox(width: 100, child: SideMenu()),
      body: Form(
        key: _formKey,
        child: Column(
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
                      Row(
                        children: [
                          Text(
                            'Add Bill',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Invoice No. -  ${paramsInvoice ?? invoiceNumber}',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 4,
                      ),
                      // 1 row
                      if (Responsive.isMobile(context)) ...[
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: nameController,
                              labelText: "Name",
                              hintext: "Your Name",
                            ),
                            textFieldForWarranty(
                              context: context,
                              width: Responsive.isMobile(context) ? width : null,
                              textEditingController: dateController,
                              labelText: "Date",
                              readOnly: true,
                              isRightIcon: true,
                              rightIcon: Icons.calendar_month,
                              onTap: () {
                                showDateDailog(dateController);
                              },
                              hintext: "Date",
                            ),
                            textFieldForWarranty(
                              context: context,
                              width: Responsive.isMobile(context) ? width : null,
                              textEditingController: phoneNoController,
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
                              textEditingController: nameController,
                              labelText: "Name",
                              hintext: "Your Name",
                            ),
                            textFieldForWarranty(
                              context: context,
                              textEditingController: dateController,
                              labelText: "Date",
                              readOnly: true,
                              isRightIcon: true,
                              rightIcon: Icons.calendar_month,
                              onTap: () {
                                showDateDailog(dateController);
                              },
                              hintext: "Date",
                            ),
                            textFieldForWarranty(
                              context: context,
                              textEditingController: phoneNoController,
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

                      //2 row
                      if (Responsive.isMobile(context)) ...[
                        Wrap(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: addressController,
                              labelText: "Address",
                              hintext: "Address",
                            ),
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: email,
                              labelText: "Email",
                              hintext: "Email",
                            ),
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: vechileNo,
                              labelText: "Vechile No.",
                              hintext: "Vechile No.",
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
                              textEditingController: addressController,
                              labelText: "Address",
                              hintext: "Address",
                            ),
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: email,
                              labelText: "Email",
                              hintext: "Email",
                            ),
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: vechileNo,
                              labelText: "Vechile No.",
                              hintext: "Vechile No.",
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
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: make,
                              labelText: "Make",
                              hintext: "Make",
                              readOnly: true,
                            ),
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: year,
                              labelText: "Year",
                              hintext: "Year",
                              isDigitOnly: true,
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
                                  _colorValue = colors.first;
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
                              textEditingController: year,
                              labelText: "Year",
                              hintext: "Year",
                              isDigitOnly: true,
                            ),
                          ],
                        ),
                      ],

                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 4,
                      ),

                      // 4 row
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
                      // 5 row
                      if (Responsive.isMobile(context)) ...[
                        Wrap(
                          children: [
                            textFieldForWarranty(
                              context: context,
                              width: Responsive.isMobile(context) ? width : null,
                              textEditingController: segment,
                              labelText: "Segment",
                              hintext: "Segment",
                              readOnly: true,
                            ),
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: estDate,
                              labelText: "Estimated Delivery Date/Time",
                              isRightIcon: true,
                              readOnly: true,
                              rightIcon: Icons.calendar_month,
                              onTap: () {
                                showDateDailog(estDate);
                              },
                              hintext: "Estimated Delivery Date/Time",
                            ),
                            textFieldForWarranty(
                              width: Responsive.isMobile(context) ? width : null,
                              context: context,
                              textEditingController: assignedWorkersController,
                              labelText: "Assigned Workers",
                              isRightIcon: true,
                              rightIcon: Icons.person,
                              hintext: "Assigned Workers",
                            ),
                            // textFieldForWarranty(
                            //   context: context,
                            //   textEditingController: assignedWorkersController,
                            //   labelText: "HSN NO.",
                            //   isRightIcon: true,
                            //   rightIcon: Icons.person,
                            //   hintext: "",
                            // ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            textFieldForWarranty(
                              context: context,
                              textEditingController: segment,
                              labelText: "Segment",
                              hintext: "Segment",
                              readOnly: true,
                            ),
                            // textFieldForWarranty(
                            //   context: context,
                            //   textEditingController: estDateTime,
                            //   labelText: "Estimated Delivery Date/Time",
                            //   isRightIcon: true,
                            //   readOnly: true,
                            //   rightIcon: Icons.calendar_month,
                            //   onTap: () {
                            //     showDateDailog(estDateTime);
                            //   },
                            //   hintext: "Estimated Delivery Date/Time",
                            // ),
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
                            // textFieldForWarranty(
                            //   context: context,
                            //   textEditingController: assignedWorkersController,
                            //   labelText: "Assigned Workers",
                            //   isRightIcon: true,
                            //   rightIcon: Icons.person,
                            //   hintext: "Assigned Workers",
                            // ),
                          ],
                        ),
                      ],

                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 10,
                      ),

                      //Services
                      if (data != null) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data!.selectServices!.length > 0)
                              Text(
                                'Services - ',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            // SizedBox(
                            //   height: SizeConfig.blockSizeVertical! * 2,
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: data!.selectServices != null ? data!.selectServices!.map((e) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (Responsive.isMobile(context)) ...[
                                                Container(
                                                  constraints: BoxConstraints(minWidth: 200),
                                                  padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                                                  child: Text(
                                                    '${data!.selectServices!.indexOf(e) + 1}. ${e.name}',
                                                    style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 22,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                buildServiceFields(data, data!.selectServices!.indexOf(e)),
                                              ] else ...[
                                                Wrap(
                                                  crossAxisAlignment: WrapCrossAlignment.end,
                                                  children: [
                                                    Container(
                                                      constraints: BoxConstraints(minWidth: 200),
                                                      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                                                      child: Text(
                                                        '${data!.selectServices!.indexOf(e) + 1}. ${e.name}',
                                                        style: GoogleFonts.inter(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 22,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    buildServiceFields(data, data!.selectServices!.indexOf(e)),
                                                  ],
                                                ),
                                              ],
                                              SizedBox(
                                                height: 15,
                                              ),

                                              if (e.name == 'Ceramic Coating' || e.name == 'Graphene Coating') ...[
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    textFieldForWarranty(
                                                      context: context,
                                                      textEditingController: e.name == 'Ceramic Coating' ? ceramicBarcodeController : grapheneBarcodeController,
                                                      labelText: "Scan Barcode or enter manually",
                                                      hintext: "Enter Barcode",
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    if (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS)
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          var res = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => const SimpleBarcodeScannerPage(),
                                                              ));
                                                          setState(() {
                                                            if (res is String) {
                                                              if (e.name == 'Ceramic Coating') {
                                                                // ceramicBarcodeController.text = res;
                                                              } else {
                                                                // grapheneBarcodeController.text = res;
                                                              }
                                                            }
                                                          });
                                                        },
                                                        child: const Text('Open Scanner'),
                                                      )
                                                    // textFieldForWarranty(
                                                    //   context: context,
                                                    //   textEditingController: year,
                                                    //   labelText: "Amount (Excluding GST)",
                                                    //   hintext: "Year",
                                                    // ),
                                                  ],
                                                ),
                                              ]
                                            ],
                                          ),
                                        ),
                                      ).toList()
                                  : [],
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 8,
                            ),
                            if (data!.ppfServices!.isNotEmpty && data!.ppfServices![0].services != null)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (data!.ppfServices!.length > 0)
                                    Text(
                                      'Patial PPF',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical! * 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      textFieldForWarranty(
                                        context: context,
                                        textEditingController: ppfType,
                                        labelText: "Type",
                                        hintext: "Type",
                                        readOnly: true,
                                      ),
                                      textFieldForWarranty(
                                        context: context,
                                        textEditingController: ppfPackage,
                                        labelText: "Package",
                                        hintext: "Package",
                                        readOnly: true,
                                      ),
                                      textFieldForWarranty(
                                        context: context,
                                        textEditingController: ppfAmount,
                                        labelText: "Amount",
                                        hintext: "Amount",
                                        readOnly: true,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical! * 2,
                                  ),
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment: WrapCrossAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: data!.ppfServices!.isNotEmpty && data!.ppfServices![0].services != null
                                        ? data!.ppfServices![0].services!.map((f) {
                                      final selectedppfServiceList = data!.ppfServices![0].services ?? [];
                                      bool isSele = selectedppfServiceList.contains(f);
                                      return GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(color: isSele ? Colors.white : Colors.white,
                                            border: Border.all(color: Color(0xFF282f61), width: 2.0), borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
                                                                 ),
                                          ),
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                            onPressed: isSele
                                                ? null // Disable the button if the item is already selected
                                                : () {
                                              var selectedPPFRateData;
                                              ppfserviceRateDataList.forEach((element) {
                                                if (element["ppfservice_id"] == f) {
                                                  selectedPPFRateData = element;
                                                }
                                              });
                                              print("selectedPPFRateData $selectedPPFRateData");
                                              if (!selectedppfServiceList.contains(f)) {
                                                selectedppfServiceList.add(f);
                                                setState(() {});
                                                ppfAmount.text = (int.parse(ppfAmount.text) +
                                                    ((selectedPPFRateData != null && selectedPPFRateData["rate"] != null)
                                                        ? int.parse(selectedPPFRateData["rate"])
                                                        : 0))
                                                    .toString();
                                                totalServiceAmt.value += int.parse(ppfAmount.text);
                                                calculateTotalBill(totalServiceAmt.value);
                                                setState(() {});
                                                print(selectedppfServiceList);
                                              }
                                            },
                                            icon: isSele ? Icon(Icons.check_box,color: Colors.deepPurple,) : Icon(Icons.check_box_outline_blank_rounded), // Show select icon based on isSele flag
                                            label: Text(
                                              '$f',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: null, // Disable onTap functionality for already selected items
                                      );
                                    }).toList()
                                        : [],
                                  ),
                                  // Wrap(
                                  //   alignment: WrapAlignment.start,
                                  //   crossAxisAlignment: WrapCrossAlignment.start,
                                  //   runAlignment: WrapAlignment.start,
                                  //   spacing: 10,
                                  //   runSpacing: 10,
                                  //   children: data!.ppfServices!.isNotEmpty && data!.ppfServices![0].services != null
                                  //       ? data!.ppfServices![0].services!.map((f) {
                                  //           bool isSele = false;
                                  //           final selectedppfServiceList = data!.ppfServices![0].services ?? [];
                                  //           if (selectedppfServiceList.contains(f)) {
                                  //             isSele = true;
                                  //           }
                                  //           return GestureDetector(
                                  //             child: Container(
                                  //                 padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                                  //                 decoration: BoxDecoration(
                                  //                   // color: isSele ? Colors.red : Colors.white,
                                  //                   // border: Border.all(color: Color(0xFF282f61), width: 2.0),
                                  //                   borderRadius: BorderRadius.all(Radius.circular(20.0) //                 <--- border radius here
                                  //                       ),
                                  //                 ),
                                  //                 child: ElevatedButton.icon(
                                  //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                                  //                     onPressed: () {
                                  //                       var selectedPPFRateData;
                                  //                       ppfserviceRateDataList.forEach((element) {
                                  //                         if (element["ppfservice_id"] == f) {
                                  //                           selectedPPFRateData = element;
                                  //                         }
                                  //                       });
                                  //                       print("selectedPPFRateData $selectedPPFRateData");
                                  //                       if (!selectedppfServiceList.contains(f)) {
                                  //                         // if (serviceList.length < 5) {
                                  //                         selectedppfServiceList.add(f);
                                  //                         setState(() {});
                                  //                         ppfAmount.text = (int.parse(ppfAmount.text) + ((selectedPPFRateData != null && selectedPPFRateData["rate"] != null) ? int.parse(selectedPPFRateData["rate"])
                                  //                                     : 0))
                                  //                             .toString();
                                  //                         totalServiceAmt.value += int.parse(ppfAmount.text);
                                  //                         calculateTotalBill(totalServiceAmt.value);
                                  //                         setState(() {});
                                  //                         print(selectedppfServiceList);
                                  //                         // }
                                  //                       } else {
                                  //                         // ppfAmount.text = (int.parse(ppfAmount.text) -
                                  //                         //         ((selectedPPFRateData != null && selectedPPFRateData["rate"] != null) ? int.parse(selectedPPFRateData["rate"]) : 0))
                                  //                         //     .toString();
                                  //                         // totalServiceAmt.value = totalServiceAmt.value - double.parse(ppfAmount.text);
                                  //                         // calculateTotalBill(totalServiceAmt.value);
                                  //                         // selectedppfServiceList.removeWhere((element) => element == f);
                                  //                         // setState(() {});
                                  //                         selectedppfServiceList.removeWhere((element) => element == f);
                                  //                         setState(() {});
                                  //                         int rateToRemove = int.parse(selectedPPFRateData["rate"] ?? '0');
                                  //                         ppfAmount.text = (int.parse(ppfAmount.text) - rateToRemove).toString();
                                  //                         totalServiceAmt.value -= rateToRemove;
                                  //                         calculateTotalBill(totalServiceAmt.value);
                                  //                         print(selectedppfServiceList);
                                  //                         // print(selectedppfServiceList);
                                  //                       }
                                  //                     },
                                  //                     icon: Icon(isSele ? Icons.check_box : Icons.check_box_outline_blank_rounded),
                                  //                     label: Text(
                                  //                       '$f',
                                  //                       style: TextStyle(
                                  //                         color: Colors.white,
                                  //                         fontSize: 16.0,
                                  //                       ),
                                  //                     ))
                                  //                 // Text('${f}',
                                  //                 //   style: TextStyle(
                                  //                 //     color: Colors.white ,
                                  //                 //     fontSize: 16.0,
                                  //                 //   ),
                                  //                 // ),
                                  //                 ),
                                  //             onTap: () {
                                  //               if (!selectedppfServiceList.contains(f)) {
                                  //                 // if (serviceList.length < 5) {
                                  //                 selectedppfServiceList.add(f);
                                  //                 setState(() {});
                                  //                 print(selectedppfServiceList);
                                  //                 // }
                                  //               } else {
                                  //                 selectedppfServiceList.removeWhere((element) => element == f);
                                  //                 setState(() {});
                                  //                 print(selectedppfServiceList);
                                  //               }
                                  //             },
                                  //           );
                                  //         }).toList()
                                  //       : [],
                                  // ),
                                  if (data!.ppfServices!.length > 0)
                                    SizedBox(
                                      height: 20,
                                    ),
                                ],
                              ),

                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 10,
                            ),
                          ],
                        ),
                      ],
                      // Amount Contianer
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
                                          totalServiceAmt.value.toString(),
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
                                        '$counponCode applied',
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
                                        discountAmt.value.toString(),
                                        style: GoogleFonts.inter(
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
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
                                          totalTaxebleAmt.value.toString().toString(),
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
                                          totalApplicaleTaxAmt.value.toString(),
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
                                          totalPayableAmt.value.toString(),
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
                            if (billUpdated)
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
                                    html.window.open('https://excelosoft.com/dxapp/public/bills/$id/pdf', '_blank');
                                  },
                                  child: Text(
                                    'Print Bill',
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
                                  List<String> PpfServicesType=[];
                                  List<String> PpfAmount=[];
                                  List<String> PpfPackage=[];
                                  PpfAmount.add(ppfAmount.text.isNotEmpty ? ppfAmount.text : "N/A");
                                  PpfPackage.add(ppfPackage.text.isNotEmpty ? ppfPackage.text : "N/A");

                                  PpfServicesType.add(ppfType.text.isNotEmpty?ppfType.text:'N/A');
                                  if (_formKey.currentState!.validate()) {
                                    Map estimateData = Map();
                                    estimateData["name"] = nameController.text.isNotEmpty ? nameController.text : "N/A";
                                    estimateData["date"] = dateController.text.isNotEmpty ? dateController.text : "N/A";
                                    estimateData["email"] = email.text.isNotEmpty ? email.text : "N/A";
                                    estimateData["phone"] = phoneNoController.text.isNotEmpty ? phoneNoController.text : "N/A";
                                    estimateData["address"] = addressController.text.isNotEmpty ? addressController.text : "N/A";
                                    estimateData["vehicle_number"] = vechileNo.text.isNotEmpty ? vechileNo.text : "N/A";
                                    estimateData["model_name"] = model.text;
                                    estimateData["model_id"] = modelId;
                                    estimateData["make_id"] = make.text.isNotEmpty ? make.text : "N/A";
                                    estimateData["year"] = year.text.isNotEmpty ? year.text : "N/A";
                                    estimateData["color"] = _colorValue.isNotEmpty ? _colorValue : "N/A";
                                    estimateData["vin"] = vin.text.isNotEmpty ? vin.text : "N/A ";
                                    estimateData["gst"] = gstNo.text.isNotEmpty ? gstNo.text : "N/A ";
                                    estimateData["segment"] = segment.text.isNotEmpty ? segment.text : "N/A";
                                    estimateData["estimated_delivery_time"] = estDate.text.toString() + ' ' + estTime.text.toString();
                                    estimateData["assigned_worker"] = assignedWorkersController.text.isNotEmpty ? assignedWorkersController.text : "N/A";

                                    estimateData["services_selected"] = data!.selectServices?.map((e) => e.name).toList();
                                    estimateData["select_services_name"] = data!.selectServices?.map((e) => e.name).toList();
                                    estimateData["select_services_amount"] = data!.selectServices?.map((e) => e.amount).toList();
                                    estimateData["select_services_package"] = data!.selectServices?.map((e) => e.package).toList();
                                    estimateData["select_services_type"] = data!.selectServices?.map((e) => e.name).toList();

                                    estimateData["ppf_services_type"] = PpfServicesType;
                                    estimateData["ppf_services_package"] = PpfPackage;
                                    estimateData["ppf_services_amount"] = PpfAmount;
                                    estimateData["ppf_services_name"] = data!.ppfServices?.map((e) => e.name).toList();
                                    estimateData["ppf_services_selected"] = data!.ppfServices?.map((e) => e.name).toList();

                                    print(totalServiceAmt.value);
                                    print(data?.couponCode);
                                    print(discountAmt.value);
                                    print(discountAmount.value);
                                    print(totalTaxebleAmt.value);
                                    print(totalApplicaleTaxAmt.value);
                                    print(totalPayableAmt.value);
                                    estimateData["total_services_amount"] = totalServiceAmt.value;
                                    estimateData["coupon_code"] = data?.couponCode;
                                    estimateData["total_discount"] = discountAmt.value;
                                    estimateData["total_taxable_amount"] = totalTaxebleAmt.value;
                                    estimateData["total_applicable_tax"] = totalApplicaleTaxAmt.value;
                                    estimateData["total_payable_amount"] = totalPayableAmt.value;

                                    if (isBillEdit == null && data!.selectServices != null && data!.selectServices!.isNotEmpty && data!.selectServices!.any((element) => element.name == 'Ceramic Coating') || data!.selectServices!.any((element) => element.name == 'Graphene Coating')) {
                                      final list = await ApiProvider().fetchBarcodeList();
                                      if (list.contains(ceramicBarcodeController.text) || list.contains(grapheneBarcodeController.text) ) {
                                        if (ceramicBarcodeController.text.isNotEmpty) {
                                          estimateData["service_barcode"] = ceramicBarcodeController.text;
                                        } else {
                                          estimateData["service_barcode"] = grapheneBarcodeController.text;
                                        }
                                        estimateData["qty"] = '0';
                                        billUpdated = true;
                                      } else {
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.warning,
                                          title: Text('Your Barcode does not exist in inventory!'),
                                          autoCloseDuration: const Duration(seconds: 5),
                                        );
                                        return;
                                      }
                                    }

                                    var storeEstimateRes = await ApiProvider().convertToBill(
                                      estimateData,
                                      data!.id.toString(),
                                    );

                                    if (storeEstimateRes['status'] == "1") {
                                      if (isBillEdit == null) {
                                        clearAllFields();
                                      } else {
                                        billUpdated = true;
                                        setstate(() {});
                                      }

                                      ApiProvider().storeInvoiceNumber(invoiceNumber, data!.id.toString());

                                      toastification.show(
                                        context: context,
                                        type: ToastificationType.success,
                                        title: Text(storeEstimateRes["message"]),
                                        autoCloseDuration: const Duration(seconds: 5),
                                      );
                                      if (isBillEdit == null) Get.toNamed(RoutePath.billScreen);
                                    }
                                  }
                                },
                                child: Text(
                                  isBillEdit != null ? 'Update Bill' : 'Generate Bill',
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

  Widget buildServiceFields(
    EstimateData? selectedResponseServerRes,
    int index,
  ) {
    if (selectedResponseServerRes != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // selectedResponseServerRes!.selectServices == null || data!.selectServices!.isEmpty
          //     ? Container()
          //     : CustomDropdownFormField<String>(
          //         width: MediaQuery.of(context).size.width / 3.5,
          //         hintText: "Service Type",
          //         label: "Type",
          //         value: data?.selectServices?[index].type ?? 'Gloss',
          //         items: Set.from(data?.selectServices?.map((e) => e.type ?? 'Gloss').toList() ?? []).toList(),
          //         onChanged: ((value) {
          //           // setState(() {
          //           //   data[name]["controllerMap"]["service_type"].text = value!;
          //           // });
          //         }),
          //       ),
          SizedBox(
            width: 30,
          ),
          selectedResponseServerRes.selectServices == null || selectedResponseServerRes.selectServices!.isEmpty
              ? Container()
              : CustomDropdownFormField<String>(
            readOnly: true,
                  width: MediaQuery.of(context).size.width / 3.5,
                  hintText: "Select Package Time (Year)",
                  label: "Package",
                  value: selectedResponseServerRes.selectServices?[index].package ?? "",
                  items: Set.from(data?.selectServices?.map((e) => e.package ?? '') ?? []).toList(),
                  // items: dropdownItems,
                  onChanged: ((value) {}),
                ),
          SizedBox(
            width: 30,
          ),
          selectedResponseServerRes.selectServices == null || selectedResponseServerRes.selectServices!.isEmpty
              ? Container()
              : CustomDropdownFormField<String>(
            readOnly: true,
                  width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width / 3.5,
                  hintText: "Rate",
                  label: "Amount",
                  value: selectedResponseServerRes.selectServices?[index].amount ?? '',
                  items: Set.from(data?.selectServices?.map((e) => e.amount ?? '') ?? []).toList(),
                  onChanged: ((value) {}),
                ),
        ],
      );

      // return Row(
      //   mainAxisSize: MainAxisSize.min,
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     if (selectedResponseServerRes.selectServices != null && selectedResponseServerRes.selectServicesType!.isNotEmpty) ...[
      //       CustomDropdownFormField<String>(
      //         width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width / 3.5,
      //         hintText: "Service Type",
      //         label: "Type",
      //         value: selectedResponseServerRes.selectServicesType,
      //         items: [selectedResponseServerRes.selectServicesType],
      //         onChanged: ((value) {
      //           // setState(() {
      //           //   selectedResponseServerRes[name]["controllerMap"]["service_type"].text = value!;
      //           // });
      //         }),
      //       ),
      //       SizedBox(
      //         width: 30,
      //       ),
      //     ],
      //     selectedResponseServerRes.selectServicesPackage == null || selectedResponseServerRes.selectServicesPackage!.isEmpty
      //         ? Container()
      //         : CustomDropdownFormField<String>(
      //             width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width / 3.5,
      //             hintText: "Select Package Time (Year)",
      //             label: "Package",
      //             value: selectedResponseServerRes.selectServicesPackage,
      //             items: [selectedResponseServerRes.selectServicesPackage],
      //             onChanged: ((value) {}),
      //           ),
      //     SizedBox(
      //       width: 30,
      //     ),
      //     selectedResponseServerRes.selectServicesAmount == null || selectedResponseServerRes.selectServicesAmount!.isEmpty
      //         ? Container()
      //         : CustomDropdownFormField<String>(
      //             width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width / 2.5 : MediaQuery.of(context).size.width / 3.5,
      //             hintText: "Rate",
      //             label: "Amount",
      //             value: selectedResponseServerRes.selectServicesAmount,
      //             items: [selectedResponseServerRes.selectServicesAmount],
      //             onChanged: ((value) {}),
      //           ),
      //   ],
      // );
    }
    return Container();
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
}
