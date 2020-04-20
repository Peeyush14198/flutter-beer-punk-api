import 'package:flutter/cupertino.dart';
import 'package:frogbit/util/database/favorite_database.dart';


class FavoriteProvider with ChangeNotifier{
   bool faved = false;
  var favDB = FavoriteDatabase();

  Future<bool> checkFav(String id,String beer) async {
    List c = await favDB.check({"$id": beer});
    if (c.isNotEmpty) {
      setFaved(true);
      return true;
    } else {
      setFaved(false);
      return false;
    }
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }

  addFav(String id,String beer) async {
    await favDB.add({"$id": beer});
    checkFav(id,beer);
  }

  removeFav(String id,String beer) async {
    favDB.remove({"$id": beer}).then((v) {
      print(v);
      checkFav(id,beer);
    });
  }
}