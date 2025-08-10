import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsSection extends StatelessWidget {
  final String? orderDate;
  final String orderStatus;

  const OrderDetailsSection({
    Key? key,
    this.orderDate,
    required this.orderStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'order_details'.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.date_range, color: Colors.indigo),
                title: Text(
                  'order_date'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(orderDate ?? 'not_available'.tr),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  orderStatus == "delivered"
                      ? Icons.check_circle
                      : orderStatus == "in_delivery"
                      ? Icons.local_shipping
                      : Icons.schedule,
                  color:
                      orderStatus == "delivered"
                          ? Colors.green
                          : orderStatus == "in_delivery"
                          ? Colors.orange
                          : Colors.grey,
                ),
                title: Text(
                  'order_status'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  (orderStatus[0].toUpperCase() +
                          orderStatus.substring(1).replaceAll('_', ' '))
                      .tr,
                  style: TextStyle(
                    color:
                        orderStatus == "delivered"
                            ? Colors.green
                            : orderStatus == "in_delivery"
                            ? Colors.orange
                            : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'products'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blue.shade700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    _productRow('product_1'.tr, 2),
                    Divider(),
                    _productRow('product_2'.tr, 1),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'additional_info'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'delivery_success_message'.tr,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productRow(String productName, int quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.shopping_bag, color: Colors.deepPurple),
            const SizedBox(width: 8),
            Text(
              productName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          'quantity_x'.tr + quantity.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }
}
