import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'permission_util.dart';
import 'taskprovider.dart';
import 'taskscreen.dart';
import 'splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
  //await PermissionUtil.checkAndRequestStoragePermission();
    _showSplashScreen();
  }

  void _showSplashScreen() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: _showSplash ? SplashScreen() : TaskScreen(onToggleTheme: _toggleTheme),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}
