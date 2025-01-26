import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String fileName) async {
    final ref = _storage.ref().child('images/$fileName');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
