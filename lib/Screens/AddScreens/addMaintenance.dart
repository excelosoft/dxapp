import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

class AddMaintenance2 extends StatefulWidget {
  final WarrantyCardData maintenanceData;

  const AddMaintenance2({Key? key, required this.maintenanceData}) : super(key: key);
  @override
  State<AddMaintenance2> createState() => _AddMaintenance2State();
}

class _AddMaintenance2State extends State<AddMaintenance2> {


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
  TextEditingController chargeController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<WarrantyCardData> searchResult = [];

//


  String? email;
  String? address;

  String? vin;
  String? gst;

  String? assignedWorker;
  List<SelectService>? selectServices;
  List<PpfService>? ppfServices;

  String? charges;


  String? intialvalue;








  List<String> models = [];
  List<DateTime> serviceDates = [];
  List<String> doneDates = [];
  var modelId;
  String selectedServiceForMaintenance = '';
  String estimatedDeliveryTime ='';


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
    addDataInit();
    fetchInvoiceList();
    estimatedata();

    var dateFormatter = DateFormat('yyyy-MM-dd'); // Import 'package:intl/intl.dart';

    // Get current date
    var currentDate = DateTime.now();

    // Format current date
    var formattedDate = dateFormatter.format(currentDate);

    // Set maintanenceDateController's text to the formatted current date
    maintanenceDateController.text = formattedDate;
  }

  fetchInvoiceList() async {
    final res = await ApiProvider().getNewInvoiceNumber();
    invoiceNumber = '#DX$res';
    return res;
  }

  addDataInit(){

    final res = widget.maintenanceData;
    print(res);
    name.text = res.name ?? '';
    date.text = res.date ?? '';
    phoneNo.text = res.phone ?? '';
    model.text = res.modalName ?? '';
    make.text = res.makeId ?? '';
    vechileNo.text = res.vehicleNumber ?? '';
    color.text = res.color ?? '';
    year.text = res.year ?? '';
    email=res.email??'';
    estimatedDeliveryTime=res.estimatedDeliveryTime?? '';
    segment.text=res.segment??'';
    address=res.address??'';
    vin=res.vin??'';
    gst=res.gst??'';
    assignedWorker=res.assignedWorker??'';
    selectServices=res.selectServices??[];
    ppfServices=res.ppfServices??[];
    chargeController.text = (res.charges != '' && res.charges.toString().isNotEmpty)
        ? res.charges.toString()
        : '1500';





    if (res.dueDate != null) {
    for (String dateString in res.dueDate!) {
    DateTime? date = DateTime.tryParse(dateString);
    if (date != null) {
    serviceDates.add(date);
    }
    }
    }

    if (res.doneDate != null) {
    for (String dateString in res.doneDate!) {
    doneDates.add(dateString);
    }
    }
    //doneDates.add(maintanenceDateController.text.toString());
    if (res.ppfServices != null && res.ppfServices!.isNotEmpty) {
    ceramicCoatingPackageController.text = res.ppfServices![0].package ?? '';
    }

    selectMaintenenceController.text = res.maintenanceNumber.toString();
    numberOfMaintenance = int.parse(res.maintenanceNumber.toString());
    double parsedValue = 0.0;
    if (chargeController.text != null && chargeController.text.isNotEmpty) {
      try {
        parsedValue = double.parse(chargeController.text);
      } catch (e) {
        // Log the error and set parsedValue to 0.0 if parsing fails
        print('Error parsing chargeController.text: $e');
        parsedValue = 0.0;
      }
    }

    // Update the observable variable
    maintenancecharge.value = parsedValue;



    taxAmount.value = maintenancecharge.value * 0.18;
    totalPayableAmt.value = maintenancecharge.value + taxAmount.value;

  }

  // Future<void> fetchMaintenanceData() async {
  //   try {
  //     WarrantyCardListingModel2 fetchedData = await ApiProvider().getWarrantyListing2();
  //
  //     print(fetchedData);
  //
  //     maintenanceData = fetchedData.data;
  //   } catch (e) {
  //     // Handle any errors that occur during the API call
  //     print("Error fetching maintenance data: $e");
  //   }
  // }


  void showDateDialog(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
        doneDates.add(controller.text);
      });
    }
  }

  estimatedata() async {
    var responseData = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getModels'),
    );
    var model = jsonDecode(responseData.body.toString());
    if (model['status'] != 0) {
      List madeldata2=[];
      List modelData = model['models'];
      modelData.forEach((val) {
        madeldata2.add(val);
        models.add(val['modal_name']);
      });
      _intervalValue = models.first;
      // models = model['models'];

      for (var model in madeldata2) {
        modelId = model['id'];
        break;
      }

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
    // print(response.body);
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
    ).then(
          (pickedDate) {
        if (pickedDate != null) {
          DateFormat formatter = DateFormat('dd-MM-yyyy');
          setState(() {
            controller.text = formatter.format(pickedDate);
            // Add the picked date to doneDates list
            doneDates.add(formatter.format(pickedDate));
          });
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    bool showDetails = selectServices!.any((service) =>
    service.name == 'Ceramic Coating' ||
        service.name == 'Graphene Coating' ||
        (service.name != null && service.name!.contains('PPF')));
    final width = MediaQuery.of(context).size.width;
    List<String> arr = List.generate(numberOfMaintenance, (index) => '${index + 1}');
     intialvalue=arr[0];


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



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.blockSizeVertical! * 4,
                        ),

                        Row(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.pop(context);
                            }, icon:  Icon(
                              Icons.arrow_back,
                              color: AppColors.white,
                            ),),
                            SizedBox(
                              height: SizeConfig.blockSizeHorizontal! * 4,
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
                          ],
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
                        if(selectServices!.isNotEmpty)...[
                          Visibility(
                            visible: showDetails,
                            child: Row(
                              children: [
                                Text(
                                  'Service Details -',
                                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],


                        SizedBox(
                          height: SizeConfig.blockSizeVertical! * 2,
                        ),


                        ...selectServices!.map((service) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child:

                          Column(
                            children: [
                              if (service.name == 'Ceramic Coating' || service.name == 'Graphene Coating' ||
                                  (service.name != null && service.name!.contains('PPF')))

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [


                                  Text(
                                    service.name ?? 'Service name',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),


                                ],
                              ),

                            ],
                          ),
                        )),

                        Visibility(
                          visible: showDetails,
                            child: Column(
                          children: [
                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 2,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                textFieldForWarranty(
                                  context: context,
                                  textEditingController: ceramicCoatingPackageController,
                                  labelText: "Package",
                                  hintext: "Package",
                                  readOnly: true,
                                ),
                              ],
                            ), SizedBox(
                              height: SizeConfig.blockSizeVertical! * 4,
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 4,
                            ),
                            if (numberOfMaintenance > 0)
                              MaintenanceDetailTableWidget(
                                numberOfMaintenance: numberOfMaintenance,

                                doneDate:doneDates, serviceDueDates: serviceDates,
                              ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical! * 4,
                            ),
                            if (numberOfMaintenance > 1) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomDropdownFormField<String>(
                                    width: Responsive.isMobile(context) ? width : MediaQuery.of(context).size.width / 3.5,
                                    labelFontWeight: FontWeight.w500,
                                    label: "Select Maintenance",
                                    hintText: "Select Maintenance",
                                    value: intialvalue, // Set initial value to the first item in arr or null if arr is empty
                                    items: arr,
                                    onChanged: (value) async {
                                      intialvalue=value.toString();

                                    },
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
                                    onChange: (value) {
                                      if (value.isEmpty) {
                                        maintenancecharge.value = 0;
                                        taxAmount.value = 0;
                                        totalPayableAmt.value = 0;
                                      } else {
                                        maintenancecharge.value = double.tryParse(chargeController.text) ?? 0;
                                        taxAmount.value = maintenancecharge.value * 0.18;
                                        totalPayableAmt.value = maintenancecharge.value + taxAmount.value;
                                      }
                                      setState(() {});
                                    },

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
                          ],
                        )),

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

                                estimateData["name"] = name.text.toString();
                                estimateData["date"] = date.text.toString();
                                estimateData["email"] = email.toString();
                                estimateData["address"] = address.toString();
                                estimateData["vin"] = vin.toString();
                                estimateData["gst"] = gst.toString();
                                estimateData["estimated_delivery_time"] = estimatedDeliveryTime.toString();
                                estimateData["assigned_worker"] = assignedWorker.toString();
                                estimateData["phone"] = phoneNo.text.toString();
                                estimateData["vehicle_number"] = vechileNo.text;
                                estimateData["model_name"] = model.text;
                                estimateData["model_id"] = modelId.toString();
                                estimateData["make_id"] = make.text;
                                estimateData["year"] = year.text;
                                estimateData["color"] = color.text;
                                estimateData["segment"] = segment.text;

                                estimateData["select_services_name"] = selectServices?.map((service) => service.name).toList() ?? [];
                                estimateData["select_services_type"] = selectServices?.map((service) => service.type).toList() ?? [];
                                estimateData["select_services_amount"] = selectServices?.map((service) => service.amount).toList() ?? [];
                                estimateData["select_services_package"] = selectServices?.map((service) => service.package).toList() ?? [];

                                estimateData["ppf_services_name"] = ppfServices?.map((service) => service.name).toList() ?? [];
                                estimateData["ppf_services_type"] = ppfServices?.map((service) => service.type).toList() ?? [];
                                estimateData["ppf_services_package"] = ppfServices?.map((service) => service.package).toList() ?? [];

                                estimateData["total_taxable_amount"] = taxAmount.value.toString();
                                estimateData["total_payable_amount"] = totalPayableAmt.value.toString();
                                estimateData['selected_maintences']=intialvalue.toString();

                                estimateData["total_payable_amount"] = totalPayableAmt.value.toString();

                                estimateData["maintenance_number"] = selectMaintenenceController.text.toString();

                                List<String> serviceDateStrings = serviceDates.map((dateTime) => dateTime.toIso8601String().split('T')[0]).toList();
                                estimateData["due_date"] = serviceDateStrings;

                                 estimateData["done_date"] = doneDates;
                                estimateData["charges"] = totalPayableAmt.value.toString();

                                var storeEstimateRes = await ApiProvider().storeMaintenance(estimateData, widget.maintenanceData.id.toString(),);

                                if (storeEstimateRes['status'] == "1") {
                                  ApiProvider().storeInvoiceNumber(invoiceNumber, widget.maintenanceData.id.toString(),
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
