import 'package:flutter/material.dart';

class VideosContent extends StatefulWidget {

  const VideosContent({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<VideosContent> createState() => _VideosContentState();
}

class _VideosContentState extends State<VideosContent> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
