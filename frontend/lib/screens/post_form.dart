
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/models/api_response.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/services/post_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

import 'login.dart';


class PostForm extends StatefulWidget {
  final Post? post;
  final String? title;

  PostForm({
   this.post,
   this.title
});



  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _txtcontrollerBody = TextEditingController();
  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile ==  null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtcontrollerBody.text, image);

    if(response.error ==  null) {
      Navigator.of(context).pop();
    }
    else if (response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _editPost(int postId) async {
    ApiResponse response = await editPost(postId, _txtcontrollerBody.text);
    if (response.error == null) {
      Navigator.of(context).pop();
    }
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.error}')
      ));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState(){
    if(widget.post != null){
      _txtcontrollerBody.text = widget.post!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) :ListView(
        children: [
          widget.post != null ? SizedBox() :
          Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            image: _imageFile == null ? null : DecorationImage(image: FileImage(_imageFile ?? File('')),
            fit: BoxFit.cover
            )
          ),
          child: Center(
            child: IconButton(
              icon: Icon(Icons.image, size: 50, color: Colors.black38),
              onPressed: (){
                getImage();
              },
            ),
          ),
          ),
          Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: _txtcontrollerBody,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                validator: (val) =>val!.isEmpty ? 'Post Body is required' : null,
                decoration: InputDecoration(
                  hintText: "Post Body...",
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38))
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: KTextButton('Post', (){
                if(_formkey.currentState!.validate()){
                  setState(() {
                    _loading = !_loading;
                  });
                  if(widget.post == null){
                  _createPost();
                } else {
                  _editPost(widget.post!.id ?? 0);
                  }
              }
            }),
          ),
        ],
      ),
    );
  }
}
