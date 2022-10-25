import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fatwa/Dimensions.dart';
import 'DimensionsGetStarted.dart';


class Intropage1 extends StatefulWidget {
  var link ;
  var boldtext;
  var text;
  Intropage1({Key? key, required this.link,required this.boldtext,required this.text}) : super(key: key);
  

  @override
  State<Intropage1> createState() => _Intropage1State();
}

class _Intropage1State extends State<Intropage1> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(widget.link,height: DimensionsGetStarted.imageHeight,),
          SizedBox(height: DimensionsGetStarted.introheight30),
          Text(widget.boldtext,style: TextStyle(fontWeight: FontWeight.bold,fontSize: DimensionsGetStarted.fontsize20),textAlign: TextAlign.center,),
          SizedBox(height: DimensionsGetStarted.introheight20,),
          Text(widget.text,textAlign: TextAlign.center)
        ],
      ),
    );
    
  }
}