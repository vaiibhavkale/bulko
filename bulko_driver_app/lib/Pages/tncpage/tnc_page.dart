import 'dart:convert';

import 'package:driver/Locale/locales.dart';
import 'package:driver/Pages/drawer.dart';
import 'package:driver/Theme/colors.dart';
import 'package:driver/baseurl/baseurlg.dart';
import 'package:driver/beanmodel/aboutus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TNCPage extends StatefulWidget {
  @override
  TNCPageState createState() => TNCPageState();
}

class TNCPageState extends State<TNCPage> {
  var userName;
  bool? isLogin = false;
  dynamic title;
  dynamic content;

  // AboutUsData data;

  @override
  void initState() {
    super.initState();
    getWislist();
  }

  void getWislist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userName = pref.getString('user_name');
      isLogin = pref.getBool('islogin');
    });
    var url = appTermsUri;
    var http = Client();
    http.get(url).then((value) {
      print('resp - ${value.body}');
      if (value.statusCode == 200) {
        AboutUsMain data1 = AboutUsMain.fromJsom(jsonDecode(value.body));
        print('${data1.toString()}');
        if (data1.status == "1" || data1.status == 1) {
          setState(() {
            title = data1.data.title;
            content = data1.data.description;
          });
        }
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      drawer: AccountDrawer(),
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          locale.tnc!,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Image.asset(
              'assets/icon1.png',
              scale: 2.5,
              height: 280,
            ),
            Text(
              (title != null) ? '$title' : '',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[400]),
            ),
            SizedBox(
              height: 20,
            ),
            (content != null)
                ? Html(
                    data: content,
                    style: {
                      "html": Style(
                        fontSize: FontSize.large,
                      ),
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
