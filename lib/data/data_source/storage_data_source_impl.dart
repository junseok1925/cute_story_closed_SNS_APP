import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'storage_data_source.dart';

class StorageDataSourceImpl implements StorageDataSource {
  final FirebaseStorage storage;

  StorageDataSourceImpl(this.storage);

  @override
  Future<String> uploadFile(File file, String path) async {
    final ref = storage.ref().child(path);

    await ref.putFile(file);

    final url = await ref.getDownloadURL();
    return url;
  }
}
