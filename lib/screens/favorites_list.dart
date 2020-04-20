import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frogbit/screens/beer_detail.dart';
import 'package:frogbit/util/database/favorite_database.dart';
import 'package:frogbit/util/functions.dart';
import 'package:frogbit/widgets/custom_loader.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: FutureBuilder(
        future: FavoriteDatabase().listAll(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return CustomLoaderWidget();
          } else if (snap.data.length == 0) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: snap.data.length,
              itemBuilder: (context, index) {
                Map map = snap.data[index];
                Map item = json.decode(map['item']);
                print(item);
                return buildRow(item, index);
              },
            );
          }
        },
      ),
    );
  }

  Widget buildRow(Map beer, int index) {
    return InkWell(
      onTap: () {
        CustomFunctions().customNavigation(
            context, BeerDetail(beerId: beer['id'], beerName: beer['name'],beer: beer,));
      },
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: index == 0 ? 10.0 : 0),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CachedNetworkImage(
                    imageUrl: beer['image_url'],
                    height: 80.0,
                    width: 80.0,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 70.0, right: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          beer['name'],
                          style: Theme.of(context).textTheme.display1,
                        ),
                        Text(
                          beer['tagline'],
                          style: Theme.of(context).textTheme.display3,
                        )
                      ],
                    )),
              ],
            ),
          ),
          Container(
            height: 5.0,
          ),
          Divider()
        ],
      ),
    );
  }
}
