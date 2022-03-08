import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:folarium_test_apps/api/api_client.dart';
import 'package:folarium_test_apps/helper/preference_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();

  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtDob = TextEditingController();
  String? valGender;
  List listGender = ["Male", "Female"];
  List<XFile>? _imageFileList;
  String location = 'Null, Press Button';

  bool isLoading = false;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  bool isValid() {
    bool isFormValid = false;
    if (txtFullName.text.isNotEmpty &&
        txtDob.text.isNotEmpty &&
        valGender != null &&
        _imageFileList != null) {
      isFormValid = true;
    }
    return isFormValid;
  }

  void showConfirmDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Simpan biodata ?"),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            setState(() {
              isLoading = true;
            });
            String fileName = _imageFileList![0].path.split('/').last;
            Position position = await _getGeoLocationPosition();
            location =
                'Lat: ${position.latitude} , Long: ${position.longitude}';

            String token = '';

            await FirebaseMessaging.instance.getToken().then((value) {
              token = value.toString();
            });

            Map<String, dynamic> formData = {
              'full_name': txtFullName.text,
              'gender': valGender,
              'date_of_birth': txtDob.text,
              'current_location': location,
              'token_id': token,
              'image': await MultipartFile.fromFile(_imageFileList![0].path,
                  filename: fileName),
            };

            await ApiClient.insertBiodata(formData: formData)
                .then((resp) async {
              if (resp != null) {
                await PreferenceHelper.setFirstOpen(false);
                await PreferenceHelper.setUserId(resp.data!.userId!);
                await PreferenceHelper.setTokenId(resp.data!.tokenId!);

                await ApiClient.sendPushMessage(
                    data: constructFCMPayload(token));

                setState(() {
                  isLoading = false;
                });

                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    title: "Sukses",
                    text: "Data berhasil di simpan",
                    onConfirmBtnTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(true);
                    });
              } else {
                setState(() {
                  isLoading = false;
                });
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.error,
                  title: "Terjadi kesalahan",
                  text: "Kesalahan server",
                );
              }
            });
          },
          child: Text("Simpan"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Batal"),
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  Map<String, dynamic>? constructFCMPayload(String? token) {
    return {
      'to': token,
      'notification': {
        'title': 'Hello ${txtFullName.text}',
        'body': 'Welcome to this apps, this message send by FCM',
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              if (isValid()) {
                showConfirmDialog();
              } else {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.error,
                  title: "Terjadi kesalahan",
                  text: "Periksa kembali form data",
                );
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: txtFullName,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey),
                      labelText: 'Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              iconSize: 0.0,
                              hint: Text(
                                "Select Your Gender",
                                style: TextStyle(color: Colors.grey),
                              ),
                              value: valGender,
                              items: listGender.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  valGender = value as String?;
                                });
                              },
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime? newDateTime = await showRoundedDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1),
                        borderRadius: 16,
                        height: MediaQuery.of(context).size.height * 0.4,
                      );

                      if (newDateTime != null) {
                        var formatter = new DateFormat('yyyy-MM-dd');
                        String formattedDate = formatter.format(newDateTime);
                        txtDob.text = formattedDate;
                      }
                    },
                    child: TextField(
                      controller: txtDob,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Date Of Birth',
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: new Icon(Icons.camera),
                                title: new Text('Camera'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  try {
                                    final XFile? pickedFile =
                                        await _picker.pickImage(
                                      source: ImageSource.camera,
                                    );
                                    setState(() {
                                      _imageFile = pickedFile;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      // _pickImageError = e;
                                    });
                                  }
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.photo),
                                title: new Text('Galery'),
                                onTap: () async {
                                  Navigator.pop(context);
                                  try {
                                    final XFile? pickedFile =
                                        await _picker.pickImage(
                                      source: ImageSource.gallery,
                                    );
                                    setState(() {
                                      _imageFile = pickedFile;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      // _pickImageError = e;
                                    });
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: _imageFileList != null
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.file(
                              File(_imageFileList![0].path),
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                Text(
                                  "Upload your favorite image",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
