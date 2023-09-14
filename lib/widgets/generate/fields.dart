import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldsSection extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController numberOfMembersController;
  final bool showMandatoryFieldMessage;

  const InputFieldsSection({
    Key? key,
    required this.userNameController,
    required this.numberOfMembersController,
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
              const Icon(Icons.person, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: userNameController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: const TextStyle(color: Colors.white70),
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.white),
                    errorText: showMandatoryFieldMessage &&
                            userNameController.text.isEmpty
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
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              const Icon(Icons.group, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: numberOfMembersController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {},
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Number of Members',
                    hintStyle: const TextStyle(color: Colors.white70),
                    labelText: 'Members',
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    errorText: showMandatoryFieldMessage
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
            ],
          ),
        ],
      ),
    );
  }
}
