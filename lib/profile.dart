import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var imagePath;
  var userName = '';
  var email = '';
  var phoneNumber = 'database';
  var address = 'database';
  var gender = 'database';
  var isSelected = [false, false];
  var genderItems = ['Male', 'Female'];
  var gname = '';
  var dateOfBirth;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> documentStream = FirebaseFirestore.instance
      .collection('Users')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('UserDetail')
      .snapshots();

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    File file = File(image!.path);
    var imageBase = path.basename(image.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(imageBase);
    setState(() {
      imagePath = file;
    });
    try {
      await ref.putFile(file);
      var downloadURL = await ref.getDownloadURL();
      await currentUser!.updatePhotoURL(downloadURL);
    } catch (error) {
      print(error);
    }
  }

  final detail = FirebaseFirestore.instance
      .collection('Users')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('UserDetail')
      .doc('1');

  updateProfile(data, title, name) async {
    if (title == 'User Name') {
      await currentUser!
          .updateDisplayName(userController.text)
          .then((value) => setState(() {
                userName = userController.text;
              }));
      userController.text = '';
    } else if (title == 'Email') {
      AuthCredential credential = EmailAuthProvider.credential(
          email: emailController.text, password: 'password');
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      emailController.text = '';
    } else if (title == 'Phone') {
      await detail.update({
        'dateOfBirth': data['dateOfBirth'],
        'gender': data['gender'],
        'phone': phoneController.text,
        'address': data['address']
      });
      phoneController.text = '';
    } else if (title == 'Gender') {
      await detail.update({
        'dateOfBirth': data['dateOfBirth'],
        'gender': gname,
        'phone': data['phone'],
        'address': data['address']
      });
      setState(() {
        isSelected = [false, false];
        gender = '';
      });
    } else if (title == 'Address') {
      await detail.update({
        'dateOfBirth': data['dateOfBirth'],
        'gender': data['gender'],
        'phone': data['phone'],
        'address': addressController.text
      });
      addressController.text = '';
    }
    Navigator.of(context).pop();
  }

  pickDate(data) async {
    final initialDate = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 30),
    );
    final formatter = DateFormat('dd - MMM - yyyy');
    final String formatted = formatter.format(date!);
    await detail.update({
      'dateOfBirth': formatted,
      'gender': data['gender'],
      'phone': data['phone'],
      'address': data['address']
    });
  }

  Widget genderProperty(name, context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.31,
      child: Text(
        name,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget listtile(data, context, title, subtitle) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: title == 'Address'
            ? Container(
                height: height * 0.05,
                child: SingleChildScrollView(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey),
                  ),
                ),
              )
            : Text(
                subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey),
              ),
        trailing: GestureDetector(
            onTap: () {
              title == 'Gender'
                  ? showDialog(
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                  height: height * 0.07,
                                  child: ToggleButtons(
                                    isSelected: isSelected,
                                    selectedColor: Colors.blue,
                                    color: Colors.black,
                                    selectedBorderColor: Colors.blue,
                                    renderBorder: true,
                                    borderColor: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    children: [
                                      genderProperty('Male', context),
                                      genderProperty('Female', context),
                                    ],
                                    onPressed: (int newIndex) {
                                      setState(() {
                                        for (int index = 0;
                                            index < isSelected.length;
                                            index++) {
                                          if (index == newIndex) {
                                            isSelected[index] = true;
                                            gname = genderItems[index];
                                          } else {
                                            isSelected[index] = false;
                                          }
                                        }
                                      });
                                    },
                                  )),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () => {
                                updateProfile(data, title, gname),
                              },
                              child: Text(
                                'Change',
                              ),
                            )
                          ],
                        );
                      }),
                      context: context,
                      barrierDismissible: true,
                    )
                  : title == 'Date of Birth'
                      ? pickDate(data)
                      : title == 'Address'
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                // var name = '';
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: TextFormField(
                                          controller: addressController,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 2,
                                          maxLength: 500,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                          decoration: new InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            counterText: '',
                                            isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.black,
                                                    )),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          updateProfile(data, title, 'name'),
                                      child: Text(
                                        'Change',
                                      ),
                                    )
                                  ],
                                );
                              })
                          : showDialog(
                              context: context,
                              builder: (context) {
                                var name = '';
                                return AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.07,
                                        child: TextFormField(
                                          controller: title == 'User Name'
                                              ? userController
                                              : title == 'Email'
                                                  ? emailController
                                                  : title == 'Phone'
                                                      ? phoneController
                                                      : null
                                          // keyboardType: type,
                                          // inputFormatters: formate,
                                          ,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            contentPadding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            // isDense: true,
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    borderSide:
                                                        const BorderSide(
                                                      color: Colors.black,
                                                    )),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              borderSide: const BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          updateProfile(data, title, name),
                                      child: Text(
                                        'Change',
                                      ),
                                    )
                                  ],
                                );
                              });
            },
            child: Icon(Icons.edit, color: Colors.grey)));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.displayName);
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[300],
            leading: BackButton(
                color: Colors.white, onPressed: () => Navigator.pop(context)),
            title: Text('Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: StreamBuilder(
              stream: documentStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something Went Wrong'));
                } else if (snapshot.hasData) {
                  var data = snapshot.data!.docs.map((e) => e.data()).toList();
                  return SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    imagePath != null
                        ? MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                onTap: pickImage,
                                child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 60,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 58,
                                      backgroundImage: FileImage(
                                        imagePath,
                                      ),
                                    ))))
                        : currentUser!.photoURL != null
                            ? MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                    onTap: pickImage,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.black,
                                        radius: 60,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 58,
                                          backgroundImage: NetworkImage(
                                            '${currentUser!.photoURL}',
                                          ),
                                        ))))
                            : MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: pickImage,
                                  child: Container(
                                      child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 60,
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 58,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo_outlined,
                                                size: 40, color: Colors.black),
                                            Text(
                                              'Add Image',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        )),
                                  )),
                                ),
                              ),
                    listtile(
                        data[0],
                        context,
                        'User Name',
                        userName != ''
                            ? '$userName'
                            : '${currentUser!.displayName}'),
                    listtile(data[0], context, 'Email',
                        email != '' ? '$email' : '${currentUser!.email}'),
                    listtile(data[0], context, 'Phone', '${data[0]['phone']}'),
                    listtile(
                        data[0], context, 'Gender', '${data[0]['gender']}'),
                    listtile(data[0], context, 'Date of Birth',
                        '${data[0]['dateOfBirth']}'),
                    listtile(
                        data[0], context, 'Address', '${data[0]['address']}'),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ElevatedButton(
                          onPressed: logout,
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blue)),
                        )),
                  ]));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
