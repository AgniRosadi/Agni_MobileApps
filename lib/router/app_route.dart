import 'package:flutter/material.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/views/crud/add_data.dart';
import 'package:untitled1/views/crud/read.dart';
import 'package:untitled1/views/crud/update.dart';
import 'package:untitled1/views/home.dart';
import 'package:untitled1/views/menu.dart';

class AppRoute {
  static const rMain = '/';
  static const rHome = '/home';
  static const rMenu = '/menu';
  static const rAdd = '/add';
  static const rUpdate = '/update';
  static const rRead = '/read';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case rMain:
        return _buildRoute(settings, const MainPage());
      case rHome:
        return _buildRoute(settings, const HomePage());
      case rMenu:
        return _buildRoute(settings, const MenuPage());
      case rAdd:
        return _buildRoute(settings, const AddDataPage());
      case rUpdate:
        return _buildRoute(settings, const UpdatePage());
      case rRead:
        return _buildRoute(settings, const ReadPage());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text("Page not found : ${settings.name}"),
              ),
            ));
    }
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
