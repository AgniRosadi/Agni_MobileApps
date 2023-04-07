import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/helper/util/constant.dart';
import 'package:flutter/services.dart';

class AddDataPage extends StatelessWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Data"),
      ),
      body: const SafeArea(child: _AddDataContent()),
    );
  }
}

class _AddDataContent extends StatefulWidget {
  const _AddDataContent({Key? key}) : super(key: key);

  @override
  State<_AddDataContent> createState() => _AddDataContentState();
}

class _AddDataContentState extends State<_AddDataContent> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  ImageProvider? imageView;
  File? filenya;
  XFile? xfilenya;

  void setImageView(BuildContext context, XFile? file) {
    if (file != null) {
      filenya = File(file.path);
      if (filenya != null) {
        final bytes = filenya!.readAsBytesSync().lengthInBytes;
        final kb = bytes / 1024;
        final mb = kb / 1024;
        if (mb >= 3) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "* Format Foto selfie tidak didukung atau ukuran melebihi batas",
              textScaleFactor: 1,
            ),
            backgroundColor: Colors.red,
          ));
        } else {
          xfilenya = file;
          imageView = FileImage(filenya!);
        }
      }
    }
  }

  Future<http.Response> _addData(BuildContext context, dynamic params) async {
    print(params);
    final response = await http.post(Uri.parse(Constant.addUrl),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(params));
      print(response.body);
      return response;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Form(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: name,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(.08),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.05)),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.05)),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: price,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignLabelWithHint: true,
                      labelText: 'Price',
                      filled: true,
                      fillColor: Colors.grey.withOpacity(.08),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.05)),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(.05)),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    ImagePicker picker = ImagePicker();
                    XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      setImageView(context, image);
                    });
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          labelText: "Image",
                          border: OutlineInputBorder(),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: FaIcon(FontAwesomeIcons.images),
                          )),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Builder(
                  builder: (context) {
                    ImageProvider? img = imageView;
                    if (img != null) {
                      return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image(
                            image: img,
                            height: 200,
                          ));
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          )),
          Expanded(child: Container()),
          SizedBox(
            width: double.infinity,
            child:
                ElevatedButton(onPressed: () async {
                  _addData(context, {
                    "food_code" : "FOOD-55555",
                    "name" : name.text,
                    "price" : price.text,
                    "picture_ori": "",
                    "picture":filenya?.path ?? "https://t-2.tstatic.net/palembang/foto/bank/images/Resep-sate-Padang.jpg",
                    "created_at": "2022-01-07 14:16:56"
                  });
                }, child: const Text("Add Data")),
          )
        ],
      ),
    );
  }
}
