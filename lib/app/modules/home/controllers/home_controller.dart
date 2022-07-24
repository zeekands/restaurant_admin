import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/Menu.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('menu');
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  final image = XFile("").obs;

  final selectedValueIndex = 0.obs;
  final buttonText = ["Pulsa", "Data", "Game"];
  final iconButton = [
    "assets/images/ic_makanan.png",
    "assets/images/ic_kuah.png",
    "assets/images/ic_minuman.png"
  ];

  final formatter = NumberFormat.decimalPattern('en_us');

  String currency(double value) {
    return formatter.format(value);
  }

  Stream<List<Menu>> readMenu(String jenis) => FirebaseFirestore.instance
      .collection('menu')
      .where('jenis', isEqualTo: jenis)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Menu.fromJson(doc.data())).toList());
  @override
  void onInit() async {
    super.onInit();
    FlutterNativeSplash.remove();
  }

  Future getImage(bool gallery, XFile image) async {
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
      image = pickedFile;
    }
  }

  Future<String> uploadFile(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('Menus/${image.path}');
    await storageReference.putFile(image);
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> updateMenuWithImage(
    String id,
    String nama,
    int harga,
    String jenis,
    File images,
  ) async {
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": imageURL,
    };
    refDoc.set(data);
  }

  Future<void> updateMenu(
      String id, String nama, int harga, String jenis, String image) async {
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "harga": harga,
      "jenis": jenis,
      "images": image,
    };
    refDoc.set(data);
  }

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    refDoc.delete();
  }
}
