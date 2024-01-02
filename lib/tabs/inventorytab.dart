import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Center(
      child: Container(
        width: 200,
        height: 200,

      ),
    );
  }
}

