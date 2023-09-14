// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode_scanner/database/environment.dart';
import 'package:qrcode_scanner/screens/scaning/result.dart';
import 'package:qrcode_scanner/widgets/appbar.dart';
import 'package:qrcode_scanner/widgets/ui/background.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override

  // ignore: library_private_types_in_public_api
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late String scannedUsername;
  bool isScanning = true;
  bool isFlashlightOn = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void toggleFlashlight() {
    setState(() {
      isFlashlightOn = !isFlashlightOn;
      controller.toggleFlash();
    });
  }

  void flipCamera() {
    controller.flipCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((Barcode? scanData) {
      if (scanData != null) {
        controller.pauseCamera();

        checkPassStatus(scanData.code ?? '');
      }
    });
  }

  Future<void> checkPassStatus(String qrCodeData) async {
    final response = await http.post(
      Uri.parse('$apiUrl/check_pass_status.php'),
      body: {'number_auth': qrCodeData},
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['is_used'] == true) {
          _showPassUsedDialog();
        } else {
          _navigateToScannedDataPage(qrCodeData);
        }
      } else {
        print("HTTP Request Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        // Handle HTTP request error and show an error message
        _showErrorDialog("HTTP Request Error");
      }
    } catch (e) {
      print("Error: $e");
      // Handle other errors and show an error message
      _showErrorDialog("An Error Occurred");
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.resumeCamera();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPassUsedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pass Already Used"),
          content: const Text("This pass has already been used."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                controller.resumeCamera();
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Color.fromARGB(255, 1, 41, 110)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Scanning QR code',
        ),
        body: CustomBackground(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  "Place the QR Code in the area",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Scanning will start automatically",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 50),
                isLoading // Show loading indicator
                    ? const CircularProgressIndicator()
                    : Expanded(
                        flex: 4,
                        child: Stack(
                          children: [
                            _buildQrView(context),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: toggleFlashlight,
                                    icon: Icon(
                                      isFlashlightOn
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: flipCamera,
                                    icon: const Icon(Icons.flip_camera_android),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Developed by Leuwint Technologies",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 1,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ),
      ],
    );
  }

  bool isUserNumberReset = false;
  Future<void> _navigateToScannedDataPage(String qrCodeData) async {
    final updatedValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScannedDataPage(qrCodeData: qrCodeData),
      ),
    );

    if (updatedValue != null) {
      setState(() {
        isUserNumberReset = updatedValue;
      });
    }

    controller.resumeCamera();
  }
}
