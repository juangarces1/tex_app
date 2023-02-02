import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tex_app/Screens/home_screen.dart';
import 'package:tex_app/Screens/login_screen.dart';
import 'package:tex_app/Screens/wait_screen.dart';

import 'Models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  bool _showLoginPage = true;
 
  late User _user;

   @override
  void initState() {
    super.initState();
    _getHome();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Tex App',
      theme: ThemeData(
          useMaterial3: true,
        textTheme: GoogleFonts.oswaldTextTheme(Theme.of(context).textTheme)
      ),
      home: _isLoading 
        ? const WaitScreen() 
        : _showLoginPage 
          ? const LoginScreen() 
          : HomeScreen(user: _user,),
    );    
  }

  void _getHome() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isRemembered = prefs.getBool('isRemembered') ?? false;   
    if (isRemembered) {
      String? userBody = prefs.getString('userBody');
      if (userBody != null) {
        var decodedJson = jsonDecode(userBody);
        _user = User.fromJson(decodedJson);       
          _showLoginPage = false;       
      }
    }     
    _isLoading = false;
    setState(() {});
  }
}


