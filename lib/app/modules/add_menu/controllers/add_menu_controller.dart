import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddMenuController extends GetxController {
  final image = XFile("").obs;

  CollectionReference ref = FirebaseFirestore.instance.collection('menu');
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  final selectJenis = [
    "Snack",
    "Kuah",
    "Minuman",
  ];

  final selectedJenis = "Snack".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }

    if (pickedFile != null) {
      image.value = pickedFile;
    }
  }

  Future<String> uploadFile(File _image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('Menus/${_image.path}');
    await storageReference.putFile(_image);
    print('File Uploaded');
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> saveImages(
    File _images,
    String nama,
    int harga,
    String jenis,
  ) async {
    String imageURL = await uploadFile(_images);
    final refDoc = ref.doc();
    final data = {
      "id": refDoc.id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": imageURL
    };
    refDoc.set(data);
  }

  Future<void> editMenu(
    String id,
    String nama,
    int harga,
    String jenis,
    File _images,
  ) async {
    String imageURL = await uploadFile(_images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": imageURL
    };
    refDoc.set(data);
  }
}
