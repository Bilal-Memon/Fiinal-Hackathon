import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Categories/card.dart';
import 'Categories/detail.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> favourite = FirebaseFirestore.instance
      .collection('Users')
      .doc('${FirebaseAuth.instance.currentUser!.uid}')
      .collection('Favourite')
      .snapshots();

  // favouriteRemove(item) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   try {
  //     await firestore
  //         .collection('Users')
  //         .doc('${FirebaseAuth.instance.currentUser!.uid}')
  //         .collection('Favourite')
  //         .doc('${item['id']}')
  //         .delete();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue[300],
            leading: BackButton(
                color: Colors.white, onPressed: () => Navigator.pop(context)),
            title: Text('Favourite',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: StreamBuilder(
              stream: favourite,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something Went Wrong'));
                } else if (snapshot.hasData) {
                  var data = snapshot.data!.docs.map((e) => e['adds']).toList();
                  if (data.isEmpty) {
                    return Center(
                        child: Text("You haven't liked anything yet."));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: GridView.count(
                        childAspectRatio: 0.8,
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: List.generate(data.length, (i) {
                          var item = data[i];
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Detail(item: item)));
                              },
                              child: card(context, i, item, 'favourite'));
                        }),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
