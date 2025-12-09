import 'dart:io';
import 'package:cute_story_closed_sns_app/data/data_source/storage_data_source.dart';
import 'package:cute_story_closed_sns_app/domain/repository/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final StorageDataSource dataSource;

  StorageRepositoryImpl(this.dataSource);

  @override
  Future<String> uploadFile(File file, String path) {
    return dataSource.uploadFile(file, path);
  }
}
