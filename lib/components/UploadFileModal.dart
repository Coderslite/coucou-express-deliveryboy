import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  List<File>? file = [];

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

  handleUploadFile() async {}

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
                  itemBuilder: (context, index) => Image.file(
                        file![index],
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
                onPressed: () {},
                child: Text(
                  "Upload",
                  style: boldTextStyle(color: white),
                )),
          ],
        ),
      ),
    );
  }
}
