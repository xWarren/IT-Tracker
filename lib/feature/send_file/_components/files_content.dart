import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilesContent extends StatefulWidget {
  const FilesContent({super.key});
  
  @override
  State<FilesContent> createState() => _FilesContentState();
}

class _FilesContentState extends State<FilesContent> {

  List<PlatformFile> documents = [];

  Future<void> pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        documents = result.files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return ListTile(
          title: Text(doc.name),
          subtitle: Text("${doc.size ~/ 1024} KB"),
        );
      },
    );
  }
}
