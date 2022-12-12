import 'dart:convert';

import 'package:ehentai_browser/crawler/util/color.dart';
import 'package:ehentai_browser/crawler/widget/app_bar_ehen.dart';
import 'package:ehentai_browser/crawler/widget/checkEhenCata.dart';
import 'package:ehentai_browser/crawler/xhenhttp/dao/xhen_dao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ehentai_crawler.dart';
import 'model/gallery_object.dart';
import 'util/theme.dart';

class Xhen extends StatefulWidget {
  const Xhen({Key? key}) : super(key: key);

  @override
  State<Xhen> createState() => _XhenState();
}

class _XhenState extends State<Xhen> {
  late List<Gallery> glist;

  var next;
  var search;
  var cata;

  @override
  void initState() {
    glist = [];
    // _searchGallerys(true);
    Future.delayed(
        Duration.zero,
        () => setState(() {
              _searchGallerys(false);
            }));
  }

  _searchGallerys(bool isCleanAll) async {
    if (isCleanAll) glist.clear();

    var html;
    html = await requestData(search: search, cataNum: cata, next: next);

    var gls = get_gallery_list(html);
    var nextUrl = get_next_page_url(html);
    next = nextUrl?.substring(nextUrl.lastIndexOf("=") + 1, nextUrl.length);

    var gplist = [];

    for (var g1 in gls) {
      var gparams = g1?.split("/");
      gplist.add([gparams![gparams.length - 3], gparams[gparams.length - 2]]);
    }

    var result = await XhenDao.get_gallery(gplist);
    var jresult = jsonDecode(result)['gmetadata'];
    if (jresult == null || jresult == '') {
      glist.clear();
      setState(() {});
      return;
    }
    for (var g in jresult) {
      Gallery gl = Gallery(g['thumb'], g['title'], g['filecount'],
          g['category'], g['tags'], g['rating']);
      glist.add(gl);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(104.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ehenAppBar(
              (text) async {
                next = '';
                search = text;
                cata = '';
                await _searchGallerys(true);
              },
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 4),
              alignment: Alignment.center,
              child: EhenCheck((cataNum) {
                cata = '$cataNum';
              }),
            ),
          ],
        ),
      ),
      body: glist.length <= 0
          ? Container()
          : ListView(
              children: [
                get_gallery_rows_list(),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: _nextButton(),
                ),
              ],
            ),
    );
  }

  _nextButton() {
    return Column(
      children: <Widget>[
        TextButton(
          child: Text(
            "NEXT >>",
            style: TextStyle(
              fontSize: 36,
              color: isDarkMode(context) ? Colors.white60 : primary,
            ),
          ),
          onPressed: () async {
            await _searchGallerys(false);
          },
        ),
      ],
    );
  }

  get_gallery_rows_list() {
    Widget content;
    List<Widget> ww = [];
    for (Gallery g in glist) {
      ww.add(get_gallery_row(g));
      ww.add(Divider(
        height: 1,
        color: Colors.grey,
      ));
    }
    content = Column(
      children: ww,
    );
    return content;
  }

  get_gallery_row(Gallery g) {
    return Container(
        height: 150,
        child: InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                g.url,
                height: 130,
                width: 110,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 25),
              SizedBox(
                // color: Colors.yellow,
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250,
                      child: Text(
                        '${g.title}  (${g.image_count}P)',
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color:
                              isDarkMode(context) ? Colors.white : Colors.black,
                          decoration: TextDecoration.none,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Category: ${g.cata}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffff9db5),
                          decoration: TextDecoration.none),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Rating: ${g.rating}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffff9db5),
                          decoration: TextDecoration.none),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
