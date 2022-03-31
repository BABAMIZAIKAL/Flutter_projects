import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {

  String comment_name;
  String comment_text;
  String? comment_image;

  //Comment(this.comment_name, this.comment_text);

  Comment(this.comment_name, this.comment_text, [this.comment_image]);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  
}