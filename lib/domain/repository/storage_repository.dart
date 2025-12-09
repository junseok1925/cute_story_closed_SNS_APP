import 'dart:io';

abstract interface class StorageRepository {
  Future<String> uploadFile(File file, String path);
}
