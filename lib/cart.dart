import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'Categories/card.dart';
import 'Categories/detail.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> data = FirebaseFirestore.instance
      .collection('Users')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('Cart')
      .snapshots();
  buy(item) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection("Order")
          .doc('${item['id']}')
          .set({'adds': item});
      await firestore
          .collection('Users')
          .doc('${FirebaseAuth.instance.currentUser!.uid}')
          .collection('Cart')
          .doc('${item['id']}')
          .delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    int peaces = 1;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          leading: BackButton(
              color: Colors.white, onPressed: () => Navigator.pop(context)),
          title: Text(
            "Cart",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: data,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something Went Wrong'));
              } else if (snapshot.hasData) {
                var data = snapshot.data!.docs.map((e) => e['adds']).toList();
                if (data.isEmpty) {
                  return Center(child: Text("You haven't add anything yet."));
                } else {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (v, i) {
                        var item = data[i];
                        return Card(
                            elevation: 6,
                            child: Container(
                              width: width * 1,
                              height: height * 0.15,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: width * 0.4,
                                        height: height * 0.15,
                                        child: Image.network(
                                          '${item['image']}',
                                          fit: BoxFit.fill,
                                        )),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.02),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(children: [
                                            Container(
                                              width: width * 0.55,
                                              height: height * 0.05,
                                              child: Text(
                                                '${item['title']}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 5,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    // favouriteRemove(item, 0);
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 14,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(
                                                                '${FirebaseAuth.instance.currentUser!.uid}')
                                                            .collection('Cart')
                                                            .doc(
                                                                '${item['id']}')
                                                            .delete();
                                                      },
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: Colors.red,
                                                        size: 25,
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ]),
                                          Container(
                                            width: width * 0.5,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                item['disPrice'] != ''
                                                    ? Column(
                                                        children: [
                                                          Text(
                                                              '${item['disPrice']}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      15)),
                                                          SizedBox(
                                                              width:
                                                                  width * 0.02),
                                                          Text(
                                                              'Rs ${item['price']}}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12))
                                                        ],
                                                      )
                                                    : Text(
                                                        'Rs ${item['price']}',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 15)),
                                                Row(
                                                  children: [
                                                    Icon(Icons.remove),
                                                    Container(
                                                        width: width * 0.05,
                                                        child: Center(
                                                            child: Text(
                                                          '$peaces',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ))),
                                                    GestureDetector(
                                                        onTap: () {
                                                          // int name = 1;
                                                          // for (var i = 0; i < 10; i++) {
                                                          //   name = i + 1;
                                                          // }
                                                          // print(name);
                                                        },
                                                        child: Icon(Icons.add)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.52,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
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
                                                Container(
                                                    height: height * 0.05,
                                                    width: width * 0.2,
                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          buy(item),
                                                      child: Text(
                                                        'Buy',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      style: ButtonStyle(
                                                          padding: MaterialStateProperty
                                                              .all<EdgeInsets>(
                                                                  EdgeInsets
                                                                      .only(
                                                            left: width * 0.01,
                                                            right: width * 0.01,
                                                            top: height * 0.01,
                                                            bottom:
                                                                height * 0.01,
                                                          )),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(Colors
                                                                      .blue
                                                                      .shade300)),
                                                    )),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            ));
                      });
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
