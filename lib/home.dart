import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:game/themes.dart';
import 'package:game/upgrades.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool flag = false;
  int _highscore = 0;
  int coins = 0;
  Color themeColor = curTheme;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _animationController.addListener(() => setState(() {}));
  }

  Future<void> getHighScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highscore = prefs.getInt('highScore') ?? 0;
      coins = prefs.getInt('coins') ?? 0;
      themeColor = test[prefs.getInt('theme') ?? 0];
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getHighScore();
    if (_animationController.value == 1) return Game();
    return Scaffold(
        backgroundColor: themeColor,
        body: Column(children: [
          SizedBox(height: 50),
          Align(
            alignment: Alignment.topCenter,
            child: ClayContainer(
                emboss: true,
                height: 250,
                width: 250,
                borderRadius: 50,
                color: themeColor,
                child: Center(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: LiquidLinearProgressIndicator(
                    value: _animationController.value,
                    valueColor: AlwaysStoppedAnimation(Colors.pink),
                    backgroundColor: Colors.grey[200],
                    borderColor: themeColor,
                    borderWidth: 0.0,
                    direction: Axis.vertical,
                    center: ClayText(
                      (_animationController.value * 100).toInt().toString(),
                      emboss: true,
                      size: 50,
                      color: _animationController.value >= 0.55
                          ? Colors.pink
                          : Colors.grey[200],
                    ),
                  ),
                ))),
          ),
          SizedBox(height: 50),
          InkWell(
              child: ClayContainer(
                color: themeColor,
                width: 150,
                height: 55,
                customBorderRadius: BorderRadius.all(Radius.circular(40)),
                child: Center(
                    child: ClayText(
                  "Start!",
                  emboss: true,
                  size: 25,
                  color: themeColor,
                )),
              ),
              onTap: () {
                setState(() {
                  _animationController.forward();
                });
              }),
          SizedBox(height: 25),
          InkWell(
              child: ClayContainer(
                color: themeColor,
                width: 150,
                height: 55,
                customBorderRadius: BorderRadius.all(Radius.circular(40)),
                child: Center(
                    child: ClayText(
                  "Upgrades",
                  emboss: true,
                  size: 25,
                  color: themeColor,
                )),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Upgrades()),
                );
              }),
          SizedBox(height: 50),
          ClayText(
            "Highscore: " + _highscore.toString(),
            emboss: true,
            size: 35,
            color: themeColor,
          ),
          SizedBox(height: 10),
          ClayText(
            "Coins: " + coins.toString(),
            emboss: true,
            size: 35,
            color: themeColor,
          ),
        ]));
  }
}