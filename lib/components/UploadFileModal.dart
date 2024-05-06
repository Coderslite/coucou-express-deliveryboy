import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:food_delivery/functions/SendNotification.dart';
import 'package:food_delivery/model/OrderModel.dart';
import 'package:food_delivery/utils/ModelKey.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/Constants.dart';

class UploadFile extends StatefulWidget {
  final OrderModel orderModel;
  final List tokens;
  const UploadFile({super.key, required this.orderModel, required this.tokens});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  List<File>? file = [];
  List<String> filesUploaded = [];
  int count = 0;

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        var images = result.files;

        images.forEach((element) {
          file!.add(File(element.path!));
        });
      });
      print("files selected");
    }
  }

  Future<String> uploadFile(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage
        .ref('/receipts/')
        .child(getStringAsync(USER_ID) + DateTime.now().millisecond.toString());
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    String downloadUrl = await storageReference.getDownloadURL();
    filesUploaded.add(downloadUrl);
    return downloadUrl;
  }

  Future<void> handleUploadImages() async {
    appStore.setLoading(true);
    while (count < file!.length) {
      await uploadFile(file![count]);
      print("file added");
      count++;
    }
    print("done");
  }

  handleUpdateOrder() async {
    print("handling updating order");
    orderServices.updateDocument(widget.orderModel.id, {
      OrderKey.receiptUrl: filesUploaded,
    });
    appStore.setReceiptUpload(true);
    appStore.setLoading(false);
    Navigator.pop(context);
    toast("file uploaded");
    sendNotification(widget.tokens, "Order Update",
        "Your order receipt is now available", widget.orderModel.orderId!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: file!.isEmpty ? 200 : 200 * (file!.length / 1.1),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Upload Receipt",
              style: boldTextStyle(),
            ),
            10.height,
            SizedBox(
              height: 200 * (file!.length / 2.8),
              width: 400,
              child: GridView.builder(
                  itemCount: file!.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200),
                  itemBuilder: (context, index) => Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Image.file(
                            file![index],
                          ),
                          Positioned(
                            top: 5,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  file!.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.cancel,
                                color: textPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      )),
            ),
            20.height,
            InkWell(
              onTap: () {
                pickImages();
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  border: Border.all(
                    width: 1,
                    color: whiteSmoke,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "select file",
                      style: boldTextStyle(color: grey),
                    ),
                    Icon(
                      Icons.file_upload,
                      color: grey,
                    ),
                  ],
                ),
              ),
            ),
            20.height,
            ElevatedButton(
                onPressed: () {
                  handleUploadImages().whenComplete(() => handleUpdateOrder());
                },
                child: Text(
                  "Upload",
                  style: boldTextStyle(color: white),
                )),
            Observer(
                builder: (_) => Loader().center().visible(appStore.isLoading))
          ],
        ),
      ),
    );
}
  }
