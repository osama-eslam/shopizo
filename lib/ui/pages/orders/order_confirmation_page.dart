import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker_demo/core/shared_prefs_helper.dart';
import 'package:image_picker_demo/ui/pages/categories/category_card.dart';
import 'package:image_picker_demo/ui/widgets/customer_details_form_widget.dart';
import 'package:image_picker_demo/ui/widgets/location_button_widget.dart';
import 'package:image_picker_demo/ui/widgets/order_summary_widget.dart';
import 'package:image_picker_demo/ui/widgets/place_order_button_widget.dart';

class OrderConfirmationPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const OrderConfirmationPage({super.key, required this.cartItems});

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final altPhoneController = TextEditingController();

  Position? currentPosition;
  String? currentAddress;
  bool isLoadingLocation = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoadingLocation = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('error'.tr, 'location_services_disabled'.tr);
      setState(() {
        isLoadingLocation = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('error'.tr, 'location_permissions_denied'.tr);
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('error'.tr, 'location_permissions_permanently_denied'.tr);
      setState(() {
        isLoadingLocation = false;
      });
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        currentAddress =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

        await SharedPrefsHelper.setString("customer_address", currentAddress!);

        Get.snackbar(
          'success'.tr,
          '${'address_obtained_successfully'.tr}:\n$currentAddress',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        currentAddress = "unknown_address".tr;
      }
    } catch (e) {
      currentAddress = "error_getting_address".tr;
      Get.snackbar('error'.tr, 'failed_get_address_from_location'.tr);
    }

    setState(() {
      isLoadingLocation = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    altPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double total = widget.cartItems.fold(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("confirm_order".tr),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderSummaryWidget(cartItems: widget.cartItems),
            const SizedBox(height: 30),
            CustomerDetailsFormWidget(
              nameController: nameController,
              phoneController: phoneController,
              altPhoneController: altPhoneController,
              formKey: _formKey,
            ),
            const SizedBox(height: 30),
            LocationButtonWidget(
              isLoadingLocation: isLoadingLocation,
              currentAddress: currentAddress,
              onPressed: _getCurrentLocation,
            ),
            const SizedBox(height: 30),
            PlaceOrderButtonWidget(
              formKey: _formKey,
              nameController: nameController,
              phoneController: phoneController,
              altPhoneController: altPhoneController,
              cartItems: widget.cartItems,
              total: total,
              currentPosition: currentPosition,
              currentAddress: currentAddress,
            ),
          ],
        ),
      ),
    );
  }
}
