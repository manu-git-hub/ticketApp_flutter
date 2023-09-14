// ignore_for_file: unrelated_type_equality_checks, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController dateController;
  final bool showMandatoryFieldMessage;

  const DatePicker({
    Key? key,
    required this.dateController,
    required this.showMandatoryFieldMessage,
  }) : super(key: key);

  @override
  
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );


    if (picked != null && picked != widget.dateController) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        widget.dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: widget.dateController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (val) {},
                      decoration: InputDecoration(
                        hintText: 'Venue Date',
                        hintStyle: const TextStyle(color: Colors.white70),
                        labelText: 'Date ',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        errorText: widget.showMandatoryFieldMessage &&
                                widget.dateController.text.isEmpty
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
                      ),
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
