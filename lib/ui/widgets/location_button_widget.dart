import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationButtonWidget extends StatelessWidget {
  final bool isLoadingLocation;
  final String? currentAddress;
  final VoidCallback onPressed;

  const LocationButtonWidget({
    super.key,
    required this.isLoadingLocation,
    required this.currentAddress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      icon:
          isLoadingLocation
              ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
              : const Icon(Icons.my_location),
      label: Text(
        isLoadingLocation
            ? "loading_location".tr
            : (currentAddress != null
                ? "location_obtained".tr
                : "get_current_location".tr),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            currentAddress != null ? Colors.green : colorScheme.secondary,
        foregroundColor:
            currentAddress != null ? Colors.white : colorScheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 48),
      ),
      onPressed: isLoadingLocation ? null : onPressed,
    );
  }
}
