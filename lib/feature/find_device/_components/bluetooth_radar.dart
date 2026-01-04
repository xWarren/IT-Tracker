import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/resources/colors.dart';

class BluetoothRadar extends StatefulWidget {
  final int deviceCount;

  const BluetoothRadar({
    super.key,
    required this.deviceCount,
  });

  @override
  State<BluetoothRadar> createState() => _BluetoothRadarState();
}

class _BluetoothRadarState extends State<BluetoothRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 230.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (_, _) {
                final progress = (_controller.value + index / 8) % 2.0;

                return Container(
                  width: size * progress,
                  height: size * progress,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.primary.withValues(alpha: 1 - progress),
                      width: 20.0,
                    ),
                  ),
                );
              },
            );
          }),

          Container(
            width: size * 0.65,
            height: size * 0.65,
            decoration: const BoxDecoration(
              color: Colors.indigo,
              shape: BoxShape.circle,
            ),
          ),

          /// ================= Center Icon =================
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bluetooth,
              size: 48,
              color: Colors.indigo,
            ),
          ),

          ...List.generate(widget.deviceCount, (index) {
            final angle = (2 * pi / max(widget.deviceCount, 1)) * index;
            final radius = size / 2.1;

            return Positioned(
              left: size / 2 + radius * cos(angle) - 16,
              top: size / 2 + radius * sin(angle) - 16,
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
