import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/init_screen.dart';
import '/screens/splash/splash_screen.dart';

import 'Provider/provider.dart';
import 'routes.dart';
import 'screens/home/home_screen.dart';
import 'theme.dart';

void main() {
  runApp( ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bidding App',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
