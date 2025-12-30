import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/resources/colors.dart';
import '../../../core/resources/dimensions.dart';
import '../../../core/resources/keys.dart';

class AppsContent extends StatefulWidget {

  const AppsContent({
    super.key, 
    required this.appCallBack,
    required this.scrollController
  });

  final Function(bool isSelected) appCallBack;
  final ScrollController scrollController;

  @override
  State<AppsContent> createState() => _AppsContentState();
}

class _AppsContentState extends State<AppsContent> {

  static final platform = const MethodChannel(Keys.installedAppsKey);

  List<Map<String, dynamic>> _apps = [];

  final Set<String> _selectedPackages = {};

  @override
  void initState() {
    super.initState();
    loadApps();
  }

  Future<void> loadApps() async {
    try {
      final List<dynamic> result =
      await platform.invokeMethod(Keys.getInstalledAppsKey);

      setState(() {
        _apps = result.cast<Map>().map((e) => Map<String, dynamic>.from(e)).where((app) => app['isSendable'] == true).toList();
      });
    } catch (e) {
      debugPrint("Error fetching apps: $e");
    }
  }

  void _toggleSelection(String packageName) {
    setState(() {
      if (_selectedPackages.contains(packageName)) {
        _selectedPackages.remove(packageName);
      } else {
        _selectedPackages.add(packageName);
      }

      if (_selectedPackages.isEmpty) {
        widget.appCallBack(false);
      } else {
        widget.appCallBack(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.spacingLarge),
          const Text(
            "Installed Apps",
            style: TextStyle(
              color: CustomColors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.w500
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: widget.scrollController,
              itemCount: _apps.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .75,
              ),
              itemBuilder: (context, index) {
                final app = _apps[index];
                final String packageName = app['packageName'];
                final bool isSelected = _selectedPackages.contains(packageName);
                final Uint8List iconBytes = Uint8List.fromList(List<int>.from(app['icon']));
                return GestureDetector(
                  onTap: () => _toggleSelection(packageName),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.memory(
                            iconBytes,
                            width: 48,
                            height: 48,
                            fit: BoxFit.fill,
                          ),
                          if (isSelected)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: CustomColors.primary,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: CustomColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.spacingExtraSmall),
                      Text(
                        app['appName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? CustomColors.primary : CustomColors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600
                        )
                      ),
                      Text(
                        "${app['appSizeMB']} mb",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CustomColors.gray,
                          fontSize: 9.0,
                          fontWeight: FontWeight.w500
                        )
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 100.0)
        ],
      ),
    );
  }
}
