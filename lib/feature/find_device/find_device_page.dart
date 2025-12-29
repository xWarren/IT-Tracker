import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../core/common/common_appbar.dart';
import '../../core/common/common_elevated_button.dart';
import '../../core/resources/dimensions.dart';

class FindDevicePage extends StatefulWidget {
  const FindDevicePage({super.key});

  @override
  State<FindDevicePage> createState() => _FindDevicePageState();
}

class _FindDevicePageState extends State<FindDevicePage> {


  @override
  void initState() {
    _startScan();
    super.initState();
  }

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  void _startScan() async {
    if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.on) {
      FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
        androidUsesFineLocation: true
      );
    }
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(textTitle: "Find Device"),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.scanResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final results = snapshot.data!;

          if (results.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: Dimensions.spacingMedium,
              children: [
                const Center(
                  child: Text("No devices found"),
                ),
                CommonElevatedButton(
                  onButtonPressed: () {
                    _stopScan();
                    _startScan();
                  },
                  text: "Re-scan again",
                )
              ],
            );
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              final device = result.device;

              return ListTile(
                leading: const Icon(Icons.bluetooth),
                title: Text(
                  device.name.isNotEmpty
                      ? device.name
                      : "Unknown Device",
                ),
                subtitle: Text(device.id.id),
                trailing: Text(
                  "${result.rssi} dBm",
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () {
                  // You can connect here if needed
                  // device.connect();
                },
              );
            },
          );
        },
      ),
    );
  }
}