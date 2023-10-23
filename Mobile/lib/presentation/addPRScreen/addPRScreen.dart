import 'package:build_zone/core/app_export.dart';
import 'package:build_zone/widgets/app_bar/appbar_iconbutton.dart';
import 'package:build_zone/widgets/app_bar/appbar_image.dart';
import 'package:build_zone/widgets/app_bar/appbar_subtitle.dart';
import 'package:build_zone/widgets/app_bar/custom_app_bar.dart';
import 'package:build_zone/widgets/custom_elevated_button.dart';
import 'package:build_zone/widgets/custom_icon_button.dart';
import 'package:build_zone/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PurchaseRequisition {
  String empId;
  String item;
  String projectName;
  double quantity;
  double unitPrice;
  double totalAmount;

  PurchaseRequisition(
      {required this.empId,
      required this.item,
      required this.projectName,
      required this.quantity,
      required this.unitPrice,
      required this.totalAmount});

  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'item': item,
      'projectName': projectName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount
    };
  }
}

class AddPRScreen extends StatefulWidget {
  AddPRScreen({Key? key}) : super(key: key);

  _AddPRScreenState createState() => _AddPRScreenState();
}

class _AddPRScreenState extends State<AddPRScreen> {
  List<Map<String, dynamic>> projList = [];
  List<Map<String, dynamic>> itemList = [];

