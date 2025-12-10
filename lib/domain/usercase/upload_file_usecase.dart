import 'dart:io';
import 'package:cute_story_closed_sns_app/domain/repository/storage_repository.dart';

class UploadFileUseCase {
  final StorageRepository repository;

  UploadFileUseCase(this.repository);

  Future<String> call(File file, String path) {
    return repository.uploadFile(file, path);
  }
}
