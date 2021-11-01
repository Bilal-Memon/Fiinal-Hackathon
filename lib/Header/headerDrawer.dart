import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/Authentication/signUp.dart';
import 'package:shoppingapp/orders.dart';
import 'package:shoppingapp/profile.dart';

import '../cart.dart';
import '../favourite.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Container(
        color: Colors.blue[300],
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width * 1,
                  height: height * 0.28,
                  color: Colors.white,
                  child: FirebaseAuth.instance.currentUser != null
                      ? Image.network(
                          '${currentUser!.photoURL}',
                          fit: BoxFit.fill,
                        )
                      : Container(),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: width * 0.03, top: height * 0.02),
                  child: Text(
                    FirebaseAuth.instance.currentUser != null
                        ? '${currentUser!.displayName}'
                        : 'Nothing',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Divider(
                  height: 1,
                  color: Colors.white,
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Column(
                  children: [
                    screens(context, Icons.favorite, "Favourite"),
                    screens(context, Icons.add_shopping_cart, "Cart"),
                    screens(context, Icons.article, "Orders"),
                    screens(context, Icons.how_to_reg, "Profile"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget screens(context, icon, name) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  return Material(
    color: Colors.blue[300],
    child: InkWell(
      splashColor: Colors.white70,
      onTap: () {
        FirebaseAuth.instance.currentUser != null
            ? name == 'Favourite'
                ? Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Favourite()))
                : name == 'Cart'
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Cart()))
                    : name == 'Orders'
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Orders()))
                        : name == 'Profile'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()))
                            : null
            : name == 'Favourite'
                ? Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()))
                : name == 'Cart'
                    ? Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()))
                    : name == 'Orders'
                        ? Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignUp()))
                        : name == 'Profile'
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()))
                            : null;
      },
      child: Container(
        width: width * 1,
        height: height * 0.08,
        padding: EdgeInsets.only(left: width * 0.04),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(
              width: width * 0.05,
            ),
            Text(name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}
