import 'package:flutter/material.dart';
import 'package:pirosfogo/helpers/DBHelper.dart';
import 'package:pirosfogo/screens/MainMenuScreen.dart';

main(List<String> args) {
  runApp(MyApp());
  DBHelper.init().then((value) => DBHelper.openDB());
}

class MyApp extends StatelessWidget {
  static const Color darkColor = const Color(0xFF101010);
  static const Color primaryColor = Color(0xFF671010);
  static const Color secondaryColor = const Color(0xFFFDA825);
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = const TextTheme(
      headline1: TextStyle(color: Colors.pink),
      headline2: TextStyle(color: Colors.pink),
      headline3: TextStyle(color: Colors.pink),
      headline4: TextStyle(color: Colors.pink),
      headline5: TextStyle(color: Colors.pink),
      headline6: TextStyle(
          color: darkColor, fontWeight: FontWeight.bold, fontSize: 32),
      subtitle1: TextStyle(color: secondaryColor, fontSize: 24),
      subtitle2: TextStyle(color: Colors.pink),
      bodyText1: TextStyle(color: Colors.pink),
      bodyText2: TextStyle(color: secondaryColor, fontSize: 18),
      caption: TextStyle(color: Colors.pink),
      button: TextStyle(color: Colors.pink),
      overline: TextStyle(color: Colors.pink),
    );
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(secondaryColor),
            foregroundColor: MaterialStateProperty.all(darkColor),
            fixedSize: MaterialStateProperty.all(Size(200, 50)),
            textStyle: MaterialStateProperty.all(TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryColor,
          foregroundColor: darkColor,
        ),
        scaffoldBackgroundColor: darkColor,
        primaryColor: primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          iconTheme: IconThemeData(color: darkColor),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: secondaryColor.withAlpha(60),
          selectionColor: secondaryColor.withAlpha(60),
          selectionHandleColor: secondaryColor.withAlpha(60),
        ),
        textTheme: textTheme,
        primarySwatch: Colors.yellow,
        hintColor: secondaryColor.withAlpha(100),
        cardColor: primaryColor,
        // buttonColor: Colors.yellow,
        // primaryColorDark: Colors.pink,
        // bottomAppBarColor: Colors.pink,
        // canvasColor: Colors.pink,
        // cardColor: Colors.pink,
        // cursorColor: Colors.pink,
        // dividerColor: Colors.pink,
        // dialogBackgroundColor: Colors.pink,
        // disabledColor: Colors.pink,
        // highlightColor: Colors.pink,
        // hintColor: Colors.pink,
        // errorColor: Colors.pink,
        // focusColor: Colors.pink,
        // hoverColor: Colors.pink,
        // indicatorColor: Colors.pink,
        // primaryColorLight: Colors.pink,
        // shadowColor: Colors.white,
        // splashColor: Colors.black,
        // selectedRowColor: Colors.pink,
        // textSelectionColor: Colors.pink,
        // secondaryHeaderColor: Colors.pink,
        // toggleableActiveColor: Colors.pink,
        // unselectedWidgetColor: Colors.pink,
        // textSelectionHandleColor: Colors.pink,
      ),
      home: MainMenuScreen(),
    );
  }
}
