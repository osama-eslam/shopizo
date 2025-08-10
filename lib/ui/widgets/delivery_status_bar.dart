import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryStatusBar extends StatelessWidget {
  final String orderStatus;

  const DeliveryStatusBar({Key? key, required this.orderStatus})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (orderStatus == "in_delivery") {
      statusColor = Colors.orange;
    } else if (orderStatus == "delivered") {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.grey[700]!;
    }

    String displayText =
        (orderStatus[0].toUpperCase() +
                orderStatus.substring(1).replaceAll('_', ' '))
            .tr;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Text(
          displayText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: statusColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
