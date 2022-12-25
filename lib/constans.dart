
import 'package:flutter/material.dart';
import 'package:tex_app/sizeconfig.dart';

 
const kColorSaveButton =   Color(0xFF9ea0ca);


 const kPrimaryColor = Color(0xFF0c127b);
 const kMediumColor =  Color(0xFF6d71b0);
 const kPrimaryLightColor = Color(0xFFced0e5);
 const kContrastColor=Color(0xFFe7e7f2);
 const kContrastColorMedium=Color(0xFFb6b8d7);
const kColorMyLogo = Color(0xFF02661d);
const kColorAlternativo = Color.fromARGB(255, 37, 121, 218);


const kTextColorBlack = Colors.black87;
const kTextColorWhite= Color.fromARGB(204, 236, 231, 231);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kPrimaryColor, kColorMyLogo],
);
const kGradientTexApp = LinearGradient(colors: [ Color(0xffc91047), Color(0xffc94216)]);
const kGradientAppBarHome = LinearGradient(colors: [Color.fromARGB(255, 101, 5, 139), Color(0xffc91047) ]);
const kAlternativeGradientColor = LinearGradient(colors: [Colors.pink, Colors.green]);
const kNewPedidoColor =Color(0xFF185152);
const kSecondaryColor = Color(0xFF5559a3);
const kTextColor = Color(0xFF757575);
const kBlueColorLogo =Color(0xFF175fb1);
const inActiveIconColor =  Color(0xFFB6B6B6);
const kColorFondoOscuro = Color.fromARGB(255, 70, 72, 77);
const kContrateFondoOscuro = Color.fromARGB(255, 232, 236, 240);
const kColorNuevoPedido = Color.fromARGB(255, 5, 94, 121);
const kColorHomeBar =  Color.fromARGB(255, 60, 2, 94);

const kPrimaryText = Color(0xFFFF7643);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

const kPrimaryColor2 = Color(0xFF0C9869);
const kTextColor2 = Color(0xFF3C4046);
const kBackgroundColor = Color(0xFFF9F8FD);

const double kDefaultPadding = 20.0;

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextColor),
  );
}