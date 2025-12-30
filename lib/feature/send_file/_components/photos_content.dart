import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../core/resources/colors.dart';

class PhotosContent extends StatefulWidget {

  const PhotosContent({
    super.key, 
    required this.photosCallBack,
    required this.scrollController
  });

  final Function(bool isSelected) photosCallBack;
  final ScrollController scrollController;

  @override
  State<PhotosContent> createState() => _PhotosContentState();
}

class _PhotosContentState extends State<PhotosContent> {

  List<AssetEntity> images = [];
  final Set<String> selectedIds = {};

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() => isLoading = true);

    final permission = await PhotoManager.requestPermissionExtend();

    log(
      "isAuth=${permission.isAuth}, "
      "hasAccess=${permission.hasAccess}, "
      "isLimited=${permission.isLimited}"
    );

    if (!permission.hasAccess) {
      await PhotoManager.openSetting();
      setState(() => isLoading = false);
      return;
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    final album = albums.first;

    final assets = await album.getAssetListPaged(
      page: 0,
      size: 200,
    );

    setState(() {
      images = assets;
      isLoading = false;
    });

    log("Loaded images: ${images.length}");
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (selectedIds.contains(asset.id)) {
        selectedIds.remove(asset.id);
      } else {
        selectedIds.add(asset.id);
      }
    });

    if (selectedIds.isEmpty) {
       widget.photosCallBack(false);
    } else {
       widget.photosCallBack(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 110.0),
      child: GridView.builder(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final asset = images[index];
          final isSelected = selectedIds.contains(asset.id);
          return GestureDetector(
            onTap: () => _toggleSelection(asset),
            child: _Thumbnail(
              asset: asset,
              isSelected: isSelected
            )
          );
        },
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.asset,
    required this.isSelected
  });

  final AssetEntity asset;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(
            const ThumbnailSize(250, 250),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.fill,
                height: 120.0,
                width: 120.0,
                
              );
            }
            return Container(
              color: Colors.grey.shade300,
            );
          },
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
    );
  }
}