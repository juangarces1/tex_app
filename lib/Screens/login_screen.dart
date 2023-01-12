
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tex_app/Components/default_button.dart';
import 'package:tex_app/Components/loader_component.dart';
import 'package:tex_app/Helpers/constans.dart';
import 'package:tex_app/Models/user.dart';
import 'package:tex_app/Screens/home_screen.dart';
import 'package:tex_app/constans.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;
  bool _passwordShow = false;

  bool _showLoader = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: 
      Container(
        color: kColorFondoOscuro,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 100,), 
                  const Text('TexApp', style: TextStyle(color: kContrastColor, fontSize: 30, fontWeight: FontWeight.bold, ),),
                     const SizedBox(height: 20,),
                  _showLogo(),              
                  const SizedBox(height: 20,),
                
                  _showPassword(),
                  _showRememberme(),
                  _showButtons(),
                  
                ],
              ),
            ),
            _showLoader ? const LoaderComponent(text: 'Por favor espere...') : Container(),
          ],
        ),
      ),
    );
  }

  Widget _showLogo() {
    return const Image(
      image: AssetImage('assets/rollostela.png'),
      width: 200,
      fit: BoxFit.fill,
    );
  }

  Widget _showPassword() {
    return Container(
     padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
      child: TextField(
         style:  const TextStyle(color: Colors.white ),  
        obscureText: !_passwordShow,
        decoration: InputDecoration(
           labelStyle: const TextStyle(color: Colors.white ),
          hintStyle: const TextStyle(color: Colors.white ),
          errorStyle: const TextStyle(color: Colors.white ),
          suffixStyle:  const TextStyle(color: Colors.white ),
          hintText: 'Ingresa tu contraseña...',
          labelText: 'Contraseña',
          errorText: _passwordShowError ? _passwordError : null,
          prefixIcon: const Icon(Icons.lock,  color: Colors.white,),
          suffixIcon: IconButton(
            icon: _passwordShow ? const Icon(Icons.visibility,  color: Colors.white,) : const Icon(Icons.visibility_off,  color: Colors.white,),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            }, 
          ),
           enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), 
              borderSide: const BorderSide(color: Colors.white, width: 1.0),
          ),  
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showRememberme() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
      child: CheckboxListTile(
        title: const Text('Recuerdame', style:  TextStyle(color: Colors.white ),),
        value: _rememberme,
        onChanged: (value) {  
          setState(() {
            _rememberme = value!;
          });
        }, 
      ),
    );
  }

   Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showLoginButton(),
        ],
      ),
    );
  }

void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
  }


  void _login() async {
    setState(() {
      _passwordShow = false;
    });

    if(!_validateFields()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });
     

    var url = Uri.parse('${Constans.apiUrl}/api/Kilos/LogIn/$_password');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
     
    
    );

    setState(() {
      _showLoader = false;
    });

    if(response.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = "Contraseña incorrecta";
      });
      return;
    }

    var body = response.body;

    if (_rememberme) {
      _storeUser(body);
    }

    var decodedJson = jsonDecode(body);
    
    User user = User.fromJson(decodedJson);
    
    goHome(user);

   
  }

  bool _validateFields() {
    bool isValid = true;

  

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu contraseña.';
    }  else {
      _passwordShowError = false;
    }

    setState(() { });
    return isValid;
  }

  Widget _showLoginButton() {
    return DefaultButton(text: 'Iniciar Sescion', press: () => _login(),);
  }
  
  void goHome(User user) {
  
     Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: user,)
      )
    );

  }
  

}

