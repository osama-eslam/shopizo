import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:image_picker_demo/ui/pages/categories/category_card.dart';

import '../../core/shared_prefs_helper.dart';
import '../../ui/pages/home/home page.dart';

class PlaceOrderButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController altPhoneController;
  final List<CartItem> cartItems;
  final double total;
  final Position? currentPosition;
  final String? currentAddress;

  const PlaceOrderButtonWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.altPhoneController,
    required this.cartItems,
    required this.total,
    required this.currentPosition,
    required this.currentAddress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (currentPosition == null || currentAddress == null) {
              Get.snackbar(
                'error'.tr,
                'please_get_location'.tr,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
              return;
            }

            await SharedPrefsHelper.setString(
              "customer_name",
              nameController.text.trim(),
            );
            await SharedPrefsHelper.setString(
              "customer_phone",
              phoneController.text.trim(),
            );
            await SharedPrefsHelper.setString(
              "customer_alt_phone",
              altPhoneController.text.trim(),
            );

            await SharedPrefsHelper.setString(
              "customer_location",
              jsonEncode({
                "latitude": currentPosition!.latitude,
                "longitude": currentPosition!.longitude,
              }),
            );

            final productsData =
                cartItems.map((item) {
                  return {
                    "title": item.title,
                    "price": item.price,
                    "quantity": item.quantity,
                    "status": "in_delivery".tr,
                  };
                }).toList();

            String? existingOrdersJson = await SharedPrefsHelper.getString(
              "order_list",
            );
            List<dynamic> existingOrders = [];
            if (existingOrdersJson != null) {
              existingOrders = jsonDecode(existingOrdersJson);
            }

            existingOrders.add({
              "customer_name": nameController.text.trim(),
              "customer_phone": phoneController.text.trim(),
              "customer_alt_phone": altPhoneController.text.trim(),
              "customer_address": currentAddress,
              "customer_location": {
                "latitude": currentPosition!.latitude,
                "longitude": currentPosition!.longitude,
              },
              "products": productsData,
              "total": total,
              "created_at": DateTime.now().toIso8601String(),
            });

            await SharedPrefsHelper.setString(
              "order_list",
              jsonEncode(existingOrders),
            );

            await CartService().clearCart();

            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'success'.tr,
                message: 'order_success'.tr,
                contentType: ContentType.success,
              ),
            );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              await Future.delayed(const Duration(seconds: 2));
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const Homepage()),
                (Route<dynamic> route) => false,
              );
            }
          } else {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'error'.tr,
                message: 'fill_required'.tr,
                contentType: ContentType.failure,
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Text("place_order".tr),
      ),
    );
  }
}
