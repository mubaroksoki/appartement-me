
import 'package:flutter/material.dart';

const baseURL = 'http://192.168.1.24:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

InputDecoration KInputDecoration(String label){
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color( 0xff0111ff), width: 2.0),
          ),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black))

  );
}

TextButton KTextButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(fontSize: 18.0 ,color: Colors.white), ),
    style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) =>  Color(
            0xff0111ff)),
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 20))

    ), onPressed: () => onPressed(),
  );
}

Row kLoginRegisterHint(String text, String label, Function onTap){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label, style: TextStyle(color: const Color( 0xff0111ff))),
        onTap: () => onTap(),
      )
    ],
  );
}

Expanded kLikeAndComment (int value, IconData icon , Color color, Function onTap){
  return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => onTap(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: color,),
                SizedBox(width:4),
                Text('$value')
              ],
            ),
          ),
        ),
      )
  );
}