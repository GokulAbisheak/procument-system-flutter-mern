import 'dart:convert';
import 'package:build_zone/presentation/concernScreen/concernScreen.dart';
import 'package:build_zone/presentation/deliveryAdviceNoteScreen/deliveryAdviceNoteScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:build_zone/core/app_export.dart';
import 'package:build_zone/core/utils/image_constant.dart';
import 'package:build_zone/theme/custom_text_style.dart';
import 'package:build_zone/widgets/app_bar/appbar_image.dart';
import 'package:build_zone/widgets/app_bar/appbar_image_1.dart';
import 'package:build_zone/widgets/app_bar/appbar_subtitle.dart';
import 'package:build_zone/widgets/app_bar/custom_app_bar.dart';
import 'package:build_zone/widgets/custom_elevated_button.dart';

class PRScreen extends StatefulWidget {
  PRScreen({Key? key}) : super(key: key);

  @override
  _PRScreenState createState() => _PRScreenState();
}

class _PRScreenState extends State<PRScreen> {
  List<Map<String, dynamic>> prList = [];
  late http.Client client;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    fetchPurchaseRequisitions();
  }

  Future<void> fetchPurchaseRequisitions() async {
    final List<Map<String, dynamic>>? fetchedPRList = await getAllPR(context);
    if (fetchedPRList != null) {
      setState(() {
        prList = fetchedPRList;
      });
    }
  }

  Future<String> getEmpIdFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId') ??
        ''; // Provide a default value if 'empId' is not found
  }

  Future<List<Map<String, dynamic>>?> getAllPR(BuildContext context) async {
    try {
      final empid = await getEmpIdFromLocalStorage();
      final response = await client.get(
        Uri.parse(
            'http://192.168.56.1:8080/purchase-requisition/get-pr-by-empid/$empid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Explicitly cast the result to the correct type
        final List<Map<String, dynamic>> prList =
            (json.decode(response.body) as List)
                .map((item) => item as Map<String, dynamic>)
                .toList();
        return prList;
      } else {
        // Handle error responses here
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch purchase requisitions');
      }
    } catch (e) {
      // Handle network errors or other exceptions here
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          leadingWidth: 64.h,
          leading: AppbarImage(
            imagePath: ImageConstant.imgWorkers,
            margin: EdgeInsets.only(
              left: 22.h,
              top: 7.v,
              bottom: 7.v,
            ),
          ),
          title: Container(
            height: 38.99.v,
            width: 111.h,
            margin: EdgeInsets.only(left: 9.h),
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 6.v),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Build",
                            style: CustomTextStyles.headlineSmallBlack90024,
                          ),
                          TextSpan(
                            text: "Zone",
                            style: CustomTextStyles.headlineSmallOrange500,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                AppbarSubtitle(
                  text: "S     O     L     U     T     I     O     N     S",
                  margin: EdgeInsets.only(
                    left: 10.h,
                    top: 31.v,
                    right: 17.h,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            AppbarImage1(
              imagePath: ImageConstant.imgGroup10,
              margin: EdgeInsets.fromLTRB(26.h, 16.v, 26.h, 15.v),
              onTap: () async {
                // Show an alert dialog to confirm logout
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Confirm Logout',
                        textAlign: TextAlign.center,
                      ),
                      content: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: Text('OK'),
                          onPressed: () async {
                            // User pressed "OK," call the removePrefs function
                            Navigator.of(context).pop(); // Close the dialog
                            await removePrefs(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 54, vertical: 28),
            child: Column(
              children: [
                Text(
                  "Purchase Requisitions",
                  style: CustomTextStyles.titleLargeBlack90022,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: prList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> pr = prList[index];
                    String id = pr['_id'] ?? "Unknown ID";
                    String itemName = pr['item'] ?? "Unknown Product";
                    String date = pr['dateTime'] ?? "Unknown";
                    String extractedDate = date.substring(0, 10);
                    String status = pr['approvalStatus'] ?? "Pending";
                    String projectName = pr['projectName'] ?? "Null";
                    String amount = pr['totalAmount'].toString() ?? "00.00";
                    return Container(
                      margin: EdgeInsets.only(
                        left: 1.h,
                        top: 55.v,
                        bottom: 5.v,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 19.h,
                        vertical: 18.v,
                      ),
                      decoration: AppDecoration.fillBlueGray,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20.h),
                            child: Row(
                              children: [
                                Opacity(
                                  opacity: 0.5,
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 1.v),
                                    child: Text(
                                      "$itemName",
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 1.v),
                                  child: Text(
                                    "$projectName",
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          Row(
                            // Another row inside the container
                            children: [
                              Opacity(
                                opacity: 0.5,
                                child: CustomImageView(
                                  imagePath:
                                      ImageConstant.imgCalendarsilhouette,
                                  height: 17.adaptSize,
                                  width: 17.adaptSize,
                                  margin: EdgeInsets.only(
                                    top: 10.v,
                                    bottom: 11.v,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 1.v, left: 7.v),
                                  child: Text(
                                    "$extractedDate",
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Opacity(
                                opacity: 0.5,
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 7.h),
                                  child: Text(
                                    "Rs. $amount.00",
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50.v,
                            width: 143.h,
                            margin: EdgeInsets.only(
                              left: 62.h,
                              top: 14.v,
                              bottom: 14.v,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomImageView(
                                  svgPath: ImageConstant.imgRectangle5,
                                  height: 100
                                      .v, // Adjust the height to center the text
                                  width: 143.h,
                                  alignment: Alignment.topCenter,
                                  color: getColorForStatus(
                                      status), // Set the color based on the status
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "$status",
                                    style:
                                        CustomTextStyles.headlineSmallWhiteA700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: (status == 'Approved'),
                              child: CustomElevatedButton(
                                text: "Delivery Advice Note",
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DeliveryAdviceNoteScreen(id: "$id"),
                                    ),
                                  );
                                },
                                buttonTextStyle: TextStyle(fontSize: 12.0),
                                width: 150.0,
                                alignment: Alignment.center,
                              ))
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/add_pr_screen');
            // Handle the action when the FAB is pressed
            // You can navigate to another screen or perform an action here
          },
          backgroundColor: Color(0xFFFE9901),
          child: Icon(
            Icons.add,
            color: Colors.white, // Set the icon color to white
          ),
        ),
      ),
    );
  }

  Future<void> removePrefs(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('empId');
    Navigator.of(context).pushReplacementNamed('/login_screen');
  }

  Color getColorForStatus(String status) {
    switch (status) {
      case "Pending":
        return Color(0xFFFE9901); // Set to yellow for pending status
      case "Approved":
        return Colors.green; // Set to green for accepted status
      case "Rejected":
        return Colors.red;
      case "Order Placed":
        return Colors.blueAccent; // Set to red for rejected status
      default:
        return Colors
            .transparent; // Set a default color or handle other statuses
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: PRScreen(),
  ));
}
