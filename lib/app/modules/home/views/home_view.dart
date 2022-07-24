import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_admin/app/data/Menu.dart';
import 'package:restaurant_admin/app/routes/app_pages.dart';
import 'package:restaurant_admin/app/utils/custom_colors.dart';
import 'package:restaurant_admin/app/utils/rounded_textfield.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_MENU);
        },
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: AppBar(
          flexibleSpace: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //search bar
              children: [
                Text(
                  "Easy Topup",
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ).paddingOnly(right: 10.w),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(
                        ScreenUtil().setWidth(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 18.r,
                            color: Colors.grey[500],
                          ),
                          20.horizontalSpace,
                          Text(
                            "Search",
                            style: TextStyle(fontSize: 12.sp),
                          )
                        ],
                      ).paddingAll(10.r),
                    ),
                  ).paddingOnly(right: 10.w),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.pending_actions_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.ORDERS);
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 10.w, vertical: 10.h),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          20.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pilih Menu Disini",
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
              IconButton(
                  onPressed: () {
                    Get.bottomSheet(Container(
                      height: 0.5.sh,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/app_logo.png',
                            height: 200.h,
                            width: 300.w,
                            fit: BoxFit.cover,
                          ),
                          20.verticalSpace,
                          Text(
                            "Terimakasih telah menggunakan Easy Topup\nJika ada pertanyaan atau keluhan silahkan \nhubungi 089620494008 Gerall",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[400],
                              fontSize: 16.sp,
                            ),
                          )
                        ],
                      ),
                    ));
                  },
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.red,
                  )),
            ],
          ),
          Row(
            children: [
              ...List.generate(
                controller.buttonText.length,
                (index) => button(
                  index: index,
                  text: controller.buttonText[index],
                  image: controller.iconButton[index],
                ).paddingOnly(right: 10.w),
              )
            ],
          ).paddingSymmetric(vertical: 10.h),
          10.verticalSpace,
          Flexible(
            child: Obx(
              () => StreamBuilder<List<Menu>>(
                  stream: controller.readMenu(controller
                      .buttonText[controller.selectedValueIndex.value]),
                  builder: (context, snapshot) {
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 10.h,
                        crossAxisSpacing: 10.h,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (_, index) => GestureDetector(
                        onTap: () {
                          final image = XFile("").obs;
                          final namaController = TextEditingController();
                          final hargaController = TextEditingController();
                          namaController.text = snapshot.data![index].nama;
                          hargaController.text =
                              snapshot.data![index].harga.toString();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Obx(
                              () => Container(
                                height: 0.7.sh,
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(10),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Edit Menu",
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w500)),
                                          IconButton(
                                              onPressed: () => Get.back(),
                                              icon: Icon(
                                                Icons.close,
                                                size: 16.sp,
                                                color: Colors.grey[500],
                                              )),
                                        ],
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            ScreenUtil().setWidth(10),
                                          ),
                                        ),
                                        child: image.value.path == ""
                                            ? CachedNetworkImage(
                                                imageUrl: snapshot
                                                        .data?[index].images ??
                                                    "",
                                                width: 1.sw,
                                                height: 200.h,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(image.value.path),
                                                width: 1.sw,
                                                height: 200.h,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      10.verticalSpace,
                                      ElevatedButton(
                                          onPressed: () async {
                                            ImagePicker picker = ImagePicker();
                                            final pickedFile =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (pickedFile != null) {
                                              image.value = pickedFile;
                                            }
                                          },
                                          child: const Text("Edit Foto")),
                                      20.verticalSpace,
                                      Text(
                                        "Nama Menu",
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                        ),
                                      ),
                                      10.verticalSpace,
                                      RoundedInputField(
                                        textEditingController: namaController,
                                        hintText: snapshot.data?[index].nama
                                            .toString(),
                                      ),
                                      15.verticalSpace,
                                      Text(
                                        "Harga",
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(12),
                                        ),
                                      ),
                                      10.verticalSpace,
                                      RoundedInputField(
                                        keyboardType: TextInputType.number,
                                        textEditingController: hargaController,
                                        hintText: snapshot.data?[index].harga
                                            .toString(),
                                      ),
                                      30.verticalSpace,
                                      Row(
                                        children: [
                                          Flexible(
                                            child: SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(40),
                                              width: 0.5.sw,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  controller.deleteMenu(
                                                      snapshot.data![index].id);
                                                  Get.back();
                                                  Get.snackbar(
                                                    "Hapus Berhasil",
                                                    "Data Telah Berhasil Dihapus",
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    backgroundColor:
                                                        Colors.green,
                                                    colorText: Colors.white,
                                                  );
                                                },
                                                child: const Text('Hapus Menu'),
                                              ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          Flexible(
                                            child: SizedBox(
                                              height:
                                                  ScreenUtil().setHeight(40),
                                              width: 0.5.sw,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: deepBlue,
                                                ),
                                                onPressed: () async {
                                                  if (image
                                                      .value.path.isNotEmpty) {
                                                    await controller
                                                        .updateMenuWithImage(
                                                      snapshot.data![index].id,
                                                      namaController.text,
                                                      int.parse(
                                                          hargaController.text),
                                                      snapshot
                                                          .data![index].jenis,
                                                      File(image.value.path),
                                                    );
                                                  } else {
                                                    await controller.updateMenu(
                                                      snapshot.data![index].id,
                                                      namaController.text,
                                                      int.parse(
                                                          hargaController.text),
                                                      snapshot
                                                          .data![index].jenis,
                                                      snapshot
                                                          .data![index].images,
                                                    );
                                                  }
                                                  Get.back();
                                                  Get.snackbar(
                                                    "Edit Berhasil",
                                                    "Data Telah Berhasil Diedit",
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    backgroundColor:
                                                        Colors.green,
                                                    colorText: Colors.white,
                                                  );
                                                },
                                                child:
                                                    const Text('Simpan Menu'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).paddingSymmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              ScreenUtil().setWidth(10),
                            ),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1.h,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    ScreenUtil().setWidth(10),
                                  ),
                                  topRight: Radius.circular(
                                    ScreenUtil().setWidth(10),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data?[index].images ?? "",
                                  height: 100.h,
                                  width: 200.w,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      snapshot.data?[index].nama ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rp ${controller.currency(snapshot.data?[index].harga.toDouble() ?? 0)}",
                                          style: TextStyle(
                                            fontSize: ScreenUtil().setSp(12),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Icon(
                                          Icons.edit_note_outlined,
                                          color: Colors.red,
                                          size: 20.sp,
                                        ),
                                      ],
                                    ),
                                    15.verticalSpace,
                                  ],
                                ).paddingOnly(
                                    top: 10.h, left: 10.w, right: 10.w),
                              ),
                            ],
                          ),
                        ),
                      ),
                      itemCount: snapshot.data?.length,
                    );
                  }),
            ),
          )
        ],
      ).paddingSymmetric(horizontal: 20.w),
    );
  }

  Widget button(
      {required String text, required int index, required String image}) {
    return Obx(
      () => InkWell(
        splashColor: Colors.cyanAccent,
        onTap: () {
          controller.selectedValueIndex.value = index;
        },
        child: Container(
          height: 40.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: controller.selectedValueIndex.value == index
                ? Colors.red
                : Colors.white,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(10),
            ),
            border: Border.all(
              color: Colors.red,
              width: 1.h,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                5.horizontalSpace,
                Text(
                  text,
                  style: TextStyle(
                    color: controller.selectedValueIndex.value == index
                        ? Colors.white
                        : Colors.black,
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
