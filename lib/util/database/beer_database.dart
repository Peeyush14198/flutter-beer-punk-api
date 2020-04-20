import 'dart:io';

import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';

class BeerDatabase {
  getBeerPath() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = documentDirectory.path + '/beer.db';
    return path;
  }

  getPagePath() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = documentDirectory.path + '/page.db';
    return path;
  }

  addBeer(Map item, Map page) async {
    final pageDb = ObjectDB(await getPagePath());
    final beerDb = ObjectDB(await getBeerPath());
    beerDb.open();
    pageDb.open();
    List pageVal = await pageDb.find(page);
    print("this is the pageVal recieved - >$pageVal");
    if (pageVal.isNotEmpty) {
    } else if (pageVal.length==0) {
      beerDb.insert(item);
      pageDb.insert(page);
    }
    // print(pageVal);
    // // if (pageVal.isEmpty) {
    // //   addPage(page);
    // //   beerDb.insert(item);
    // // }
    beerDb.tidy();
    pageDb.tidy();
    await pageDb.close();
    await beerDb.close();
  }

  addPage(Map item) async {
    final db = ObjectDB(await getPagePath());
    db.open();
    db.insert(item);
    db.tidy();
    await db.close();
  }

  //Insertion
  // add(Map item) async{
  //   final db = ObjectDB(await getPath());
  //   db.open();
  //   db.insert(item);
  //   db.tidy();
  //   await db.close();
  // }

  // Future<int> remove(Map item) async{
  //   final db = ObjectDB(await getPath());
  //   db.open();
  //   int val = await db.remove(item);
  //   db.tidy();
  //   await db.close();
  //   return val;
  // }

  Future<List> listAll() async {
    final db = ObjectDB(await getBeerPath());
    db.open();
    List val = await db.find({});
    db.tidy();
    await db.close();
    return val;
  }

  // Future<List> check(Map item) async{
  //   final db = ObjectDB(await getPath());
  //   db.open();
  //   List val = await db.find(item);
  //   db.tidy();
  //   await db.close();
  //   return val;
  // }

}
