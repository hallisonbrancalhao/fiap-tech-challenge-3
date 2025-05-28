import 'dart:io';

class UploadTransactionAttachmentParams {
  final String transactionId;
  final File imageFile;

  UploadTransactionAttachmentParams({
    required this.transactionId,
    required this.imageFile,
  });
}
