import 'package:dartz/dartz.dart';
import 'package:tech_challenge_3/core/usecase/usecase.dart';
import 'package:tech_challenge_3/data/models/upload_attachment_params.dart';
import 'package:tech_challenge_3/domain/repository/transactions_repository.dart';
import 'package:tech_challenge_3/service_locator.dart';

class UploadTransactionAttachmentUseCase
    implements
        UseCase<Either<String, String>, UploadTransactionAttachmentParams> {
  @override
  Future<Either<String, String>> call({
    UploadTransactionAttachmentParams? param,
  }) async {
    if (param == null) {
      return Left('No parameters provided');
    }
    return await sl<TransactionsRepository>().uploadAttachment(
      param.transactionId,
      param.imageFile,
    );
  }
}
