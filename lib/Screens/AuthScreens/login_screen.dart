import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_dashboard/constants/validation/basic_validation.dart';
import 'package:responsive_dashboard/routes/RoutePath.dart';
import 'package:responsive_dashboard/constants/app_constant.dart';
import 'package:responsive_dashboard/style/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import '../../config/responsive.dart';
import '../../utils/loginUtility.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

var UserId;

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void saveUserId(int userId) {
    GetStorage().write('userId', userId);
  }

  void loginwithemailpassword(BuildContext context) async {
    if (email.text == '' || validateEmail(email.text) != null) {
      toastification.show(
        context: context,
        title: Text('Please enter valid email'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    } else if (password.text == '' || validatePassword(password.text) != null) {
      toastification.show(
        context: context,
        title: Text('Please enter valid password'),
        autoCloseDuration: const Duration(seconds: 5),
      );
    } else {
      try {
        var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/login'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email.text,
              "password": password.text,
            }));

        var status = jsonDecode(response.body.toString());
        print(response.body);
        print(status);
        if (status['status'] != 0) {
          UserId = status['data']['id'];
          AppConst.setAccessToken(status['data']['id']);


          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);

          if(status['data']['manager']==true){
            saveUserId(status['data']['parent_id']);
          }else{
            saveUserId(status['data']['id']);
          }

          toastification.show(
            context: context,
            type: ToastificationType.success,
            title: Text('Login Successfully'),
            autoCloseDuration: const Duration(seconds: 5),
          );
          Get.toNamed(RoutePath.dashboardScreen);
        } else {
          print(response.reasonPhrase);
          toastification.show(
            type: ToastificationType.error,
            context: context,
            title: Text('${status['message']}'),
            autoCloseDuration: const Duration(seconds: 5),
          );
        }
      } catch (e) {
        print(e);
        toastification.show(
          type: ToastificationType.error,
          context: context,
          title: Text('Something Went Wrong!'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Form(
        key: _formKey,
        child: Container(
          // height: double.infinity,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Container(
            width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width / 1.2 : MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  height: 50,
                ),
                Text(
                  'Detailing Xperts',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30.0),
                _buildEmailTF(),
                SizedBox(
                  height: 30.0,
                ),
                _buildPasswordTF(),
                SizedBox(
                  height: 50.0,
                ),
                _buildLoginBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            focusNode: emailFocusNode,
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.poppins(
              color: Colors.black,
              // fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            autofillHints: const [AutofillHints.email],
            // maxLength: 50,
            // validator: (value) => validateEmail(value),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            focusNode: passwordFocusNode,
            controller: password,
            obscureText: true,
            style: GoogleFonts.poppins(
              color: Colors.black,
              // fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
            onFieldSubmitted: (_) => {
              loginwithemailpassword(context),
            },
            // maxLength: 30,
            // validator: (value) => validatePassword(value),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return InkWell(
      onTap: () async {
        loginwithemailpassword(context);
      },
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
        child: Text(
          'LOGIN',
          style: GoogleFonts.poppins(
            color: Color(0xFF090909),
            // letterSpacing: 1.5,
            fontSize: 25.0,
            fontWeight: FontWeight.w700,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
