import 'package:flutter/material.dart';
import 'package:frontend/screens/post_form.dart';
import 'package:frontend/screens/post_screen.dart';
import 'package:frontend/screens/profile.dart';
import 'package:frontend/services/user_service.dart';

import 'login.dart';


class Home extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Home> {
  int currentIndex = 0;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title : Text('Appartement-Me'),
        backgroundColor:  Color( 0xff0111ff),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              logout().then((value) => {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
              });
            },
          )
        ],
      ),

      body: currentIndex == 0? PostScreen() : Profile(),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PostForm(
            title: 'Add New Post',
          )));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xffff5c00),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),

              label: ''
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),

                label: ''
            )
          ],

          currentIndex: currentIndex,
          onTap: (val){
            setState(() {
              currentIndex = val;
            });
          },
        ),
      ),
    );
  }
}
