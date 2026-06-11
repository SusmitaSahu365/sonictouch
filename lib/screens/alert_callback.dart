import 'package:flutter/material.dart';

typedef AlertCallback = void Function(String label, Color color);

AlertCallback? onAlertDetected;
