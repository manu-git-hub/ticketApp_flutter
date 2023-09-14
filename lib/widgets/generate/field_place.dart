import 'package:flutter/material.dart';

class VenuePlace extends StatefulWidget {
  final TextEditingController placeController;
  final bool showMandatoryFieldMessage;

  const VenuePlace({
    Key? key,
    required this.placeController,
    required this.showMandatoryFieldMessage,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VenuePlaceState createState() => _VenuePlaceState();
}

class _VenuePlaceState extends State<VenuePlace> {
  int maxCharacters = 100;

  @override
  void initState() {
    super.initState();
    widget.placeController.addListener(updateCounter);
  }

  void updateCounter() {
    setState(() {
      maxCharacters = 100 - widget.placeController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: widget.placeController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {},
                  validator: (value) {
                    if (widget.showMandatoryFieldMessage && value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (value!.length < 100) {
                      return 'Minimum 100 characters required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter the location',
                      hintStyle: const TextStyle(color: Colors.white70),
                      labelText: 'Venue',
                      labelStyle: const TextStyle(color: Colors.white),
                      errorText: widget.showMandatoryFieldMessage &&
                              widget.placeController.text.isEmpty
                          ? 'This field is required'
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      counterText: '$maxCharacters / 100',
                      counterStyle: const TextStyle(color: Colors.white)),
                  maxLength: 100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.placeController.removeListener(updateCounter);
    super.dispose();
  }
}
