import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_dashboard/Services/Apis.dart';
import 'package:responsive_dashboard/component/custom/custom_fields.dart';
import 'package:responsive_dashboard/component/custom/dropdown_field.dart';
import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/component/no_data_found.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/config/size_config.dart';
import 'package:responsive_dashboard/dataModel/user_data_model.dart';

import '../constants/app_constant.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController dateOfbirth = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController companyType = TextEditingController();
  TextEditingController companyGstNo = TextEditingController();
  TextEditingController companyPhone = TextEditingController();
  TextEditingController companyEmail = TextEditingController();
  TextEditingController companyAddress = TextEditingController();
  TextEditingController address = TextEditingController();
  UserDataModel? userDataModel;
  bool isLoading = true;
  bool notFound = false;
  String? _genderValue;

  getUserData() {
    ApiProvider().getProfile().then((value) => {
          isLoading = false,
          setState(() {
            if (value != null) {
              userDataModel = value;
              String? fullName = userDataModel?.data?.name;
              if (fullName != null) {
                List<String> nameParts = fullName.split(" ");
                firstName.text = nameParts.isNotEmpty ? nameParts[0] : "";
                lastName.text = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
              } else {
                firstName.text = "";
                lastName.text = "";
              }
              bioController.text = userDataModel?.data?.bio.toString() ?? "";
              email.text = userDataModel?.data?.email.toString() ?? "";
              mobile.text = userDataModel?.data?.mobile.toString() ?? "";
              _genderValue = userDataModel?.data?.gender.toString() ?? "";
              dateOfbirth.text = userDataModel?.data?.dateOfBirth.toString() ?? "";
              address.text = userDataModel?.data?.address.toString() ?? "";
              companyName.text = userDataModel?.data?.companyName.toString() ?? "";
              companyType.text = userDataModel?.data?.companyType.toString() ?? "";
              companyGstNo.text = userDataModel?.data?.companyGst.toString() ?? "";
              companyPhone.text = userDataModel?.data?.companyPhone.toString() ?? "";
              companyEmail.text = userDataModel?.data?.companyEmail.toString() ?? "";
              companyAddress.text = userDataModel?.data?.companyAddress.toString() ?? "";
            } else {
              notFound = true;
            }
          }),
        });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : !notFound
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(Responsive.isMobile(context) ? 15 : 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                              Text(
                                'Profile',
                                style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 4,
                              ),
                              if (Responsive.isMobile(context)) ...[
                                Wrap(
                                  children: [
                                    CachedNetworkImage(
                                      alignment: Alignment.center,
                                      height: 200,
                                      width: 309,
                                      imageUrl: userDataModel?.data?.avatar ?? noImg,
                                      placeholder: (context, url) => SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) {
                                        print(error);
                                        return Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        );
                                      },
                                    ),
                                    SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          children: [
                                            textFieldForWarranty(
                                              width: width,
                                              readOnly: true,
                                              context: context,
                                              textEditingController: firstName,
                                              labelText: "First Name",
                                              hintext: "First Name",
                                            ),
                                            textFieldForWarranty(
                                              width: width,
                                              readOnly: true,
                                              context: context,
                                              textEditingController: lastName,
                                              labelText: "Last Name",
                                              hintext: "Last Name",
                                            ),
                                          ],
                                        ),

                                        Wrap(
                                          children: [
                                            textFieldForWarranty(
                                              readOnly: true,
                                              width: width,
                                              context: context,
                                              textEditingController: email,
                                              labelText: "Email",
                                              hintext: "Email",
                                            ),
                                            textFieldForWarranty(
                                              width: width,
                                              readOnly: true,
                                              context: context,
                                              textEditingController: mobile,
                                              labelText: "Mobile",
                                              hintext: "Mobile",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Wrap(
                                          children: [
                                            CustomDropdownFormField<String>(
                                                width: width,
                                                hintText: "--Select--",
                                                label: "Gender",
                                                disabled: true,
                                                value: _genderValue,
                                                items: ["Male", "Female", "Other"],
                                                onChanged: ((value) {
                                                  // setState(() {
                                                  //   _genderValue = value;
                                                  // });
                                                })),
                                            // textFieldForWarranty(
                                            //   context: context,
                                            //   textEditingController: gender,
                                            //   labelText: "Gender",
                                            //   hintext: "Gender",
                                            // ),
                                            textFieldForWarranty(
                                              width: width,
                                              readOnly: true,
                                              context: context,
                                              textEditingController: dateOfbirth,
                                              labelText: "Date Of Birth",
                                              isRightIcon: true,
                                              isvalidationTrue: true,
                                              rightIcon: Icons.calendar_month,
                                              onTap: () {
                                                // pickFromDateTime(
                                                //   pickDate: true,
                                                //   context: context,
                                                //   controller: dateOfbirth,
                                                // );
                                              },
                                              hintext: "Date Of Birth",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Wrap(
                                          children: [
                                            textFieldForFullWidth(
                                              width: width,
                                              context: context,
                                              maxlines: 2,
                                              textEditingController: address,
                                              labelText: "Address",
                                              hintext: "Address",
                                              readOnly: true,
                                            ),
                                            textFieldForFullWidth(
                                              width: width,
                                              context: context,
                                              maxlines: 2,
                                              textEditingController: bioController,
                                              labelText: "Bio",
                                              hintext: "Bio",
                                              readOnly: true,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Text(
                                          'Company Details',
                                          style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
                                        ),
                                        Wrap(
                                          children: [
                                            textFieldForWarranty(
                                              width: width,
                                              readOnly: true,
                                              context: context,
                                              textEditingController: companyName,
                                              labelText: "Company Name",
                                              hintext: "Company Name",
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              width: width,
                                              textEditingController: companyType,
                                              labelText: "Company Type",
                                              hintext: "Company Type",
                                            ),
                                          ],
                                        ),
                                        Wrap(
                                          children: [
                                            textFieldForWarranty(
                                              readOnly: true,
                                              width: width,
                                              context: context,
                                              textEditingController: companyGstNo,
                                              labelText: "Company(GSTIN)",
                                              hintext: "Company(GSTIN)",
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              width: width,
                                              textEditingController: companyPhone,
                                              isDigitOnly: true,
                                              labelText: "Company Phone",
                                              hintext: "Company Phone",
                                            ),
                                          ],
                                        ),

                                        Wrap(
                                          children: [
                                            textFieldForWarranty(
                                              context: context,
                                              textEditingController: companyEmail,
                                              readOnly: true,
                                              width: width,
                                              labelText: "Company Email",
                                              hintext: "Company Email",
                                            ),
                                            textFieldForWarranty(
                                              width: width,
                                              readOnly: true,
                                              context: context,
                                              textEditingController: companyAddress,
                                              labelText: "Company Address",
                                              hintext: "Company Address",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        // CustomContainer(
                                        //   CustomButton(
                                        //     text: "Save Changes",
                                        //     onPressed: () async {
                                        //       Map<String, dynamic> profileData = {};
                                        //       profileData["user_id"] = AppConst.getAccessToken();
                                        //       profileData["first_name"] = firstName.text;
                                        //       profileData["last_name"] = lastName.text;
                                        //       profileData["mobile"] = mobile.text;
                                        //       profileData["gender"] = _genderValue;
                                        //       profileData["date_of_birth"] = dateOfbirth.text;
                                        //       profileData["address"] = address.text;
                                        //       profileData["bio"] = bioController.text;
                                        //       profileData["company_name"] = companyName.text;
                                        //       profileData["company_type"] = companyType.text;
                                        //       profileData["company_email"] = companyEmail.text;
                                        //       profileData["company_phone"] = companyPhone.text;
                                        //       profileData["company_gst"] = companyGstNo.text;
                                        //       profileData["company_address"] = companyAddress.text;
                                        //       final response = await ApiProvider().updateProfile(profileData);
                                        //       print(response);
                                        //       toastification.show(
                                        //         context: context,
                                        //         type: ToastificationType.success,
                                        //         title: Text(response["message"]),
                                        //         autoCloseDuration: const Duration(seconds: 5),
                                        //       );
                                        //     },
                                        //     width: 180,
                                        //     height: 35,
                                        //   ),
                                        //   alignment: Alignment.center,
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ] else ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      height: 200,
                                      width: Responsive.isTablet(context) ? 250 : 309,
                                      imageUrl: userDataModel?.data?.avatar ?? noImg,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) {
                                        print(error);
                                        return Icon(
                                          Icons.error,
                                          color: Colors.white,
                                        );
                                      },
                                    ),
                                    SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: firstName,
                                              labelText: "First Name",
                                              hintext: "First Name",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: lastName,
                                              labelText: "Last Name",
                                              hintext: "Last Name",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: email,
                                              labelText: "Email",
                                              hintext: "Email",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: mobile,
                                              labelText: "Mobile",
                                              hintext: "Mobile",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomDropdownFormField<String>(
                                                width: MediaQuery.of(context).size.width / 3.5,
                                                hintText: "--Select--",
                                                label: "Gender",
                                                disabled: true,
                                                value: _genderValue,
                                                items: ["Male", "Female", "Other"],
                                                onChanged: ((value) {
                                                  // setState(() {
                                                  //   _genderValue = value;
                                                  // });
                                                })),
                                            // textFieldForWarranty(
                                            //   context: context,
                                            //   textEditingController: gender,
                                            //   labelText: "Gender",
                                            //   hintext: "Gender",
                                            // ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: dateOfbirth,
                                              labelText: "Date Of Birth",
                                              isRightIcon: true,
                                              isvalidationTrue: true,
                                              rightIcon: Icons.calendar_month,
                                              onTap: () {
                                                // pickFromDateTime(
                                                //   pickDate: true,
                                                //   context: context,
                                                //   controller: dateOfbirth,
                                                // );
                                              },
                                              hintext: "Date Of Birth",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Row(
                                          children: [
                                            textFieldForFullWidth(
                                              width: MediaQuery.of(context).size.width / 3.5,
                                              context: context,
                                              maxlines: 2,
                                              textEditingController: address,
                                              labelText: "Address",
                                              hintext: "Address",
                                              readOnly: true,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            textFieldForFullWidth(
                                              width: MediaQuery.of(context).size.width / 3.5,
                                              context: context,
                                              maxlines: 2,
                                              textEditingController: bioController,
                                              labelText: "Bio",
                                              hintext: "Bio",
                                              readOnly: true,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Text(
                                          'Company Details',
                                          style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Row(
                                          children: [
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: companyName,
                                              labelText: "Company Name",
                                              hintext: "Company Name",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: companyType,
                                              labelText: "Company Type",
                                              hintext: "Company Type",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Row(
                                          children: [
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: companyGstNo,
                                              labelText: "Company(GSTIN)",
                                              hintext: "Company(GSTIN)",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: companyPhone,
                                              isDigitOnly: true,
                                              labelText: "Company Phone",
                                              hintext: "Company Phone",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                        Row(
                                          children: [
                                            textFieldForWarranty(
                                              context: context,
                                              textEditingController: companyEmail,
                                              readOnly: true,
                                              labelText: "Company Email",
                                              hintext: "Company Email",
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            textFieldForWarranty(
                                              readOnly: true,
                                              context: context,
                                              textEditingController: companyAddress,
                                              labelText: "Company Address",
                                              hintext: "Company Address",
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: SizeConfig.blockSizeVertical! * 4),
                                      ],
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : NoDataFound(),
    );
  }
}
