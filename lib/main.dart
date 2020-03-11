// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:damilk_app/src/resources/const.dart';
import './register_page.dart';
import './signin_page.dart';
import 'application.dart';
import 'package:damilk_app/src/router/app_router.dart';
import 'package:damilk_app/src/router/app_routing_names.dart';
import 'src/resources/colors.dart';
import 'src/repository/remote/api/auth_verifier_interceptor.dart';
import 'src/tools/localization/app_translations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final tutorialWatched =
      sharedPreferences.getBool(Const.MAIN_TUTORIAL_COMPLETED);
  final jwtToken = sharedPreferences.getString(Const.JWT_TOKEN);
  final isRegistered = sharedPreferences.getBool(Const.IS_REGISTERED);

  runApp(DamilkApp(
      tutorialWatched != null && tutorialWatched,
      jwtToken != null && jwtToken.isNotEmpty,
      isRegistered != null && isRegistered));
}

class DamilkApp extends StatefulWidget {
  static BuildContext context;
  final bool _tutorialWatched;
  final bool _loggedIn;
  final bool _registered;

  DamilkApp(this._tutorialWatched, this._loggedIn, this._registered);

  @override
  _DamilkHomePageState createState() {
    return _DamilkHomePageState(_loggedIn, _registered);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      home: MyHomePage(title: 'Firebase Auth Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _DamilkHomePageState extends State<DamilkApp> {
  final bool _loggedIn;
  final bool _registered;

  _DamilkHomePageState(this._loggedIn, this._registered);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Damilk',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
          primaryColor: AppColors.darkIndigo,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          fontFamily: Const.FONT_FAMILY_NUNITO,
          platform: TargetPlatform.android),
      navigatorKey: AuthVerifierInterceptor().navigatorKey,
      initialRoute: _getInitialRoute(_loggedIn, _registered),
      onGenerateRoute: (settings) => DamilkAppRouter.generateRoute(settings),
      localizationsDelegates: [
        const AppTranslationsDelegate(),
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: application.supportedLocales(),
    );
  }

  String _getInitialRoute(
      bool isLoggedIn, bool isRegistered) {
    return _loggedIn
            ? (isRegistered
                ? AppRoutes.DASHBOARD_SCREEN
                : AppRoutes.REGISTRATION_SCREEN)
            : AppRoutes.LOGIN_SCREEN;
  }
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: RaisedButton(
              child: const Text('Test registration'),
              onPressed: () => _pushPage(context, RegisterPage()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
          Container(
            child: RaisedButton(
              child: const Text('Test SignIn/SignOut'),
              onPressed: () => _pushPage(context, SignInPage()),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
