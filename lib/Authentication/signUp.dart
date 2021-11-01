import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingapp/Authentication/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingapp/home.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var imageError = '';
  var userError = '';
  var emailError = '';
  var passError = '';
  var phoneError = '';
  var dateError = '';
  var genderError = '';
  var addressError = '';
  var imagePath;
  var imageBase;
  var userName = '';
  var email = '';
  var password = '';
  var dateOfBirth = '';
  var gender = '';
  var phoneNumber = '';
  var address = '';
  var isSelected = [false, false];
  var genderItems = ['Male', 'Female'];
  bool _isButtonDisabled = false;
  bool _isLoading = false;
  pickImage() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var imagebase = path.basename(image.path);
      File file = File(image.path);
      setState(() {
        imageBase = imagebase;
        imagePath = file;
      });
    }
  }

  pickDate() async {
    FocusScope.of(context).unfocus();
    final initialDate = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year + 30),
    );
    final formatter = DateFormat('dd - MMM - yyyy');
    final String formatted = formatter.format(date!);
    setState(() {
      dateError = '';
      dateOfBirth = formatted;
    });
  }

  signError() {
    FocusScope.of(context).unfocus();
    setState(() {
      // _isLoading = true;
      if (imagePath == null) {
        _isLoading = false;
        imageError = 'Please add image';
      }
      if (userName.length < 4) {
        _isLoading = false;
        userError = 'Please enter your name';
      }
      if (email == '') {
        _isLoading = false;
        emailError = 'Please enter Email';
      }
      if (password == '') {
        _isLoading = false;
        passError = 'Please enter password';
      }
      if (password != '' && password.length < 6) {
        _isLoading = false;
        passError = 'The password must be atleast 6 characters';
      }
      if (dateOfBirth == '') {
        _isLoading = false;
        dateError = 'Please enter your date of birth';
      }
      if (gender == '') {
        _isLoading = false;
        genderError = 'Please enter your gender';
      }
      if (phoneNumber.length <= 10) {
        _isLoading = false;
        phoneError = 'Please enter your correct phone number';
      }
      if (address.length < 30) {
        _isLoading = false;
        addressError = 'Please enter full address';
      }
    });
  }

  signUp(context) async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    final CollectionReference profileList =
        FirebaseFirestore.instance.collection('Users');
    final firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(imageBase);
    try {
      final UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await user.user!.updateDisplayName(userName);
      await ref.putFile(imagePath);
      var downloadURL = await ref.getDownloadURL();
      await user.user!.updatePhotoURL(downloadURL);
      await profileList
          .doc(user.user!.uid)
          .collection('UserDetail')
          .doc('1')
          .set({
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'phone': phoneNumber,
        'address': address
      });
      _isLoading = false;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code.contains('email') == true) {
        setState(() {
          _isLoading = false;
          emailError = '${e.message}';
        });
      }
    } catch (e) {
      print('$e');
    }
  }

  Widget input(context, name, type, formate, hash, suggestion, maxL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.07,
          child: TextFormField(
            maxLength: maxL,
            keyboardType: type,
            inputFormatters: formate,
            onChanged: (e) => {
              name == 'User Name'
                  ? setState(() {
                      userError = '';
                      userName = e;
                    })
                  : name == 'Email'
                      ? setState(() {
                          emailError = '';
                          email = e;
                        })
                      : name == 'Password'
                          ? setState(() {
                              passError = '';
                              password = e;
                            })
                          : name == 'Phone-Number'
                              ? setState(() {
                                  phoneError = '';
                                  phoneNumber = e;
                                })
                              : null
            },
            style: TextStyle(fontSize: 17, color: Colors.black),

            obscureText: hash, //true
            enableSuggestions: suggestion, //false
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 10, right: 10),
              // isDense: true,
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        name == 'User Name'
            ? Text(
                '$userError',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.red, fontSize: 13),
              )
            : name == 'Email'
                ? Text(
                    '$emailError',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  )
                : name == 'Password'
                    ? Text(
                        '$passError',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      )
                    : name == 'Phone-Number'
                        ? Text(
                            '$phoneError',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          )
                        : Text('')
      ],
    );
  }

  Widget descriptionBox(context, name) {
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            onChanged: (e) => {
              setState(() {
                addressError = '';
                address = e;
              })
            },
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
              // contentPadding: EdgeInsets.all(10),
              isDense: true,
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: const BorderSide(
                    color: Colors.black,
                  )),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.007),
        Text(
          '$addressError',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.red, fontSize: 13),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var nowDate = DateTime.now();
    final formatter = DateFormat('dd - MMM - yyyy');
    final String date = formatter.format(nowDate);
    imagePath != null &&
            userName.length >= 4 &&
            password.length > 6 &&
            dateOfBirth != '' &&
            gender != '' &&
            phoneNumber.length == 11 &&
            address.length >= 30
        ? setState(() {
            _isButtonDisabled = false;
          })
        : setState(() {
            _isButtonDisabled = true;
          });
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
                // resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: BackButton(
                      color: Colors.black,
                      onPressed: () => Navigator.popUntil(
                          context, ModalRoute.withName('/'))),
                  title: Text('Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  centerTitle: true,
                ),
                body: Container(
                  // color: Colors.lightBlueAccent[100],
                  color: Colors.blue[300],
                  child: Center(
                    child: SingleChildScrollView(
                      // reverse: true,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.005,
                          ),
                          imagePath != null
                              ? MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                      onTap: pickImage,
                                      child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 50,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 48,
                                            backgroundImage: FileImage(
                                              imagePath,
                                            ),
                                          ))))
                              : Column(
                                  children: [
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: pickImage,
                                        child: Container(
                                            child: CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 50,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 48,
                                              child: Icon(
                                                  Icons.add_a_photo_outlined,
                                                  size: 40,
                                                  color: Colors.black)),
                                        )),
                                      ),
                                    ),
                                    Text(
                                      '$imageError',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 13),
                                    )
                                  ],
                                ),
                          input(context, 'User Name', TextInputType.text, null,
                              false, true, 50),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          input(context, 'Email', TextInputType.emailAddress,
                              null, false, true, 40),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          input(context, 'Password', TextInputType.text, null,
                              true, false, 30),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                GestureDetector(
                                  onTap: pickDate,
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.calendar_today,
                                          color: Colors.black,
                                        ),
                                        title: Center(
                                          child: Text(
                                            dateOfBirth != ''
                                                ? dateOfBirth
                                                : date,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.black,
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  height: height * 0.007,
                                ),
                                Text(
                                  '$dateError',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
                                )
                              ]),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                  height: height * 0.07,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  ),
                                  child: ToggleButtons(
                                    isSelected: isSelected,
                                    selectedColor: Colors.blue,
                                    color: Colors.black,
                                    selectedBorderColor: Colors.black,
                                    fillColor: Colors.white,
                                    renderBorder: true,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderColor: Colors.black,
                                    children: [
                                      conditionProperty('Male', context),
                                      conditionProperty('Female', context),
                                    ],
                                    onPressed: (int newIndex) {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        for (int index = 0;
                                            index < isSelected.length;
                                            index++) {
                                          if (index == newIndex) {
                                            isSelected[index] = true;
                                            genderError = '';
                                            gender = genderItems[index];
                                          } else {
                                            isSelected[index] = false;
                                          }
                                        }
                                      });
                                    },
                                  )),
                              SizedBox(
                                height: height * 0.007,
                              ),
                              Text(
                                '$genderError',
                                textAlign: TextAlign.left,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 13),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          input(
                              context,
                              'Phone-Number',
                              TextInputType.number,
                              <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              false,
                              true,
                              11),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          descriptionBox(context, 'Address'),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          _isLoading
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                    onPressed: () => {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircularProgressIndicator(
                                            color: Colors.blue),
                                        Text(
                                          'Please Wait...',
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 15),
                                        )
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                  ))
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  child: ElevatedButton(
                                    onPressed: () => _isButtonDisabled
                                        ? signError()
                                        : signUp(context),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white)),
                                  )),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Already Have Account  ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  },
                                  child: Text('Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ));
  }
}

Widget conditionProperty(name, context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.45,
    child: Text(
      name,
      style: TextStyle(fontSize: 18),
      textAlign: TextAlign.center,
    ),
  );
}
