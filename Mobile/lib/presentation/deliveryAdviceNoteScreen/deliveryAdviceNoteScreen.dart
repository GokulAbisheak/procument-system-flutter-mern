import 'dart:convert';
import 'package:build_zone/core/app_export.dart';
import 'package:build_zone/presentation/concernScreen/concernScreen.dart';
import 'package:build_zone/presentation/prScreen/prScreen.dart';
import 'package:flutter/material.dart';
import 'package:build_zone/widgets/custom_elevated_button.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_text_form_field.dart';

class DeliveryAdviceNoteScreen extends StatefulWidget {
  final String id;

  DeliveryAdviceNoteScreen({required this.id});

  @override
  _DeliveryAdviceNoteScreenState createState() =>
      _DeliveryAdviceNoteScreenState(id: id);
}

class _DeliveryAdviceNoteScreenState extends State<DeliveryAdviceNoteScreen> {
  final String id;
  late http.Client client;
  Map<String, dynamic>? purchaseData;
  bool receivedItems = false;

  _DeliveryAdviceNoteScreenState({required this.id});

  @override
  void initState() {
    super.initState();
    client = http.Client();
    getPR(context).then((data) {
      setState(() {
        purchaseData = data;
      });
    });
  }

  Future<Map<String, dynamic>?> getPR(BuildContext context) async {
    try {
      final response = await client.get(
        Uri.parse(
            'http://192.168.56.1:8080/purchase-requisition/get-pr-by-id/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> purchaseData = json.decode(response.body);

        return purchaseData;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to fetch purchase requisitions');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Advice Note"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Left-align the rest of the content
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    'DELIVERY ADVICE NOTE',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              if (purchaseData != null)
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Left-align the text
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Text(
                          'Reference Number: $id',
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        )),
                    Text(
                      'Item: ${purchaseData!['item']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'Quantity: ${purchaseData!['quantity']} kg',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 50.h, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: receivedItems,
                            onChanged: (bool? value) {
                              setState(() {
                                receivedItems = value!;
                              });
                            },
                          ),
                          Text(
                            'I accepted the items',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                        child: CustomElevatedButton(
                          onTap: () {
                            if (receivedItems) {
                              createDelivery(context, id, "complete", null);
                            } else {
                              // Handle a case when items are not accepted
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Oops!"),
                                    content: Text(
                                        "You must accept the items before confirming."),
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
                          text: 'Confirm',
                        )),
                    CustomElevatedButton(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ConcernScreen(id: "$id"),
                          ),
                        );
                      },
                      text: 'Give Concern',
                      isDisabled: receivedItems,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> createDelivery(BuildContext context, String purchaseRef,
    String status, String? concern) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.56.1:8080/delivery'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "purchaseRef": purchaseRef,
        "status": status,
        "concern": concern,
      }),
    );

    if (response.statusCode == 201) {
      // Successfully created the delivery
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Thank you for purchasing from us!"),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => PRScreen()));
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to create delivery. Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
