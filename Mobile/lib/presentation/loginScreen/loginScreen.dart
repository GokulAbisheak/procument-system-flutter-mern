import 'package:build_zone/core/app_export.dart';
import 'package:build_zone/widgets/custom_elevated_button.dart';
import 'package:build_zone/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SiteManager {
  String empId;
  String password;

  SiteManager({required this.empId, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'empId': empId,
      'password': password,
    };
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController employeeidlabelController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 28.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 11.v),
                SizedBox(
                  height: 172.v,
                  width: 166.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgWorkers,
                        height: 130.adaptSize,
                        width: 130.adaptSize,
                        alignment: Alignment.topCenter,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Build",
                                style: theme.textTheme.displaySmall,
                              ),
                              TextSpan(
                                text: "Zone",
                                style: CustomTextStyles.displaySmallPrimary,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "S  O  L  U  T  I  O  N  S",
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 81.v),
                CustomTextFormField(
                  controller: employeeidlabelController,
                  hintText: "Employee ID",
                ),
                SizedBox(height: 32.v),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: "Password",
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                CustomElevatedButton(
                    text: "Sign in",
                    margin: EdgeInsets.only(
                      left: 38.h,
                      top: 61.v,
                      right: 38.h,
                    ),
                    onTap: () {
                      final siteManager = SiteManager(
                        empId: employeeidlabelController.text,
                        password: passwordController.text,
                      );

                      login(context, siteManager);
                    }),
                SizedBox(height: 40.v),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    "or",
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                SizedBox(height: 9.v),
                GestureDetector(
                  onTap: () {
                    // Add your onTap logic here
                    Navigator.of(context)
                        .pushReplacementNamed('/register_screen');
                  },
                  child: Text(
                    'Sign up',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height: 17.v),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context, SiteManager siteManager) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1:8080/site-manager/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(siteManager.toJson()), // Convert User object to JSON
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        final empid = responseJson['empId'].toString();
        print(empid);
        // Successful request
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('empId', empid);

        // Show a success dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login Successful'),
              content: Text('You have successfully logged in.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/all_pr_screen');
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

        // Show an error dialog
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Failed to log in. Please check your credentials.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle network errors or other exceptions here

      // Show a generic error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
