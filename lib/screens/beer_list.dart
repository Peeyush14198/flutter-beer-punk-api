import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:frogbit/screens/beer_detail.dart';
import 'package:frogbit/screens/favorites_list.dart';
import 'package:frogbit/util/database/beer_database.dart';
import 'package:frogbit/util/database/favorite_database.dart';
import 'package:frogbit/util/functions.dart';
import 'package:http/http.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BeerList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BeerListState();
  }
}

class BeerListState extends State<BeerList> {
  List beerList = [];
  int pageNum = 1;
  Client client = Client();
  bool isLoading = false;
  var db = FavoriteDatabase();
  List favoritesData = [];
  var beerDb = BeerDatabase();
  ScrollController _sc = new ScrollController();
  final Connectivity connectivity = new Connectivity();
  String connectionStatus;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  //For subscription to the ConnectivityResult stream
  StreamSubscription<ConnectivityResult> connectionSubscription;
  final internetSnackBar = SnackBar(
    content: Text(
      'Internet Connected',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 13.0),
    ),
    backgroundColor: Colors.green,
  );
  final noInternetSnackBar = SnackBar(
    content: Text(
      'Internet Disconnected',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontSize: 13.0),
    ),
    backgroundColor: Colors.grey,
  );

  @override
  void initState() {
    // getLocalData();
    // beerDb.listAll().then((onValue) => {print(onValue[1])});
    super.initState();
    connectionSubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectionStatus = result.toString();
      });
      connectionStatus.toString().compareTo("ConnectivityResult.none") == 0
          ? scaffoldKey.currentState.showSnackBar(noInternetSnackBar)
          : scaffoldKey.currentState.showSnackBar(internetSnackBar);
       if(connectionStatus.toString().compareTo("ConnectivityResult.none") != 0)
       {
         fetchBeers();
       }   
      //showFlushBarNoInternet(context);
    });
  
    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        fetchBeers();
      }
    });
  }

  @override
  void dispose() {
    // bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Top Beers'),
          actions: <Widget>[
            IconButton(
                icon: Icon(MdiIcons.heartFlash),
                onPressed: () {
                  CustomFunctions()
                      .customNavigation(context, FavoritesScreen());
                })
          ],
        ),
        body: FutureBuilder(
          future: db.listAll(),
          builder: (context, dbSnap) {
            if (!dbSnap.hasData) {
              return connectionStatus
                          .toString()
                          .compareTo("ConnectivityResult.none") ==
                      0
                  ? FutureBuilder(
                      future: beerDb.listAll(),
                      builder: (context, beerDbSnap) {
                        if (!beerDbSnap.hasData) {
                          return Container();
                        } else {
                          List list = beerDbSnap.data;

                          List localBeersList = [];
                          for (int j = 0; j < list.length; j++) {
                            Map map = list[j];
                            List list1 = map['item'];

                            for (int k = 0; k < list1.length; k++) {
                              localBeersList.add(list1[k]);
                            }
                          }
                          // print(localBeersList.length);
                          // return Container();
                          return ListView.builder(
                            itemCount: localBeersList.length,
                            itemBuilder: (context, i) {
                              bool isLiked = false;

                              return buildRow(
                                  context, localBeersList[i], isLiked, i);
                            },
                          );
                        }
                      },
                    )
                  : Stack(
                      children: <Widget>[
                        ListView.builder(
                            controller: _sc,
                            itemCount: beerList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final beer = beerList[index];
                              bool isLiked = false;
                              return buildRow(context, beer, isLiked, index);
                            }),
                        Visibility(
                          visible: isLoading,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    );
            } else {
              // print("got Favorites");
              return connectionStatus
                          .toString()
                          .compareTo("ConnectivityResult.none") ==
                      0
                  ? FutureBuilder(
                      future: beerDb.listAll(),
                      builder: (context, beerDbSnap) {
                        if (!beerDbSnap.hasData) {
                          return Container();
                        } else {
                          List list = beerDbSnap.data;

                          List localBeersList = [];
                          for (int j = 0; j < list.length; j++) {
                            Map map = list[j];
                            List list1 = map['item'];
                           // print(list1.length);
                            for (int k = 0; k < list1.length; k++) {
                              localBeersList.add(list1[k]);
                            }
                          }
                         // print(localBeersList.length);
                          // return Container();
                          return ListView.builder(
                            itemCount: localBeersList.length,
                            itemBuilder: (context, i) {
                              bool isLiked = false;
                              for (int l = 0; l < dbSnap.data.length; l++) {
                                Map dbmaps = dbSnap.data[l];
//                                print(dbmaps);

                                if (dbmaps['id'].toString().compareTo(
                                        localBeersList[i]['id'].toString()) ==
                                    0) {
                                  isLiked = true;
                                }
                              }
                              return buildRow(
                                  context, localBeersList[i], isLiked, i);
                            },
                          );
                        }
                      },
                    )
                  : Stack(
                      children: <Widget>[
                        ListView.builder(
                            controller: _sc,
                            itemCount: beerList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final beer = beerList[index];

                              bool isLiked = false;
                              for (int i = 0; i < dbSnap.data.length; i++) {
                                Map map = dbSnap.data[i];
                                // print(map);
                                if (map['id']
                                        .toString()
                                        .compareTo(beer['id'].toString()) ==
                                    0) {
                                  isLiked = true;
                                }
                              }

                              return buildRow(context, beer, isLiked, index);
                            }),
                        Visibility(
                          visible: isLoading,
                          child: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    );
            }
          },
        ));
  }

  Widget buildRow(BuildContext context, Map beer, bool isLiked, int index) {
    return InkWell(
      onTap: () {
        CustomFunctions().customNavigation(
            context,
            BeerDetail(
              beerId: beer['id'],
              beerName: beer['name'],
              beer: beer,
            ));
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
                    imageUrl: beer['image_url'].toString(),
                    height: 80.0,
                    width: 80.0,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 70.0, right: 40.0),
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
                          beer['id'].toString(),
                          style: Theme.of(context).textTheme.display3,
                        ),
                        Text(
                          beer['tagline'],
                          style: Theme.of(context).textTheme.display3,
                        )
                      ],
                    )),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: InkWell(
                        onDoubleTap: () {
                          if (isLiked) {
                            //BeerResponse.fromJson()
                            Map item = {
                              "id": "${beer['id'].toString()}",
                              "item": json.encode(beer)
                            };
                            db
                                .remove(item)
                                .then((onValue) => {setState(() {})});
                          }
                        },
                        onTap: () {
                          if (!isLiked) {
                            Map item = {
                              "id": "${beer['id'].toString()}",
                              "item": json.encode(beer)
                            };
                            db.add(item).then((onValue) => {setState(() {})});
                          } else {
                            Map item = {
                              "id": "${beer['id'].toString()}",
                              "item": json.encode(beer)
                            };
                            db
                                .remove(item)
                                .then((onValue) => {setState(() {})});
                          }
                        },
                        child: Icon(Icons.favorite,
                            color: isLiked ? Colors.red : Colors.grey),
                      ),
                    ))
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

  fetchBeers() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    String url =
        Uri.https("api.punkapi.com", "/v2/beers", {"page": pageNum.toString()})
            .toString();
    final response = await client.get(url);
    print("In fetching state");
    if (response.statusCode == 200) {
      print("data fetched"); 
      List<dynamic> iterable = json.decode(response.body);
      Map item = {"item": iterable};
      Map pageItem = {pageNum.toString(): pageNum.toString()};
      beerDb.addBeer(item, pageItem);
      setState(() {
        beerList.addAll(iterable);
        pageNum++;
        isLoading = false;
      });
    }
  }

  // Bloc code under development place this with scaffold body

  // body: StreamBuilder(
  //     stream: bloc.allBeers,
  //     builder: (context, AsyncSnapshot<List<Beer>> snapshot) {
  //       if (snapshot.hasData) {
  //         if (snapshot.data.length > 0) {
  //           if (_beerList.contains(snapshot.data[0])) {
  //             return buildList();
  //           }
  //           _beerList.addAll(snapshot.data);
  //           _pageNum++;
  //           _isLoading = false;
  //           return buildList();
  //         } else {
  //           _isLoading = false;
  //           return buildList();
  //         }
  //       } else if (snapshot.hasError) {
  //         _isLoading = false;
  //         return Text(snapshot.error.toString());
  //       }
  //       return Center(
  //           child: CircularProgressIndicator(
  //         backgroundColor: Theme.of(context).primaryColor,
  //       ));
  //     }),

  // Build list

  // Widget buildList() {
  //   return FutureBuilder(
  //     future: db.listAll(),
  //     builder: (context, dbSnap) {
  //       if (!dbSnap.hasData) {
  //         return Stack(
  //           children: <Widget>[
  //             NotificationListener(
  //               onNotification: onNotification,
  //               child: ListView.builder(
  //                   itemCount: _beerList.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     final beer = _beerList[index];
  //                     bool isLiked = false;
  //                     // //getLocalData();
  //                     // for (int i = 0; i < dbSnap.data.length; i++) {
  //                     //   Map map = dbSnap.data[i];
  //                     //   // print(map);
  //                     //   if (map.containsKey(beer.id.toString())) {
  //                     //     isLiked = true;
  //                     //   }
  //                     // }

  //                     return buildRow(context, beer, isLiked, index);
  //                   }),
  //             ),
  //             Visibility(
  //               visible: _isLoading,
  //               child: Center(
  //                 child: CircularProgressIndicator(
  //                   backgroundColor: Theme.of(context).primaryColor,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       } else {
  //         // print(dbSnap.data);
  //         return Stack(
  //           children: <Widget>[
  //             NotificationListener(
  //               onNotification: onNotification,
  //               child: ListView.builder(
  //                   itemCount: _beerList.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     final beer = _beerList[index];
  //                     bool isLiked = false;
  //                     print(dbSnap.data);
  //                     //getLocalData();
  //                     for (int i = 0; i < dbSnap.data.length; i++) {
  //                       Map map = dbSnap.data[i];
  //                       // print(map);
  //                       if (map['id']
  //                               .toString()
  //                               .compareTo(beer.id.toString()) ==
  //                           0) {
  //                         isLiked = true;
  //                       }
  //                     }

  //                     return buildRow(context, beer, isLiked, index);
  //                   }),
  //             ),
  //             Visibility(
  //               visible: _isLoading,
  //               child: Center(
  //                 child: CircularProgressIndicator(
  //                   backgroundColor: Theme.of(context).primaryColor,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }

  //Scroll notification listener

  // bool onNotification(ScrollNotification notification) {
  //   if (notification.metrics.extentAfter == 0.0) {
  //     fetchBeers();
  //   }
  //   return true;
  // }

  // build Row code to be replaced with existing build row

  // Widget buildRow(BuildContext context, Map beer, bool isLiked, int index) {
  //   return InkWell(
  //     onTap: () {
  //       CustomFunctions().customNavigation(
  //           context, BeerDetail(beerId: beer.id, beerName: beer.name));
  //     },
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           width: double.infinity,
  //           margin: EdgeInsets.only(top: index == 0 ? 10.0 : 0),
  //           child: Stack(
  //             children: <Widget>[
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 16),
  //                 child: CachedNetworkImage(
  //                   imageUrl: beer.imageUrl,
  //                   height: 80.0,
  //                   width: 80.0,
  //                 ),
  //               ),
  //               Padding(
  //                   padding: EdgeInsets.only(left: 70.0, right: 30.0),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Text(
  //                         beer.name,
  //                         style: Theme.of(context).textTheme.display1,
  //                       ),
  //                       Text(
  //                         beer.tagLine,
  //                         style: Theme.of(context).textTheme.display3,
  //                       )
  //                     ],
  //                   )),
  //               Align(
  //                   alignment: Alignment.bottomRight,
  //                   child: Padding(
  //                     padding: EdgeInsets.only(right: 10.0),
  //                     child: InkWell(
  //                       onDoubleTap: () {
  //                         if (isLiked) {
  //                           //BeerResponse.fromJson()
  //                           Map item = {
  //                             "id": beer.id.toString(),
  //                             "item": json.encode(beer.toJson())
  //                           };
  //                           db
  //                               .remove(item)
  //                               .then((onValue) => {setState(() {})});
  //                         }
  //                       },
  //                       onTap: () {
  //                         if (!isLiked) {
  //                           Map item = {
  //                             "id": beer.id.toString(),
  //                             "item": json.encode(beer.toJson())
  //                           };
  //                           db.add(item).then((onValue) => {setState(() {})});
  //                         } else {
  //                           Map item = {
  //                             "id": beer.id.toString(),
  //                             "item": json.encode(beer.toJson())
  //                           };
  //                           db
  //                               .remove(item)
  //                               .then((onValue) => {setState(() {})});
  //                         }
  //                       },
  //                       child: Icon(Icons.favorite,
  //                           color: isLiked ? Colors.red : Colors.grey),
  //                     ),
  //                   ))
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 5.0,
  //         ),
  //         Divider()
  //       ],
  //     ),
  //   );
  // }
}
