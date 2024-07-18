// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:responsive_dashboard/component/header.dart';
import 'package:responsive_dashboard/config/responsive.dart';
import 'package:responsive_dashboard/utils/image_constants.dart';

class OffersListingScreen extends StatefulWidget {
  @override
  State<OffersListingScreen> createState() => OffersListingScreenStateState();
}

class OffersListingScreenStateState extends State<OffersListingScreen> {
  TextEditingController name = TextEditingController();

  Future<List<Coupon>> fetchCoupons() async {
    final response = await http.get(Uri.parse('https://admin.detailingxperts.in/public/api/getCoupons'));
    if (response.statusCode == 200) {
      // Assuming the JSON response is an object with a "coupons" key
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> couponJson = jsonResponse['coupons']; // Adjusted line
      return couponJson.map((json) => Coupon.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load coupons');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 18 : 50.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      'Exclusive Offers Just for You!',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<List<Coupon>>(
                      future: fetchCoupons(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          print(snapshot.error);
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return buildCouponList(snapshot.data!, width);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCouponList(List<Coupon> coupons, double width) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 10 : 100, vertical: 20),
      margin: EdgeInsets.all(Responsive.isMobile(context) ? 0 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: coupons.map((coupon) => buildCoupon(coupon, width)).toList(),
      ),
    );
  }

  Widget buildCoupon(Coupon coupon, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  coupon.code,
                  style: GoogleFonts.inter(
                    fontSize: Responsive.isMobile(context) ? 20 : 28,
                    color: Color(0xffED2626),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: coupon.code)).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  },
                  child: Image.asset(
                    ImageConstant.copyIcon,
                    width: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Text(
                "( ${coupon.description} )",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Color(0xff7E7878),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 1,
              color: Color(0xff7E7878),
              margin: const EdgeInsets.symmetric(vertical: 10),
            )
          ],
        ),
      ],
    );
  }
}

class Coupon {
  final String code;
  final String id;
  final String discount;
  final String description;

  Coupon({
    required this.code,
    required this.id,
    required this.discount,
    required this.description,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'],
      description: json['description'],
      id: json['description'],
      discount: json['description'],
    );
  }
}
