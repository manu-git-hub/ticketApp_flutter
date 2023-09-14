// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_scanner/database/environment.dart';
import 'package:qrcode_scanner/screens/scaning/scanqr.dart';
import 'package:http/http.dart' as http;
import 'package:qrcode_scanner/widgets/ui/background.dart';

class ScannedDataPage extends StatefulWidget {
  final String qrCodeData;

  const ScannedDataPage({Key? key, required this.qrCodeData}) : super(key: key);

  @override
// ignore: library_private_types_in_public_api
  _ScannedDataPageState createState() => _ScannedDataPageState();
}

class _ScannedDataPageState extends State<ScannedDataPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isUsernameValid = false;
  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> checkUsernameExists(String authcode) async {
    final response = await http.post(
      Uri.parse('$apiUrl/db_check.php'),
      body: {'number_auth': authcode},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['user_exists'] == true;
    } else {
      print("HTTP Request Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception('Failed to check authcode.');
    }
  }

  Map<String, dynamic> _parseQRCodeData() {
    String authcode = widget.qrCodeData;
    String maskedAuthCode = '****${authcode.substring(authcode.length - 4)}';
    checkUsernameExists(authcode).then((exists) {
      if (exists) {
        isUsernameValid = exists;
        print("Have authcode");
      } else {
        print("No authcode");
      }
    }).catchError((error) {
      print("JSON Parsing Error: $error");
    });
    return {'code': maskedAuthCode};
  }

  bool isUserNumberReset = false;

  void _handleRescanButtonPressed() {
    if (isUserNumberReset) {
      updateToUserNumberZero(widget.qrCodeData);
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ScanScreen()));
  }

  void _handle() {
    if (isUserNumberReset) {
      updateToUserNumberZero(widget.qrCodeData);
    }
  }

  Future<void> updateToUserNumberZero(String authcode) async {
    final response = await http.post(
      Uri.parse('$apiUrl/update_user_number.php'),
      body: {'number_auth': authcode},
    );

    if (response.statusCode != 200) {
      print("HTTP Request Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> qrCodeDetails = _parseQRCodeData();
    var primaryColour = const Color.fromARGB(255, 1, 41, 110);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Scanned QR Data",
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: primaryColour,
          automaticallyImplyLeading: false,
        ),
        body: CustomBackground(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Scanned QR Code',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                const SizedBox(height: 20),
                QrImageView(
                  data: widget.qrCodeData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: qrCodeDetails.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _animation.value,
                      child: Text(
                        isUsernameValid
                            ? "Your Pass is Valid"
                            : "Your Pass is not valid",
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isUserNumberReset,
                        onChanged: (value) {
                          setState(() {
                            isUserNumberReset = value!;
                            if (value) {
                              _handle();
                            }
                          });
                        },
                        activeColor: Colors.white,
                        checkColor: primaryColour,
                      ),
                      const Text(
                        "Pending Members",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleRescanButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColour,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                    elevation: 5,
                  ),
                  child: const Text("Rescan"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
