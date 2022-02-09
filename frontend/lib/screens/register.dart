import 'package:flutter/material.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'login.dart';

class Register extends StatefulWidget {

  @override
  _RegisterState createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> formKey =GlobalKey<FormState>();
  bool loading = false;
  TextEditingController
  nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  void _registerUser () async {
    ApiResponse response = await register(nameController.text, emailController.text, passwordController.text);
    if(response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    }
    else {
      setState(() {
        loading = !loading;
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
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
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
                controller: nameController,
                validator: (val) => val!.isEmpty ? 'Invalid name' : null,
                decoration: KInputDecoration('Name')

            ),
            SizedBox(height: 20,),
            TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                decoration: KInputDecoration('E-Mail')
            ),
            SizedBox(height: 20,),
            TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Required at least 6 chars' : null,
                decoration: KInputDecoration('Password')
            ),
            SizedBox(height: 20,),
            TextFormField(
                controller: passwordConfirmController,
                obscureText: true,
                validator: (val) => val != passwordController.text ? 'Confirm password does not match' : null,
                decoration: KInputDecoration('Confirm password')
            ),
            SizedBox(height: 20,),
            loading ?
            Center(child: CircularProgressIndicator())
                : KTextButton('Register', () {
              if(formKey.currentState!.validate()){
                setState(() {
                  loading = !loading;
                  _registerUser();

                });
              }
            },
            ),
            SizedBox(height: 20,),
            kLoginRegisterHint('Already have an account? ', 'Login', (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
            })
          ],
        ),
      ),
    );
  }
}
