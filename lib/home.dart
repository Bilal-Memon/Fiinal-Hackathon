import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/Categories/cars.dart';
import 'package:shoppingapp/Categories/clothes.dart';
import 'package:shoppingapp/Categories/electronics.dart';
import 'package:shoppingapp/Categories/groceries.dart';
import 'package:shoppingapp/Categories/mobile.dart';
import 'Header/headerAppBar.dart';
import 'Header/headerDrawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 5,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            drawer: HomeDrawer(),
            appBar: AppBar(
              backgroundColor: Colors.blue[300],
              title: headerTitle(context),
              bottom: TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.white60,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(child: Text('Electronics')),
                  Tab(child: Text('Cars')),
                  Tab(child: Text('Mobile')),
                  Tab(child: Text('Clothes')),
                  Tab(child: Text('Groceries')),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Electronics(),
                Cars(),
                Mobile(),
                Clothes(),
                Groceries()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
