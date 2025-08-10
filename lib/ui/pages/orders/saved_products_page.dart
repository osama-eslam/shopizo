import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker_demo/core/shared_prefs_helper.dart';
import 'package:image_picker_demo/ui/pages/delivery/delivery_map_page.dart';
import 'package:image_picker_demo/utils/shipping_centers.dart';
import 'package:latlong2/latlong.dart';

class SavedProductsPage extends StatefulWidget {
  @override
  _SavedProductsPageState createState() => _SavedProductsPageState();
}

class _SavedProductsPageState extends State<SavedProductsPage> {
  List<dynamic> orderList = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    String? ordersJson = await SharedPrefsHelper.getString("order_list");
    if (ordersJson != null && ordersJson.isNotEmpty) {
      List<dynamic> orders = jsonDecode(ordersJson);
      setState(() {
        orderList = orders;
      });
    }
  }

  Future<void> _deleteOrder(int index) async {
    orderList.removeAt(index);
    await SharedPrefsHelper.setString("order_list", jsonEncode(orderList));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("saved_orders".tr)),
      body:
          orderList.isEmpty
              ? Center(child: Text("no_saved_orders".tr))
              : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  final order = orderList[index];
                  final createdAt = order['created_at'] ?? '';
                  final loc = order['customer_location'];
                  final endPoint =
                      (loc != null &&
                              loc['latitude'] != null &&
                              loc['longitude'] != null)
                          ? LatLng(loc['latitude'], loc['longitude'])
                          : LatLng(30.0500, 31.2400);
                  final deliveryPoint = endPoint;

                  final nearestCenter = findNearestShippingCenter(
                    deliveryPoint,
                    shippingCenters,
                  );

                  final customerName = order['customer_name'] ?? "no_name".tr;
                  final customerPhone = order['customer_phone'] ?? "";
                  final products = order['products'] as List<dynamic>? ?? [];
                  final total = order['total'] ?? 0;

                  final deliveryStatus =
                      products.isNotEmpty ? products[0]['status'] ?? "" : "";

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DeliveryMapPage(
                                orderIndex: index,
                                startPoint: nearestCenter,
                                endPoint: deliveryPoint,
                                orderDate: createdAt,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[50],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                customerName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                customerPhone,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          deliveryStatus == "in_delivery".tr
                                              ? Colors.orange[100]
                                              : Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      deliveryStatus,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color:
                                            deliveryStatus == "in_delivery".tr
                                                ? Colors.orange[800]
                                                : Colors.green[800],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    tooltip: "delete_order".tr,
                                    onPressed: () async {
                                      bool confirm = await showDialog(
                                        context: context,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: Text("confirm_delete".tr),
                                              content: Text(
                                                "confirm_delete_msg".tr,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        ctx,
                                                      ).pop(false),
                                                  child: Text("cancel".tr),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        ctx,
                                                      ).pop(true),
                                                  child: Text("delete".tr),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (confirm) {
                                        await _deleteOrder(index);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text("order_deleted".tr),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "products_label".tr,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children:
                                  products.map<Widget>((p) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${p['title']} x${p['quantity']}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${"total_label".tr} \$${total.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
