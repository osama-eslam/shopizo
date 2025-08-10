import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker_demo/ui/widgets/delivery_status_bar.dart';
import 'package:image_picker_demo/ui/widgets/mini_map_preview.dart';
import 'package:image_picker_demo/ui/widgets/order_details_section.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'full_screen_map_page.dart';

class DeliveryMapPage extends StatefulWidget {
  final LatLng startPoint;
  final LatLng endPoint;
  final String? orderDate;
  final int orderIndex;

  const DeliveryMapPage({
    Key? key,
    required this.startPoint,
    required this.endPoint,
    this.orderDate,
    required this.orderIndex,
  }) : super(key: key);

  @override
  _DeliveryMapPageState createState() => _DeliveryMapPageState();
}

class _DeliveryMapPageState extends State<DeliveryMapPage> {
  late final List<LatLng> pathPoints;
  int currentIndex = 0;
  Timer? timer;

  String orderStatus = "preparing";
  static const int exitDuration = 1203;
  static const int deliveryDuration = 1803;
  late DateTime startExitTime;
  bool deliveredPermanently = false;

  @override
  void initState() {
    super.initState();

    pathPoints = _generateStraightPath(widget.startPoint, widget.endPoint);

    _loadSavedState().then((restored) {
      if (!restored) {
        startExitTime = DateTime.now();
        _saveState();
        _startTimers();
      }
    });
  }

  Future<bool> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString("delivery_state_${widget.orderIndex}");
    deliveredPermanently =
        prefs.getBool("order_${widget.orderIndex}_delivered_permanent") ??
        false;

    if (deliveredPermanently) {
      setState(() {
        orderStatus = "delivered";
        currentIndex = pathPoints.length - 1;
      });
      return true;
    }

    if (jsonString == null) return false;

    try {
      Map<String, dynamic> state = jsonDecode(jsonString);
      orderStatus = state['orderStatus'] ?? "preparing";
      currentIndex = state['currentIndex'] ?? 0;
      String startExitTimeString = state['startExitTime'] ?? "";

      if (startExitTimeString.isEmpty) {
        startExitTime = DateTime.now();
      } else {
        startExitTime = DateTime.parse(startExitTimeString);
      }

      final elapsed = DateTime.now().difference(startExitTime).inSeconds;

      if (elapsed < exitDuration) {
        orderStatus = "preparing";
        currentIndex = 0;
        _startTimers(delay: exitDuration - elapsed);
      } else if (elapsed < exitDuration + deliveryDuration) {
        orderStatus = "in_delivery";
        int timeInDelivery = elapsed - exitDuration;
        int totalSteps = pathPoints.length - 1;
        int step = ((timeInDelivery / deliveryDuration) * totalSteps).floor();
        if (step > totalSteps) step = totalSteps;
        currentIndex = step;
        _startTimers(delay: deliveryDuration - timeInDelivery);
      } else {
        orderStatus = "delivered";
        currentIndex = pathPoints.length - 1;
        _markOrderAsDeliveredPermanently();
      }

      setState(() {});
      return true;
    } catch (e) {
      print("Error loading saved state: $e");
      return false;
    }
  }

  void _startTimers({int delay = exitDuration}) {
    if (orderStatus == "preparing") {
      Timer(Duration(seconds: delay), () {
        setState(() {
          orderStatus = "in_delivery";
          currentIndex = 0;
        });
        _saveState();
        _startDeliveryTimer();
      });
    } else if (orderStatus == "in_delivery") {
      _startDeliveryTimer(delay: delay);
    }
  }

  void _startDeliveryTimer({int delay = -1}) {
    timer?.cancel();

    int steps = pathPoints.length - 1;
    int durationMs = deliveryDuration * 1000;
    if (delay >= 0) {
      durationMs = delay * 1000;
    }
    int stepDuration = durationMs ~/ steps;

    timer = Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (currentIndex < pathPoints.length - 1) {
          currentIndex++;
          _saveState();
        } else {
          orderStatus = "delivered";
          _saveState();
          _markOrderAsDeliveredPermanently();
          timer.cancel();
        }
      });
    });
  }

  Future<void> _markOrderAsDeliveredPermanently() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("order_${widget.orderIndex}_delivered_permanent", true);
    deliveredPermanently = true;
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> state = {
      "orderStatus": orderStatus,
      "currentIndex": currentIndex,
      "startExitTime": startExitTime.toIso8601String(),
    };
    await prefs.setString(
      "delivery_state_${widget.orderIndex}",
      jsonEncode(state),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<LatLng> _generateStraightPath(LatLng start, LatLng end) {
    return [start, end];
  }

  @override
  Widget build(BuildContext context) {
    LatLng carPosition = pathPoints[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('delivery_map'.tr),
        actions: [DeliveryStatusBar(orderStatus: orderStatus)],
      ),
      body: Column(
        children: [
          MiniMapPreview(
            startPoint: widget.startPoint,
            endPoint: widget.endPoint,
            pathPoints: pathPoints,
            carPosition: carPosition,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => FullScreenMapPage(
                        startPoint: widget.startPoint,
                        endPoint: widget.endPoint,
                        pathPoints: pathPoints,
                        carPosition: carPosition,
                      ),
                ),
              );
            },
          ),
          Expanded(
            child: OrderDetailsSection(
              orderDate: widget.orderDate,
              orderStatus: orderStatus,
            ),
          ),
        ],
      ),
    );
  }
}
