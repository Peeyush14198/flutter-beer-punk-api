import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frogbit/widgets/custom_fade_animation.dart';

class BeerDetail extends StatefulWidget {
  final int beerId;
  final String beerName;
  final Map beer;
  BeerDetail({this.beerId, this.beerName, this.beer});
  @override
  _BeerDetailState createState() => _BeerDetailState();
}

class _BeerDetailState extends State<BeerDetail> {
 
  @override
  void initState() {
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.beerName),
        centerTitle: true,
      ),
      body: buildBeerDetailLayout(),
      // body: FutureBuilder(
      //   future: _repository.getBeer(widget.beerId),
      //   builder: (context, snap) {
      //     if (!snap.hasData) {
      //       return CircularProgressIndicator();
      //     } else {
      //       return buildBeerDetailLayout(snap.data);
      //     }
      //   },
      // ),
    );
  }

  Widget buildBeerDetailLayout() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.beer['image_url'].toString(),
                    height: 150.0,
                    width: 100.0,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 20.0,
                        ),
                        CustomFadeAnimation(
                          child: Text(
                            widget.beer['name'],
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Container(
                          height: 10.0,
                        ),
                        CustomFadeAnimation(
                          child: Text(
                            widget.beer['tagline'],
                            style: Theme.of(context).textTheme.display3,
                          ),
                        ),
                        Container(
                          height: 10.0,
                        ),
                        CustomFadeAnimation(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "ABV",
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline,
                                      ),
                                      Text(
                                        "${widget.beer['abv']}",
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .title,
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "IBU",
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .headline,
                                      ),
                                      Text(
                                        "${widget.beer['ibu']}",
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .title,
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "OG",
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .headline,
                                        ),
                                        Text(
                                          "${widget.beer['target_og']}",
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .title,
                                          softWrap: false,
                                        ),
                                      ],
                                    ))
                              ]),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: CustomFadeAnimation(
                child: buildDetailList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Widget buildDetailList() {
    List<Widget> foodWidgets = [];
    widget.beer['food_pairing']
        .forEach((food) => foodWidgets.add(buildSimpleText(food)));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildHeader("THIS BEER IS"),
        buildSimpleText(widget.beer['description']),
        buildHeader("BASICS"),
        buildValue("VOLUME", widget.beer['volume']['value'].toString() + widget.beer['volume']['unit'].toString()),
        buildValue("BOIL VOLUME", widget.beer['boil_volume']['value'].toString()+  widget.beer['boil_volume']['unit'].toString()),
        buildValue("ABV", widget.beer['abv'].toString()),
        buildValue("Target FG", widget.beer['target_fg'].toString()),
        buildValue("Target OG", widget.beer['target_og'].toString()),
        buildValue("EBC", widget.beer['ebc'].toString()),
        buildValue("SRM", widget.beer['srm'].toString()),
        buildValue("PH", widget.beer['ph'].toString()),
        buildValue("ATTENUATION LEVEL", widget.beer['attenuation_level'].toString()),
        buildHeader("FOOD PAIRING"),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: foodWidgets,
        ),
        buildHeader("BREWER\'S TIPS"),
        buildSimpleText(widget.beer['brewers_tips']),
        Container(
          height: 20.0,
        )
      ],
    );
  }

  Widget buildHeader(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.display1),
    );
  }

  Widget buildSimpleText(String message) {
    return Container(
      child: Text(
        message,
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.display3,
      ),
    );
  }

  Widget buildValue(String title, String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: Theme.of(context).textTheme.display2,
            ),
          ),
          Flexible(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                message,
                style: Theme.of(context).textTheme.display3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Work in progress

// Widget buildBeerDetailLayout(Beer beer) {
  //   return SingleChildScrollView(
  //     child: Container(
  //       child: Column(
  //         children: <Widget>[
  //           Container(
  //             height: 200,
  //             margin: EdgeInsets.only(left: 10, right: 10, top: 20),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.max,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 CachedNetworkImage(
  //                   imageUrl: beer.imageUrl,
  //                   height: 150.0,
  //                   width: 100.0,
  //                 ),
  //                 SizedBox(
  //                   width: 20.0,
  //                 ),
  //                 Flexible(
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Container(
  //                         height: 20.0,
  //                       ),
  //                       CustomFadeAnimation(
  //                         child: Text(
  //                           beer.name,
  //                           style: Theme.of(context).textTheme.title,
  //                         ),
  //                       ),
  //                       Container(
  //                         height: 10.0,
  //                       ),
  //                       CustomFadeAnimation(
  //                         child: Text(
  //                           beer.tagLine,
  //                           style: Theme.of(context).textTheme.display3,
  //                         ),
  //                       ),
  //                       Container(
  //                         height: 10.0,
  //                       ),
  //                       CustomFadeAnimation(
  //                         child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: <Widget>[
  //                               Flexible(
  //                                 flex: 2,
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: <Widget>[
  //                                     Text(
  //                                       "ABV",
  //                                       maxLines: 1,
  //                                       style: Theme.of(context)
  //                                           .primaryTextTheme
  //                                           .headline,
  //                                     ),
  //                                     Text(
  //                                       beer.abv,
  //                                       maxLines: 1,
  //                                       style: Theme.of(context)
  //                                           .primaryTextTheme
  //                                           .title,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               Flexible(
  //                                 flex: 2,
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: <Widget>[
  //                                     Text(
  //                                       "IBU",
  //                                       maxLines: 1,
  //                                       style: Theme.of(context)
  //                                           .primaryTextTheme
  //                                           .headline,
  //                                     ),
  //                                     Text(
  //                                       beer.ibu,
  //                                       maxLines: 1,
  //                                       style: Theme.of(context)
  //                                           .primaryTextTheme
  //                                           .title,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               Flexible(
  //                                   flex: 3,
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: <Widget>[
  //                                       Text(
  //                                         "OG",
  //                                         maxLines: 1,
  //                                         style: Theme.of(context)
  //                                             .primaryTextTheme
  //                                             .headline,
  //                                       ),
  //                                       Text(
  //                                         beer.targetOg,
  //                                         maxLines: 1,
  //                                         style: Theme.of(context)
  //                                             .primaryTextTheme
  //                                             .title,
  //                                         softWrap: false,
  //                                       ),
  //                                     ],
  //                                   ))
  //                             ]),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(left: 10.0, right: 10.0),
  //             child: CustomFadeAnimation(
  //               child: buildDetailList(beer),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
