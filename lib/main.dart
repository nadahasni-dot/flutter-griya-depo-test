import 'package:flutter/material.dart';
import 'package:flutter_griya_depo_test/providers/achievement_provider.dart';
import 'package:provider/provider.dart';

import 'routes/app_routes.dart';
import 'routes/route_names.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AchievementProvider(),
      child: MaterialApp(
        title: 'Flutter Griya Test',
        routes: AppRoute.routes,
        debugShowCheckedModeBanner: false,
        initialRoute: RouteNames.homeScreen,
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}
