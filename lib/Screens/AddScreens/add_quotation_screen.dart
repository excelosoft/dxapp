import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/component/custom/dropdown_field.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/component/sideMenu.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/constants/utils/text_utility.dart';
import 'package:responsive_dashboard/constants/validation/basic_validation.dart';
import 'package:responsive_dashboard/dataModel/quatation_model.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_html/html.dart';

import '../../config/responsive.dart';

class AddQuick extends StatefulWidget {
  @override
  State<AddQuick> createState() => _AddQuickState();
}

class _AddQuickState extends State<AddQuick> {

  final QuotationData? existingQuatation = Get.arguments;

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();


  final _formKey = GlobalKey<FormState>();
  TextEditingController vehicleNo = TextEditingController();
  // TextEditingController model = TextEditingController();
  TextEditingController make = TextEditingController();
  TextEditingController date = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController phoneNo = TextEditingController();
  TextEditingController deliveryDate = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  TextEditingController advance = TextEditingController(text: "0");
  TextEditingController segment = TextEditingController();
  TextEditingController nameController=TextEditingController();
  bool isEdit = false;
  var selectedServiceList = [];
  var selectedppfServiceList = [];
  List<String> serviceList = [];
  List selectedService = [];
  List selectedService1 = [];
  List<String> models = [];
  List<String> checkvalue = [];
  var _intervalValue = 'Select Model';
  var _selectedService = "Services";

  List selectService1=[];

  List colors = [];

  // List<bool> isChecked = [];

  List ppfServices = [];

  @override
  void dispose() {
    vehicleNo.dispose();
    make.dispose();
    date.dispose();
    phoneNo.dispose();
    deliveryDate.dispose();
    advance.dispose();
    segment.dispose();
    super.dispose();
  }

  clearAllFields() {
    vehicleNo.clear();
    make.clear();
    date.clear();
    phoneNo.clear();
    deliveryDate.clear();
    advance.clear();
    _intervalValue = "";
    segment.clear();
  }

  @override
  void initState() {
    super.initState();
    isEdit = existingQuatation != null ? true : false;
    if (isEdit) {
      date.text = existingQuatation?.date ?? '';
      phoneNo.text = existingQuatation?.mobile.toString() ?? "";
      make.text = existingQuatation?.makeId ?? '';
      segment.text = existingQuatation?.segment ?? '';
      date.text = existingQuatation?.date ?? '';
      nameController.text=existingQuatation?.name ??'';
      vehicleNo.text = existingQuatation?.vehicleNumber ?? '';
      deliveryDate.text = existingQuatation?.deliveryDate ?? '';
      advance.text = existingQuatation?.advance ?? '';

      selectedService1 = existingQuatation!.services ?? [];
      checkvalue = selectedService1.map((service) => service.toString()).toList();

      initStateFunction();

    }
    estimatedata();
  }

     initStateFunction() async {
      for (var item in selectedService1) {
        var dataRes = await ApiProvider().getServiceByName(item.toString(), segment.text);
        if (dataRes['status'] == 1) {
          // Check if the service is already present in selectedService
          bool serviceExists = selectedService.any((element) => element[0]['id'] == dataRes['services'][0]['id']);
          if (!serviceExists) {
            // Add the service to selectedService
            selectedService.add(dataRes['services']);
setState(() {

});

          }
        }
      }
    }

  var ppfserviceRateDataList = [];
  var ppfType;


