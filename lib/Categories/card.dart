import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/Authentication/signUp.dart';
import 'package:uuid/uuid.dart';

Widget card(context, i, item, name) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  var docId = Uuid();

  favouriteAdd(item, index) async {
    // var id = docId.v4();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      item['favourite'] = 'on';
      await firestore.collection(name).doc('${item['id']}').set({'adds': item});
      await firestore
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('Favourite')
          .doc('${item['id']}')
          .set({'adds': item});
    } catch (e) {
      print(e);
    }
  }

  favouriteRemove(item, index) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      item['favourite'] = 'off';
      if (name == 'favourite') {
        await firestore
            .collection('Electronics')
            .doc('${item['id']}')
            .set({'adds': item});
        await firestore
            .collection('Cars')
            .doc('${item['id']}')
            .set({'adds': item});
        await firestore
            .collection('mobiles')
            .doc('${item['id']}')
            .set({'adds': item});
        await firestore
            .collection('Clothes')
            .doc('${item['id']}')
            .set({'adds': item});
        await firestore
            .collection('Groceries')
            .doc('${item['id']}')
            .set({'adds': item});
        await firestore
            .collection('Users')
            .doc('${FirebaseAuth.instance.currentUser!.uid}')
            .collection('Favourite')
            .doc('${item['id']}')
            .delete();
      } else {
        await firestore
            .collection(name)
            .doc('${item['id']}')
            .set({'adds': item});
        await firestore
            .collection('Users')
            .doc('${FirebaseAuth.instance.currentUser!.uid}')
            .collection('Favourite')
            .doc('${item['id']}')
            .delete();
      }
    } catch (e) {
      print(e);
    }
  }

  return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              name == 'Orders'
                  ? Stack(children: [
                      Container(
                        width: width * 1,
                        height: height * 0.13,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: Image.network(
                            item['image'],
                            fit: name == 'cars' ? BoxFit.cover : BoxFit.contain,
                          ),
                        ),
                      ),
                    ])
                  : Stack(children: [
                      Container(
                        width: width * 1,
                        height: height * 0.13,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          child: Image.network(
                            item['image'],
                            fit: name == 'cars' ? BoxFit.cover : BoxFit.contain,
                          ),
                        ),
                      ),
                      item['favourite'] != 'off'
                          ? Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                  onTap: () {
                                    FirebaseAuth.instance.currentUser != null
                                        ? favouriteRemove(item, 0)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUp()));
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  )),
                            )
                          : Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                  onTap: () {
                                    FirebaseAuth.instance.currentUser != null
                                        ? favouriteAdd(item, 0)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignUp()));
                                  },
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.white,
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  )),
                            ),
                    ]),
              SizedBox(height: height * 0.005),
              Padding(
                padding:
                    EdgeInsets.only(left: width * 0.01, right: width * 0.01),
                child: Container(
                  height: height * 0.04,
                  child: Text(
                    item['title'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    // softWrap: false,
                  ),
                ),
              ),
              SizedBox(height: height * 0.005),
            ],
          ),
          Container(
            height: height * 0.065,
            padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item['disPrice'] != ''
                    ? Row(
                        children: [
                          Text('Rs ${item['disPrice']}',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 15)),
                          SizedBox(width: width * 0.02),
                          Text('Rs ${item['price']}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12)),
                        ],
                      )
                    : Text('Rs ${item['price']}',
                        style: TextStyle(color: Colors.red, fontSize: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pakistan',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 15,
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ));
}
