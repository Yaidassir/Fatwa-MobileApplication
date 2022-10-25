

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentBoxx extends StatefulWidget {
  final Widget image;
  final TextEditingController controller;
  final BorderRadius inputRadius;


  const CommentBoxx({required this.image,required this.controller,
  required this.inputRadius}) ;

  @override
  _CommentBoxxState createState() => _CommentBoxxState();
}

class _CommentBoxxState extends State<CommentBoxx> {
  late Widget image;

  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          indent: 20,
          endIndent: 20,
          height: 1,
          color: Colors.grey[300],
          thickness: 1,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          autofocus: true,
          decoration: InputDecoration(
            fillColor: Colors.grey[200],
            suffixIcon: IconButton(
              icon: Icon(Icons.send,color: Theme.of(context).primaryColor,),
              onPressed: (){

              },
            ),
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: widget.inputRadius,
            ),
          ),
        ),
      ],
    );
  }




}