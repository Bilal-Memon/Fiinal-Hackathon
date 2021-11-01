import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'card.dart';
import 'detail.dart';

class Clothes extends StatefulWidget {
  @override
  _ClothesState createState() => _ClothesState();
}

class _ClothesState extends State<Clothes> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final Stream<QuerySnapshot> data =
      FirebaseFirestore.instance.collection('Clothes').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: data,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something Went Wrong'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!.docs.map((e) => e['adds']).toList();
            if (data.isEmpty) {
              return Center(child: Text("Nothing to show."));
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
                                  builder: (context) => Detail(item: item)));
                        },
                        child: card(context, i, item, 'Clothes'));
                  }),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
