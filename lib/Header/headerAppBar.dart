import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/Authentication/signUp.dart';
import 'package:shoppingapp/Search/search.dart';
import 'package:shoppingapp/cart.dart';
import 'package:shoppingapp/favourite.dart';

Widget headerTitle(context) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  var user = FirebaseAuth.instance.currentUser;
  // FirebaseAuth.instance.signOut();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Shopping Mall",
        style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      ),
      headerIcon(context, Icons.search, 'search'),
      user != null
          ? headerIcon(context, Icons.favorite, 'favourite')
          : Container(),
      user != null
          ? headerIcon(context, Icons.add_shopping_cart, 'cart')
          : Container(
              child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Text(
                'Sign Up',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(
                    left: width * 0.01,
                    right: width * 0.01,
                    top: height * 0.01,
                    bottom: height * 0.01,
                  )),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
            )),
    ],
  );
}

Widget headerIcon(context, icon, name) {
  return GestureDetector(
      onTap: () {
        name == "favourite"
            ? Navigator.push(
                context, MaterialPageRoute(builder: (context) => Favourite()))
            : name == "cart"
                ? Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Cart()))
                : Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
      },
      child: Icon(icon, color: Colors.white));
}