  estimatedata() async {

    var ppfRateResponse = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getPpfServicesRate'),
    );
    var ppfRateData = jsonDecode(ppfRateResponse.body.toString());
    List ppfRateList = ppfRateData["services"];
    ppfserviceRateDataList = ppfRateList;



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
      if (isEdit) {
        print("modal name ${existingQuatation?.model}");
        _intervalValue = existingQuatation?.model ?? 'Swift';
      }
    } else {
      models = [];
    }
    print('models=======');
    print(models);

    var response = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getServices'),
    );
    print(response.body);
    var data = jsonDecode(response.body.toString());
    print(data);

    if (data != null && data['status'] != 0) {
      if (data.containsKey('services') && data['services'] != null && data['services'] is List) {
        List services = data['services'];
        services.forEach((element) {
          serviceList.add(element['name']);
        });

        if (isEdit) {
          _selectedService = existingQuatation?.services?.join(", ") ?? "";
          var dataRes = await ApiProvider().getServiceByName(_selectedService, segment.text);
          //selectedService.add(dataRes["services"]);

        }
      } else {
        print('Error: "services" key is missing or invalid');
        serviceList = [];
      }
    } else {
      print('Error: ${data != null ? data['message'] : 'Invalid response'}');
      serviceList = [];
    }
    // if (data['status'] != 0) {
    //   List services = data['services'];
    //   services.forEach((element) {
    //     serviceList.add(element['name']);
    //   });
    //   if (isEdit) {
    //     _selectedService = existingQuatation?.services ?? "";
    //     var dataRes = await ApiProvider().getServiceByName(_selectedService, segment.text);
    //     selectedService = dataRes["services"];
    //     setState(() {
    //
    //     });
    //     // selectedService.add(.services ?? "";
    //   }
    // } else {
    //   serviceList = [];
    // }
    print('serviceList=======');
    print(serviceList);

    var ppfresponse = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getPPFServices'),
    );
    print(ppfresponse.body);
    var ppfdata = jsonDecode(ppfresponse.body.toString());
    print(ppfdata);
    if (ppfdata['status'] != 0) {
      List ppservices = ppfdata['services'];
      ppfServices = ppservices;
      // ppservices.forEach((element) {
      //   // Ensure element is correctly structured and add to ppfServices
      //   ppfServices.add({
      //     'ppfservice_name': element['ppfservice_name'],
      //     'id': element['id'],
      //   });
      // });
    } else {
      ppfServices = [];
    }
    print('serviceList=======');
    print(ppfServices);
    setState(() {});
  }



  // getColors(String selectedModel) async {
  //   var responseData = await http.post(
  //     Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$selectedModel'),
  //   );
  //   var model = jsonDecode(responseData.body.toString());

  //   if (model['status'] != 0) {
  //     var modelData = model['model'];
  //     colors = modelData['colors_name'];

  //     // print('getcolor , ${colors}');

  //     if (data != null) {
  //       _colorValue = data!.color.toString();
  //     } else {
  //       _colorValue = colors.first;
  //     }
  //   }
  //   setState(() {});
  // }

  void showDateDailog(TextEditingController controller) {
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
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        controller.text = formatter.format(pickedDate);
      },
    );
  }

  String getRate(String id, String serviceType,String segment) {
    for (var rate in ppfserviceRateDataList) {
      if (rate['ppfservice_id'] == id && rate['service_type'] == serviceType && rate['segment_name']==segment) {
        return rate['rate'].toString();
      }
    }
    return 'Not available';
  }

  @override
  Widget build(BuildContext context) {

    final double itemHeight = 320.0; // Estimated height of each item
    final double containerHeight = selectedService.length * itemHeight;
    SizeConfig().init(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _drawerKey,
      drawer: SizedBox(width: 100, child: SideMenu()),
      body: Form(
          key: _formKey,
          child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 5,
                          ),
                          Row(
                            children: [
                              Text(
                                'Quick Quation',
                                style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          if (Responsive.isMobile(context)) ...[
                            Wrap(
                              children: [
                                Container(
                                  margin: Responsive.isMobile(context) ? EdgeInsets.symmetric(vertical: 10) : null,
                                  child: CustomSearchableDropdownFormField<String>(
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
                                ),

                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: nameController,
                                  labelText: "Name",
                                  hintext: "Name",
                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: make,
                                  labelText: "Make",
                                  hintext: "Make",
                                  readOnly: true,
                                ),


                              ],
                            ),
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: Responsive.isMobile(context) ? EdgeInsets.symmetric(vertical: 10) : null,
                                  child: Consumer<QuotationListValue>(
  builder: (context, provider, child) {
  return CustomSearchableDropdownFormField<String>(
                                    width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                    isMandatory: true,
                                    labelFontWeight: FontWeight.w500,
                                    label: 'Select Model',
                                    hintText: "Select Model",
                                    value: _intervalValue,
                                    items: models,
                                    validator: (value) => validateForNormalFeild(value: value, props: "Select Model"),
                                    onChanged: (value) async {


                                      selectedService.clear();
                                      Provider.of<QuotationListValue>(context, listen: false).resetData();

                                      try {
                                        var response = await http.post(
                                          Uri.parse('https://excelosoft.com/dxapp/public/api/getModelByModalName/$value'),
                                        );

                                        if (response.statusCode == 200) {
                                          print(response.body);
                                          var model = jsonDecode(response.body.toString());
                                          print(model);

                                          if (model['status'] != 0) {
                                            var data = model['model'];
                                            make = TextEditingController(text: '${data['make_name']}');
                                            segment = TextEditingController(text: '${data['segment_name']}');
                                            colors = data['colors_name'];
                                            // _colorValue = colors.first;
                                            // modelId = data['id'];
                                          } else {

                                            toastification.show(
                                              context: context,
                                              type: ToastificationType.error,
                                              title: Text('${model['message']}'),
                                              autoCloseDuration: const Duration(seconds: 5),
                                            );

                                            // Handle the error based on your application's requirement
                                          }
                                        } else {
                                          print('Error: HTTP request failed with status ${response.statusCode}');
                                          // Handle the error based on your application's requirement
                                        }
                                      } catch (e) {
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.error,
                                          title: Text('Data Not Found'),
                                          autoCloseDuration: const Duration(seconds: 5),
                                        );

                                        // Handle the error based on your application's requirement
                                      }
                                      setState(() {
                                        _intervalValue = value!;

                                      });
                                    },
                                  );
  },
),
                                ),

                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: nameController,
                                  labelText: "Name",
                                  hintext: "Name",

                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: make,
                                  labelText: "Make",
                                  hintext: "Make",
                                  readOnly: true,
                                ),

                              ],
                            ),
                          ],
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 2,
                          ),
                          if (Responsive.isMobile(context)) ...[
                            Wrap(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  textEditingController: phoneNo,
                                  labelText: "Mobile No.",
                                  isRightIcon: true,
                                  rightIcon: Icons.phone,
                                  hintext: "Mobile No.",
                                  isDigitOnly: true,
                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: deliveryDate,
                                  labelText: "Delivery Date",
                                  isRightIcon: true,
                                  readOnly: true,
                                  rightIcon: Icons.calendar_month,
                                  onTap: () {
                                    showDateDailog(deliveryDate);
                                  },
                                  hintext: "Delivery Date",
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
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: phoneNo,
                                  labelText: "Mobile No.",
                                  isRightIcon: true,
                                  rightIcon: Icons.phone,
                                  hintext: "Mobile No.",
                                  isDigitOnly: true,
                                ),
                                textFieldForWarranty(
                                  width: Responsive.isMobile(context) ? width : null,
                                  context: context,
                                  textEditingController: deliveryDate,
                                  labelText: "Delivery Date",
                                  isRightIcon: true,
                                  readOnly: true,
                                  rightIcon: Icons.calendar_month,
                                  onTap: () {
                                    showDateDailog(deliveryDate);
                                  },
                                  hintext: "Delivery Date",
                                ),
                              ],
                            ),
                          ],
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 2,
                          ),
                          if (Responsive.isMobile(context)) ...[
                            Wrap(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                  textEditingController: vehicleNo,
                                  labelText: "Vehicle No.",
                                  hintext: "Vehicle No.",
                                ),
                                Container(
                                  margin: Responsive.isMobile(context) ? EdgeInsets.symmetric(vertical: 10) : null,
                                  child: CustomSearchableDropdownFormField<String>(
                                    width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                    isMandatory: true,
                                    labelFontWeight: FontWeight.w500,
                                    label: 'Services',
                                    hintText: "Select services",
                                    value: _selectedService,
                                    items: serviceList,
                                    validator: (value) => validateForNormalFeild(value: value, props: "Select services"),
                                    onChanged: (value) async {
                                      setState(() {
                                        _selectedService = value!;
                                      });
                                      var dataRes = await ApiProvider().getServiceByName(value.toString(), segment.text);
                                      selectedService = dataRes["services"];
                                      setState(() {
                                        _selectedService = value!;
                                      });
                                    },
                                  ),
                                ),
                                // textFieldForWarranty(
                                //   width: Responsive.isMobile(context) ? width : null,
                                //   context: context,
                                //   textEditingController: advance,
                                //   labelText: "Advance",
                                //   hintext: "Advance",
                                //   isDigitOnly: true,
                                // ),
                              ],
                            ),
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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
                                  textEditingController: vehicleNo,
                                  labelText: "Vehicle No.",
                                  hintext: "Vehicle No.",
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Select Services',style: GoogleFonts.inter(fontSize: 16, color: Colors.white),),
                                    CustomMultiSearchableDropdownFormField<String>(
                                      


                                      width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                      isMandatory: true,
                                      initValue: checkvalue,
                                      labelFontWeight: FontWeight.w500,
                                      label: 'Services',
                                      hintText: "Select Services",
                                      value: _selectedService,
                                      items: serviceList,
                                      validator: (value) => validateForNormalFeild(value: value, props: "Select services"),
                                      onChanged: (value) async {
                                        if (segment.text.isEmpty) {
                                          toastification.show(
                                            context: context,
                                            type: ToastificationType.error,
                                            title: Text('Please select model first!'),
                                            autoCloseDuration: const Duration(seconds: 5),
                                          );
                                          return;
                                        }
                                        selectedService.clear();




                                        //// var dataRes = await ApiProvider().getServiceByName(value[0].toString(), segment.text);
                                        for (var item in value) {
                                          var dataRes = await ApiProvider().getServiceByName(item.toString(), segment.text);

                                          if (dataRes['status'] == 1) {
                                            // Check if the service is already present in selectedService
                                            bool serviceExists = selectedService.any((element) => element[0]['id'] == dataRes['services'][0]['id']);

                                            if (!serviceExists) {
                                              // Add the service to selectedService
                                              selectedService.add(dataRes['services']);
                                            }
                                          } else {
                                            // Print the message and show a toast notification
                                            print(dataRes);  // You can remove this if not needed
                                            toastification.show(
                                              context: context,
                                              type: ToastificationType.error,
                                              title: Text(dataRes['message'].toString()),
                                              autoCloseDuration: const Duration(seconds: 5),
                                            );
                                          }
                                        }

                                        // selectedService = dataRes["services"];
                                        setState(() {
                                         // _selectedService = value[0] ?? '';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                // textFieldForWarranty(
                                //   width: Responsive.isMobile(context) ? width : null,
                                //   context: context,
                                //   textEditingController: advance,
                                //   labelText: "Advance",
                                //   hintext: "Advance",
                                //   isDigitOnly: true,
                                // ),
                              ],
                            ),
                          ],


                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),

                          if (selectedService.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: selectedService.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                  child: Column(
                                    children: [
                                      CustomContainer(
                                        AppText(
                                          text: selectedService[index][0]["service_name"] ?? 'N/A',
                                        ),
                                        alignment: Alignment.center,
                                        boxDecoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                        paddingTop: 10,
                                        paddingBottom: 30,
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width / 1.5,
                                            child: DataTable(
                                              border: TableBorder.all(color: Colors.white),
                                              columns: [
                                                DataColumn(label: AppText(text: 'Package')),
                                                DataColumn(label: AppText(text: 'Price')),
                                              ],
                                              rows: List<DataRow>.generate(
                                                selectedService[index].length,
                                                    (i) => DataRow(
                                                  cells: [
                                                    DataCell(AppText(
                                                      text: selectedService[index][i]["package_time"] ?? 'N/A',
                                                    )),
                                                    DataCell(AppText(
                                                      text: selectedService[index][i]["rate"] ?? 'N/A',
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Coverage:',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  DottedPointList(
                                                    points: selectedService[index].isNotEmpty &&
                                                        selectedService[index][0]["Coverage"] != null
                                                        ? selectedService[index][0]["Coverage"].split(',')
                                                        : [],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          if ( _intervalValue != 'Select Model')
                            SizedBox(
                              height: itemHeight+400,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  var service = ppfServices[index];



                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                    child: Column(
                                      children: [
                                        CustomContainer(
                                          AppText(
                                            text: 'PPF Services',
                                          ),
                                          alignment: Alignment.center,
                                          boxDecoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                          paddingTop: 10,
                                          paddingBottom: 30,
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: DataTable(
                                            border: TableBorder.all(color: Colors.white),
                                            columns: [
                                              DataColumn(label: AppText(text: 'Service Name')),
                                              DataColumn(label: AppText(text: 'Gloss')),
                                              DataColumn(label: AppText(text: 'Matte')),
                                              DataColumn(label: AppText(text: 'Black')),
                                              DataColumn(label: AppText(text: 'Coloured')),
                                            ],
                                            rows: ppfServices.map((service) {
                                              String serviceName = service["ppfservice_name"]?.toString() ?? 'Unknown';
                                              String serviceId = service['ppfservice_name'].toString();

                                              String glossRate = getRate(serviceId, 'gloss', segment.text);
                                              String matteRate = getRate(serviceId, 'matte', segment.text);
                                              String blackRate = getRate(serviceId, 'black', segment.text);
                                              String colouredRate = getRate(serviceId, 'coloured', segment.text);
                                              return DataRow(
                                                cells: [
                                                  DataCell(AppText(text: serviceName)),
                                                  DataCell(AppText(text: glossRate)),
                                                  DataCell(AppText(text: matteRate)),
                                                  DataCell(AppText(text: blackRate)),
                                                  DataCell(AppText(text: colouredRate)),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                          SizedBox(
                            height: SizeConfig.blockSizeVertical! * 4,
                          ),
                          CustomContainer(
                            CustomButton(
                              text: isEdit ? "Update Quick Quation" : "Create Quick Quation",
                              onPressed: () async {
                                // print(vehicleNo.text);
                                // print(_intervalValue);
                                // print(date.text);
                                // print(phoneNo.text);
                                // print(deliveryDate.text);
                                // print(advance.text);
                                // print(segment.text);
                                // print(_selectedService);
                                // return;

                                if (_formKey.currentState!.validate()) {
                                  List<String> serviceNames = [];

// Iterate through each list in selectedService
                                  Set<String> uniqueServiceNames = {};

// Iterate through each list in selectedService
                                  for (var list in selectedService) {
                                    // Iterate through each map inside the current list
                                    for (var map in list) {
                                      // Extract the "service_name" from the current map and add it to the uniqueServiceNames set
                                      uniqueServiceNames.add(map["service_name"].toString());
                                    }
                                  }
                                  Random random = Random();
                                  int randomNumber = random.nextInt(100) + 1;
                                  Map quickQuat = Map();
                                  quickQuat["id"] = isEdit ? existingQuatation?.id : randomNumber;
                                  quickQuat["vehicle_number"] = vehicleNo.text;
                                  quickQuat["date"] = date.text;
                                  quickQuat["model"] = _intervalValue;
                                  quickQuat["make_id"] = make.text;
                                  quickQuat["mobile"] = phoneNo.text;
                                  quickQuat["delivery_date"] = deliveryDate.text;
                                  quickQuat["advance"] = advance.text;
                                  quickQuat["segment"] = segment.text;
                                  quickQuat['name']=nameController.text;
                                  quickQuat["services"] =uniqueServiceNames.toList();
                                  print(quickQuat);
                                  var storeEstimateRes;
                                  if (isEdit) {
                                    storeEstimateRes = await ApiProvider().updateQuickQuationApi(quickQuat);
                                  } else {
                                    storeEstimateRes = await ApiProvider().storeQuickQuationApi(quickQuat);
                                  }
                                  print('storeEstimateRes');
                                  if (storeEstimateRes['status'] == "1") {
                                    clearAllFields();
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.success,
                                      title: Text(storeEstimateRes["message"]),
                                      autoCloseDuration: const Duration(seconds: 5),
                                    );
                                    Get.toNamed(RoutePath.quickScreen);
                                  } else {
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.error,
                                      title: Text("Something went wrong"),
                                      autoCloseDuration: const Duration(seconds: 5),
                                    );
                                  }
                                }
                                // }
                              },
                              width: 183,
                              height: 35,
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ])),
    );
  }
}

class DottedPointList extends StatelessWidget {
  final List<String> points;

  const DottedPointList({Key? key, required this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: points
          .map(
            (point) => Text(
              '• $point\n',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
          .toList(),
    );
  }
}
