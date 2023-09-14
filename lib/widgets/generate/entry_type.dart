import 'package:flutter/material.dart';

class EntryTypeDropdown extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String?>? onChanged;

  const EntryTypeDropdown({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

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
                child: DropdownButtonFormField<String>(
                  value: controller.text.isEmpty ? null : controller.text,
                  onChanged: onChanged,
                  items: ['VIP', 'Guest', 'Member']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return ['VIP', 'Guest', 'Member']
                        .map<Widget>((String item) {
                      return Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white, 
                        ),
                      );
                    }).toList();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an entry type';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
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
