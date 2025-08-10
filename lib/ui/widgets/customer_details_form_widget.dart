import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ui/widgets/custom_text_form_field.dart';

class CustomerDetailsFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController altPhoneController;
  final GlobalKey<FormState> formKey;

  const CustomerDetailsFormWidget({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.altPhoneController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "customer_details".tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          CustomTextFormField(
            controller: nameController,
            label: "name_required".tr,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "name_required".tr;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextFormField(
            controller: phoneController,
            label: "phone_number".tr,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "phone_required".tr;
              }
              if (!RegExp(r'^\d{10,}$').hasMatch(value)) {
                return "valid_phone".tr;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextFormField(
            controller: altPhoneController,
            label: "alt_phone".tr,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}
