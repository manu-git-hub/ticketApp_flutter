import 'package:flutter/material.dart';

class TimePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool showMandatoryFieldMessage;

  const TimePickerField({
    Key? key,
    required this.label,
    required this.controller,
    required this.showMandatoryFieldMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.lock_clock, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      // ignore: use_build_context_synchronously
                      controller.text = selectedTime.format(context);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Select $label',
                    hintStyle: const TextStyle(color: Colors.white70),
                    errorText:
                        showMandatoryFieldMessage && controller.text.isEmpty
                            ? 'This field is required'
                            : null,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