  late http.Client client;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    fetchProjects();
    fetchItems();
  }

  Future<void> fetchProjects() async {
    final List<Map<String, dynamic>>? fetchedProjList =
        await getAllProjects(context);
    if (fetchedProjList != null) {
      setState(() {
        projList = fetchedProjList;
      });
    }
  }

  Future<void> fetchItems() async {
    final List<Map<String, dynamic>>? fetchedItemList =
        await getAllItems(context);
    if (fetchedItemList != null) {
      setState(() {
        itemList = fetchedItemList;
      });
    }
  }

  Future<String> getEmpIdFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('empId') ??
        ''; // Provide a default value if 'empId' is not found
  }

  Future<List<Map<String, dynamic>>?> getAllProjects(
      BuildContext context) async {
    try {
      final empid = await getEmpIdFromLocalStorage();
      final response = await client.get(
        Uri.parse(
            'http://192.168.56.1:8080/project/get-project-by-empid/$empid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Explicitly cast the result to the correct type
        final List<Map<String, dynamic>> projList =
            (json.decode(response.body) as List)
                .map((item) => item as Map<String, dynamic>)
                .toList();
        return projList;
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

  Future<List<Map<String, dynamic>>?> getAllItems(
      BuildContext context) async {
    try {
      
      final response = await client.get(
        Uri.parse(
            'http://192.168.56.1:8080/item/get-items'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Explicitly cast the result to the correct type
        final List<Map<String, dynamic>> itemList =
            (json.decode(response.body) as List)
                .map((item) => item as Map<String, dynamic>)
                .toList();
        return itemList;
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


  TextEditingController nameController = TextEditingController();
  TextEditingController quantityvalueController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define a variable to store the selected item
  String? selectedProject;
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                              style: theme.textTheme.headlineSmall,
                            ),
                            TextSpan(
                              text: "Zone",
                              style: CustomTextStyles.headlineSmallPrimary,
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
                      left: 15.h,
                      top: 31.v,
                      right: 17.h,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              AppbarImage(
                imagePath: ImageConstant.imgGroup10,
                margin: EdgeInsets.fromLTRB(26.h, 16.v, 26.h, 15.v),
                onTap: () async {
                  // Show an alert dialog to confirm logout
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'),
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
            ]),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 22.h,
                    top: 24.v,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconButton(
                        height: 50.adaptSize,
                        width: 50.adaptSize,
                        margin: EdgeInsets.only(bottom: 31.v),
                        padding: EdgeInsets.all(8.h),
                        decoration: IconButtonStyleHelper.outlineBlack,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgGroup6,
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/all_pr_screen');
                          },
                        ),
                      ),
                      Container(
                        width: 162.h,
                        margin: EdgeInsets.only(
                          left: 80.h,
                          top: 2.v,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Create Purchase \n",
                                style: CustomTextStyles.titleLargeBlack90022,
                              ),
                              TextSpan(
                                text: "Requisition \n",
                                style: CustomTextStyles.titleLargeBlack90022,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 72.h,
                          vertical: 140.v,
                        ),
                        decoration: AppDecoration.outlineBlack.copyWith(
                          borderRadius: BorderRadiusStyle.customBorderTL50,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            
                            
                            SizedBox(height: 35.v),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Project Name',
                                hintStyle: theme.textTheme.titleLarge,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.onPrimary,
                                contentPadding: EdgeInsets.all(13.h),
                              ),
                              value: selectedProject,
                              items: projList
                                  .map<DropdownMenuItem<String>>((project) {
                                return DropdownMenuItem<String>(
                                  value: project['projectName'],
                                  child: Text(project['projectName']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedProject = value;
                                });
                              },
                              style: theme.textTheme.titleLarge,
                            ),
                            SizedBox(height: 35.v),
                            DropdownButtonFormField<String>(
  decoration: InputDecoration(
    hintText: 'Item Name',
    hintStyle: theme.textTheme.titleLarge,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide(
        color: theme.colorScheme.onPrimaryContainer,
        width: 1,
      ),
    ),
    filled: true,
    fillColor: theme.colorScheme.onPrimary,
    contentPadding: EdgeInsets.all(13.h),
  ),
  value: selectedItem,
  items: itemList
      .map<DropdownMenuItem<String>>((item) {
    return DropdownMenuItem<String>(
      value: item['itemName'],
      child: Text(item['itemName']),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedItem = value;

      // Update the priceController with the selected item's price
      // You need to find the item's price based on the selected item name
      final selectedPrice = itemList
          .firstWhere((item) => item['itemName'] == value)['unitPrice'];
      priceController.text = selectedPrice.toString();
    });
  },
  style: theme.textTheme.titleLarge,
),SizedBox(height: 35.v),
                            CustomTextFormField(
                              controller: priceController,
                              textInputType: TextInputType.text,
                              hintText: "Unit Price",
                              enabled: false,
                            ),
                            SizedBox(height: 35.v),
                            CustomTextFormField(
                              controller: quantityvalueController,
                              textInputType: TextInputType.number,
                              hintText: "Quantity",
                            ),
                            SizedBox(height: 35.v),
                            CustomElevatedButton(
                              text: "Request ",
                              onTap: () async {
                                final empid = await getEmpIdFromLocalStorage();
                                final purchaseRequisition = PurchaseRequisition(
                                  empId: empid,
                                  item: selectedItem.toString(),
                                  projectName: selectedProject.toString(),
                                  quantity: double.parse(
                                      quantityvalueController.text),
                                  unitPrice:
                                      double.parse(priceController.text),
                                  totalAmount: calculateTotalAmount(),
                                );

                                double totalAmount = calculateTotalAmount();

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Submitted successfully'),
                                      content: Text(
                                          "The total amount is Rs. $totalAmount"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop('Cancel');
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            createPR(
                                                context, purchaseRequisition);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    '/all_pr_screen');
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: CustomImageView(
                        imagePath: ImageConstant.img360f317187640,
                        height: 100.v,
                        width: 100.h,
                        margin: EdgeInsets.only(top: 40.v, bottom: 60.v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future createPR(
  BuildContext context, PurchaseRequisition purchaseRequisition) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.56.1:8080/purchase-requisition/add-items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(purchaseRequisition.toJson()),
    );

    if (response.statusCode == 200) {
      // Successful request
      // Show an AlertDialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Purchase Requisition created successfully!'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Close the dialog
                 
                  // Navigate to 'all_pr_screen'
                  Navigator.of(context).pushReplacementNamed('/all_pr_screen');
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle error responses here
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create');
    }
  } catch (e) {
    // Handle network errors or other exceptions here
  }
}


  double calculateTotalAmount() {
    // Get the price and quantity as strings from the controllers
    String priceStr = priceController.text;
    String quantityStr = quantityvalueController.text;

    // Check if the input strings are empty or contain unexpected characters
    if (priceStr.isEmpty || quantityStr.isEmpty) {
      return 0.0; // Return a default value or handle the error as needed
    }

    // Parse the strings to double if they are valid numbers
    double price = double.tryParse(priceStr) ?? 0.0;
    double quantity = double.tryParse(quantityStr) ?? 0.0;

    // Calculate and return the total amount
    return price * quantity;
  }

  Future<void> removePrefs(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('empId');
    Navigator.of(context).pushReplacementNamed('/login_screen');
  }
}