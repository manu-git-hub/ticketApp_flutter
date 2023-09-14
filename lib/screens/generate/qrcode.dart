import 'dart:io';
import 'dart:typed_data';
import 'package:qrcode_scanner/widgets/ui/background.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class CreateQrCode extends StatefulWidget {
  final String? textQrCode;
  final String fetchUsername;
  final String fetchEntryType;
  final String fetchPlace;
  final String fetchDate;
  final String fetchStartTime;
  final String fetchEndTime;
  final String fetchCode;
  final String authcode;

  const CreateQrCode(
      {Key? key,
      this.textQrCode,
      required this.fetchUsername,
      required this.fetchEntryType,
      required this.fetchPlace,
      required this.fetchDate,
      required this.fetchStartTime,
      required this.fetchEndTime,
      required this.fetchCode,
      required this.authcode})
      : super(key: key);

  @override
  State<CreateQrCode> createState() => _CreateQrCodeState();
}

class _CreateQrCodeState extends State<CreateQrCode> {
  final GlobalKey globalKey = GlobalKey();

  Future<void> convertQrCodeToImageAndShare() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image qrCodeImage = await boundary.toImage();
    final directory = (await getTemporaryDirectory()).path;
    ByteData? byteData =
        await qrCodeImage.toByteData(format: ui.ImageByteFormat.png);

    // Load the QR code image
    final qrCodeBytes = byteData!.buffer.asUint8List();
    final qrCodeImageFile = File("$directory/qrCode.png");
    await qrCodeImageFile.writeAsBytes(qrCodeBytes);

    // Create a canvas to draw the fetch username on the QR code image
    final newWidth = qrCodeImage.width.toDouble() + 100;
    final newHeight = qrCodeImage.height.toDouble() + 380;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromPoints(const Offset(0, 0), Offset(newWidth, newHeight)),
    );
    // Draw the QR code image
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, newWidth, newHeight), whitePaint);

    final qrCodeImagePainter = Paint()..isAntiAlias = true;
    final qrCodeImagePosition = Offset((newWidth - qrCodeImage.width) / 2, 50);
    canvas.drawImage(qrCodeImage, qrCodeImagePosition, qrCodeImagePainter);
    //Heading
    const headingText = "ENTRY PASS";
    final headingTextPainter = TextPainter(
      text: const TextSpan(
        text: headingText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    headingTextPainter.layout();
    final headingX = (newWidth - headingTextPainter.width) / 2;
    final headingY = qrCodeImagePosition.dy + qrCodeImage.height + 1;
    headingTextPainter.paint(canvas, Offset(headingX, headingY));

// Description

    TextSpan generateDynamicFieldText(String label, String value) {
      const maxCharactersPerLine = 18;
      if (value.length > maxCharactersPerLine) {
        value =
            '${value.substring(0, maxCharactersPerLine)}\n${value.substring(maxCharactersPerLine)}';
      }
      return TextSpan(
        text: label.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 09,
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const TextSpan(text: "\n\n"),
        ],
      );
    }

    // Description
    const descriptionText = "ENTRY INFORMATION\n\n";
    final userName =
        generateDynamicFieldText("User Name\n", widget.fetchUsername);
    final ticketType =
        generateDynamicFieldText("Entry Type\n", widget.fetchEntryType);
    final place = generateDynamicFieldText("Place\n", widget.fetchPlace);
    final date = generateDynamicFieldText("date\n", widget.fetchDate);
    final startTime =
        generateDynamicFieldText("Start Time\n", widget.fetchStartTime);
    final endTime = generateDynamicFieldText("End Time\n", widget.fetchEndTime);

    final ticketInfoText = TextSpan(
      children: [userName, ticketType, place, date, startTime, endTime],
    );

    final descriptionTextPainter = TextPainter(
      text: TextSpan(
        text: descriptionText,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        children: [
          ticketInfoText,
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    descriptionTextPainter.layout();
    descriptionTextPainter.layout(maxWidth: newWidth - 40);
    const descriptionX = 20.0;
    final descriptionY = headingY + headingTextPainter.height + 10;
    descriptionTextPainter.paint(canvas, Offset(descriptionX, descriptionY));

    // Save the canvas as an image
    final image = await recorder.endRecording().toImage(
          newWidth.toInt(),
          newHeight.toInt(),
        );
    final byteDataWithUsername = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    // Convert the image to bytes
    final imageBytesWithUsername = byteDataWithUsername!.buffer.asUint8List();
    final imageFileWithUsername = File("$directory/qrCodeWithUsername.png");
    await imageFileWithUsername.writeAsBytes(imageBytesWithUsername);
    // Share the QR code
    Share.shareFiles(
      [imageFileWithUsername.path],
      text: "Your text share",
    );
  }

  @override
  Widget build(BuildContext context) {
    var primaryColour = const Color.fromARGB(255, 1, 41, 110);
    String qrCodeData = widget.authcode;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Qr code screen",
          textAlign: TextAlign.center,
        ),
        backgroundColor: primaryColour,
        centerTitle: true,
        leading: Container(),
      ),
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImageView(
                    data: qrCodeData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                    gapless: true,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text("Error"),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => convertQrCodeToImageAndShare(),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
