import 'package:flutter/material.dart';

import '../../utils/app_utils/app_strings.dart';
import '../../../core/heplers/validation_form.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: ValidationForm.nameValidator,
      keyboardType: TextInputType.text,
      minLines: 5,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: AppStrings.description,
      ),
    );
  }
}
