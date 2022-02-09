import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/services/user_service.dart';


import 'login.dart';

class loading extends StatefulWidget {
  const loading({Key? key}) : super(key: key);

  @override
  _loadingState createState() => _loadingState();
}

class _loadingState extends State<loading> {


  void _loadUserInfo() async {
  String token = await getToken();
  if(token == '')
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false);
    }
    else
    {
      ApiResponse response = await getUserDetail();
      if(response.error == null)
      {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (route) => false);
      }
      else if (response.error == unauthorized)
      {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
        }
      }
  }

  @override
  void initState(){
    _loadUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(

      height: MediaQuery.of(context).size.height,
      color: Colors.white,

      child: Center(
        child: CircularProgressIndicator(
          valueColor:AlwaysStoppedAnimation<Color>(Color( 0xff0111ff)),
        ),
      ),
    );
  }
}
