import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'register.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if(response.error == null)
      {
        _saveAndRedirectToHome(response.data as User);

      }
      else
        {
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${response.error}')
          ));


        }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),


      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [

            Text(
              'Welcome to ',
              textAlign: TextAlign.left,
              style: TextStyle(color: const Color(0xff212932), fontSize: 24, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
            ),

            Text(
              'Appartement-Me! ',
              textAlign: TextAlign.left,
              style: TextStyle(color: const Color(0xff212932), fontSize: 24, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 60),

            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              validator: (val) => val!.isEmpty ? 'invalid email address' : null,
              decoration: KInputDecoration('E-Mail')
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: txtPassword,
              obscureText: true,
              validator: (val) => val!.length < 6 ? 'required at least 6' : null,
              decoration: KInputDecoration('Password')
            ),
            SizedBox(height: 44,),
            KTextButton('Login', () {
              if(formkey.currentState!.validate()){
                setState(() {
                  loading = true;
                  _loginUser();
                });
              }
            }),
            SizedBox(height: 20,),
            kLoginRegisterHint('dont have an account?', 'Register', (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Register()), (route) => false);
            })
          ],
        ),
      ),
    );
  }
}


