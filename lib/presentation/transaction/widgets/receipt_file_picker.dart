import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

class ReceipFilePicker extends StatefulWidget {
  const ReceipFilePicker({super.key});

  @override
  State<ReceipFilePicker> createState() => _ReceipFilePickerState();
}

class _ReceipFilePickerState extends State<ReceipFilePicker> {
  XFile? documentFile;

  Future<void> _openDocumentFile() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'documents',
      extensions: <String>['jpg', 'png', 'pdf'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );

    if (file == null) {
      return;
    }

    setState(() {
      documentFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: (value) {
        return null;
      },
      builder: (fieldState) {
        return Row(
          children: [
            OutlinedButton.icon(
              label: const Text('Adicionar recibo'),
              icon: const Icon(Icons.attach_file),
              onPressed: _openDocumentFile,
            ),
            SizedBox(width: 12),
            if (documentFile != null && documentFile!.name.isNotEmpty)
              Expanded(child: Text(documentFile!.name)),
          ],
        );
      },
    );
  }
}
