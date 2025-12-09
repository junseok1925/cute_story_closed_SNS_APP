import 'dart:io';

abstract interface class StorageDataSource {
  Future<String> uploadFile(File file, String path);
}
