
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Services/Apis.dart';
import '../../component/custom/custom_fields.dart';
import '../../component/header.dart';
import '../../config/responsive.dart';
import '../../config/size_config.dart';
import '../../dataModel/warranty_card_listing_model.dart';
import '../../style/colors.dart';
import 'addMaintenance.dart';

class AddMaintenance extends StatefulWidget {
  @override
  State<AddMaintenance> createState() => _AddMaintenanceState();
}

class _AddMaintenanceState extends State<AddMaintenance> {
  TextEditingController searchController = TextEditingController();
  List<WarrantyCardData>? maintenanceData;
  List<WarrantyCardData> results = [];

  @override
  void initState() {
    super.initState();
    if (maintenanceData == null) {
      fetchMaintenanceData();
    }
  }

  Future<void> fetchMaintenanceData() async {
    try {
      WarrantyCardListingModel2 fetchedData = await ApiProvider().getWarrantyListing2();
      setState(() {
        maintenanceData = fetchedData.data;
      });
    } catch (e) {
      print("Error fetching maintenance data: $e");
    }
  }
  List<WarrantyCardData> searchMaintenance(String searchQuery) {
    List<WarrantyCardData> maintenanceList = maintenanceData ?? [];
    return maintenanceList.where((maintenance) {
      final String searchTerm = searchQuery.toLowerCase();
      return maintenance.name!.toLowerCase().contains(searchTerm);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: Responsive.isMobile(context) ? 15 : 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Header(),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              if (Responsive.isMobile(context))
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
                              setState(() {
                                results = searchMaintenance(value.toLowerCase());
                              });
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
                        SizedBox(width: 30),
                        CustomButton(
                          text: "Search",
                          onPressed: () {
                            setState(() {
                              results = searchMaintenance(searchController.text.toLowerCase());
                            });
                          },
                          width: Responsive.isMobile(context) ? 160 : 180,
                          height: 35,
                        ),
                      ],
                    ),
                  ],
                )
              else
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
                              setState(() {
                                results = searchMaintenance(value.toLowerCase());
                              });
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
                        SizedBox(width: 30),
                        CustomButton(
                          text: "Search",
                          onPressed: () {
                            setState(() {
                              results = searchMaintenance(searchController.text.toLowerCase());
                            });
                          },
                          width: 180,
                          height: 35,
                        ),
                      ],
                    ),
                  ],
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final maintenance = results[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to details screen with selected maintenance item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddMaintenance2( maintenanceData: maintenance,),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(maintenance.name ?? "", style: GoogleFonts.inter(fontSize: 18,color: Colors.white                       ),),
                        // Add more details of maintenance if needed
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Details screen for maintenance item
class MaintenanceDetailsScreen extends StatelessWidget {
  final WarrantyCardData maintenance;

  MaintenanceDetailsScreen(this.maintenance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Details'),
      ),
      body: Center(
        child: Text(maintenance.name ?? ""),
        // Add more details of maintenance if needed
      ),
    );
  }
}