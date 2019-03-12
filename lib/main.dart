import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_sqlite_crud_eng/database/dbHelper.dart';
import 'package:flutter_sqlite_crud_eng/model/dish.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  String name, description;
  double price;
  TextEditingController nameController, descriptionController, priceController;

  @override
  void initState() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  createData() {
    setState(() {
      var dbHelper = DBHelper();
      var dish = Dish(name, description, price);
      dbHelper.createDish(dish);
    });
  }

  updateData() {
    setState(() {
      var dbHelper = DBHelper();
      var dish = Dish(name, description, price);
      dbHelper.updateDish(dish);
    });
  }

  readData() {
    var dbHelper = DBHelper();
    Future<Dish> dish = dbHelper.readDish(name);
    dish.then((dishData) {
      print("${dishData.name}, ${dishData.description}, ${dishData.price}");
      setState(() {
        descriptionController.text = dishData.description;
        priceController.text = dishData.price.toString();
      });
    });
  }

  Future<List<Dish>> getAllDishes() async {
    var dbHelper = DBHelper();
    Future<List<Dish>> dishes = dbHelper.readAllDishes();
    return dishes;
  }

  deleteData() {
    setState(() {
      var dbHelper = DBHelper();
      dbHelper.deleteDish(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("SQLite CRUD"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: "Name"),
              onChanged: (String name) {
                this.name = name;
              },
              controller: nameController,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Description"),
              onChanged: (String description) {
                this.description = description;
              },
              controller: descriptionController,
            ),
            TextField(
              decoration: InputDecoration(hintText: "Price"),
              keyboardType: TextInputType.number,
              onChanged: (String price) {
                this.price = double.parse(price);
              },
              controller: priceController,
            ),
            new Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RaisedButton(
                      color: Colors.green,
                      child: Text("Create"),
                      onPressed: () {
                        createData();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RaisedButton(
                      child: Text("Read"),
                      onPressed: () {
                        readData();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RaisedButton(
                      color: Colors.orange,
                      child: Text("Update"),
                      onPressed: () {
                        updateData();
                      },
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Text("Delete"),
                    onPressed: () {
                      deleteData();
                    },
                  ),
                ],
              ),
            ),
            Row(
              textDirection: TextDirection.ltr,
              children: <Widget>[
                Expanded(
                  child: Text("Name:"),
                ),
                Expanded(
                  child: Text("Description:"),
                ),
                Expanded(
                  child: Text("Price:"),
                ),
              ],
            ),
            FutureBuilder<List<Dish>>(
              future: getAllDishes(),
              builder: (context, snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Row(
                      textDirection: TextDirection.ltr,
                      children: <Widget>[
                        Expanded(
                          child: Text(snapshot.data[index].name),
                        ),
                        Expanded(
                          child: Text(snapshot.data[index].description),
                        ),
                        Expanded(
                          child: Text(snapshot.data[index].price.toString()),
                        ),
                      ],
                    );
                  },
                );
              },
            )

          ],
        ),
      ),
    );
  }
}
