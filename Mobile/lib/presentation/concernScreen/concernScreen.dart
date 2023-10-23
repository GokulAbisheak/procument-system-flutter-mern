import 'dart:convert';
import 'package:build_zone/presentation/prScreen/prScreen.dart';
import 'package:build_zone/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../widgets/custom_text_form_field.dart';

class ConcernScreen extends StatelessWidget {
  final String id;

  ConcernScreen({required this.id});

  TextEditingController textController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provide Concern"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                controller: textController,
                hintText: "Enter Concern",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Concern field cannot be left blank";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              CustomElevatedButton(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    String enteredText = textController.text;
                    final success =
                        await createDelivery(id, "incomplete", enteredText);
                    if (success) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Thank you!"),
                            content: Text("We will review your concern."),
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                    builder: (context) => PRScreen(),
                                  ));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Oops!"),
                            content: Text(
                                "Failed to provide concern. Please try again."),
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
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Oops!"),
                          content: Text("Concern field cannot be left blank."),
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
                },
                text: "Submit",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to create a new delivery
  Future<bool> createDelivery(
      String purchaseRef, String status, String concern) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.56.1:8080/delivery'), // Replace with your actual API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "purchaseRef": purchaseRef,
          "status": status,
          "concern": concern,
        }),
      );

      if (response.statusCode == 201) {
        // Successfully created the delivery
        return true;
      } else {
        print('Failed to create delivery. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
