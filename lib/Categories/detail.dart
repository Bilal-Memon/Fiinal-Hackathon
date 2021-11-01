import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Detail extends StatefulWidget {
  final item;
  final name;
  const Detail({required this.item, this.name});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    addTocart(item) async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        await firestore
            .collection("Users")
            .doc('${FirebaseAuth.instance.currentUser!.uid}')
            .collection('Cart')
            .doc('${item['id']}')
            .set({'adds': item});
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(

        // backgroundColor:Colors.grey[50] ,
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          leading: BackButton(
              color: Colors.white, onPressed: () => Navigator.pop(context)),
          title: Text(
            "Detail",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Container(
                    width: width * 1,
                    height: height * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        fit: widget.name == 'cars'
                            ? BoxFit.fill
                            : BoxFit.contain,
                        image: NetworkImage(widget.item['image']),
                      ),
                    )),
                Positioned(
                    top: 15,
                    right: 15,
                    child: GestureDetector(
                      onTap: () {
                        addTocart(widget.item);
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[200],
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    )),
              ]),
              Divider(
                height: 1,
                color: Colors.black,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                      left: width * 0.03,
                      top: height * 0.015,
                      bottom: height * 0.015,
                      right: width * 0.03),
                  width: width * 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.item['title']}',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Row(
                        children: [
                          Text(
                            'Rs 40,000',
                            style: TextStyle(fontSize: 17, color: Colors.red),
                          ),
                          SizedBox(width: width * 0.02),
                          Text('Rs ${widget.item['price']}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12)),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
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
              ),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.03,
                      top: height * 0.01,
                      bottom: height * 0.02,
                      right: width * 0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Details",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          property(context, "Make", "Price", "Title"),
                          SizedBox(width: width * 0.01),
                          property(context, ":", ":", ":"),
                          SizedBox(width: width * 0.01),
                          property(
                              context,
                              "${widget.item['make']}",
                              "${widget.item['price']}",
                              "${widget.item['title']}"),
                        ],
                      )
                    ],
                  )),
              Divider(
                height: 1,
                color: Colors.grey,
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.03,
                      top: height * 0.01,
                      bottom: height * 0.02,
                      right: width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(widget.item['description'],
                          style: TextStyle(fontSize: 16))
                    ],
                  )),
            ],
          ),
        ));
  }
}

Widget property(context, name1, name2, name3) {
  final _scrollController = ScrollController();
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$name1', style: TextStyle(fontSize: 17)),
      SizedBox(
        height: height * 0.01,
      ),
      Text('$name2', style: TextStyle(fontSize: 17)),
      SizedBox(
        height: height * 0.01,
      ),
      name3 != 'Title' && name3 != ':'
          ? Container(
              width: width * 0.75,
              child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Container(
                        height: height * 0.04,
                        child: Text('$name3', style: TextStyle(fontSize: 17)))),
              ))
          : Text('$name3', style: TextStyle(fontSize: 17))
    ],
  );
}
