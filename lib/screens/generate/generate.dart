// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrcode_scanner/database/db_helper.dart';
import 'package:qrcode_scanner/screens/generate/qrcode.dart';
import 'package:qrcode_scanner/utils/qr_utils.dart';
import 'package:qrcode_scanner/widgets/appbar.dart';
import 'package:qrcode_scanner/widgets/generate/date_picker.dart';
import 'package:qrcode_scanner/widgets/generate/entry_type.dart';
import 'package:qrcode_scanner/widgets/generate/field_place.dart';
import 'package:qrcode_scanner/widgets/generate/fields.dart';
import 'package:qrcode_scanner/widgets/generate/time_picker.dart';
import 'package:qrcode_scanner/widgets/ui/background.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  var selectedEntryPass = 'VIP';
  TextEditingController entryTypeController =
      TextEditingController(text: 'VIP');
  TextEditingController userName = TextEditingController();
  TextEditingController numberOfMembers = TextEditingController();

  TextEditingController venueDate = TextEditingController();
  TextEditingController venuePlace = TextEditingController();
  bool showMandatoryFieldMessage = false;
  TextEditingController venueStartTime = TextEditingController();
  TextEditingController venueEndTime = TextEditingController();

  DatabaseHelper dbHelper = DatabaseHelper();
  final List<String> entryPassOptions = ['VIP', 'Normal', 'Guest'];
  bool validateFields() {
    bool isValid = true;

    if (userName.text.isEmpty ||
        entryTypeController.text.isEmpty ||
        numberOfMembers.text.isEmpty ||
        venueStartTime.text.isEmpty ||
        venueEndTime.text.isEmpty ||
        venueDate.text.isEmpty ||
        venuePlace.text.isEmpty) {
      isValid = false;
    }
    return isValid;
  }

  Future<void> generateRecord() async {
    if (validateFields()) {
      String gettingUsername = userName.text;
      String gettingEntryType = entryTypeController.text;
      String gettingDate = venueDate.text;
      String gettingPlace = venuePlace.text;
      String gettingStartTime = venueStartTime.text;
      String gettingEndTime = venueEndTime.text;
      String authcode =
          QRUtils.generateCode(gettingUsername, entryTypeController.text);

      try {
        Map<String, dynamic> recordData = {
          "user_name": userName.text,
          "members": numberOfMembers.text,
          "user_start_time": venueStartTime.text,
          "user_end_time": venueEndTime.text,
          "user_date": venueDate.text,
          "user_place": venuePlace.text,
          "entry_type": entryTypeController.text,
          "number_auth": authcode,
        };

        await dbHelper.insertRecord(recordData);
      } catch (e) {
        print(e);
      }
      setState(() {
        showMandatoryFieldMessage = false;
      });

      String generatedCode = gettingUsername;

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateQrCode(
            fetchUsername: gettingUsername,
            fetchEntryType: gettingEntryType,
            fetchDate: gettingDate,
            fetchPlace: gettingPlace,
            fetchStartTime: gettingStartTime,
            fetchEndTime: gettingEndTime,
            textQrCode: generatedCode,
            fetchCode: authcode,
            authcode: authcode,
          ),
        ),
      ).then(
        (value) {
          userName.clear();
          entryTypeController.clear();
          numberOfMembers.clear();
          venueDate.clear();
          venuePlace.clear();
          venueStartTime.clear();
          venueEndTime.clear();
        },
      );
    } else {
      print("Please Fill All fields");
      Fluttertoast.showToast(msg: "Please Fill All fields");
      setState(() {
        showMandatoryFieldMessage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var primaryColour = const Color.fromARGB(255, 1, 41, 110);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Creating QR code',
      ),
      body: CustomBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      InputFieldsSection(
                        userNameController: userName,
                        numberOfMembersController: numberOfMembers,
                        showMandatoryFieldMessage: showMandatoryFieldMessage,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EntryTypeDropdown(
                        controller: entryTypeController,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            entryTypeController.text = newValue;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TimePickerField(
                        label: 'Start Time',
                        controller: venueStartTime,
                        showMandatoryFieldMessage: showMandatoryFieldMessage,
                      ),
                      const SizedBox(height: 10),
                      TimePickerField(
                        label: 'End Time',
                        controller: venueEndTime,
                        showMandatoryFieldMessage: showMandatoryFieldMessage,
                      ),
                      const SizedBox(height: 10),
                      DatePicker(
                        dateController: venueDate,
                        showMandatoryFieldMessage: showMandatoryFieldMessage,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      VenuePlace(
                        placeController: venuePlace,
                        showMandatoryFieldMessage: showMandatoryFieldMessage,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColour,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 35,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            generateRecord();
                          },
                          child: const Text("Generate"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
