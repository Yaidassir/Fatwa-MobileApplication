import 'dart:ui';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fatwa/Dimensions.dart';

class Search extends StatefulWidget {
    List categorie = [];
    Search({required this.categorie});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  PageController pageController = PageController(viewportFraction: 0.85);
  


  @override
  void initState() {
    super.initState();
    pageController.addListener(() {     
      setState(() {
        currentpagevalue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
  



  var currentpagevalue=0.0;
  double scalefactor=0.8;
  double height =Dimensions.PageViewContainer;

 

  

  @override
  Widget build(BuildContext context) {
     TabController tabcontr = TabController(length: 3, vsync:this );
    return  Column(
      children: [
        Container(
              height: Dimensions.PageView,
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.categorie.length,
                itemBuilder: (context,position){
                  return _buildpageitem(position);
                }),
            ),
            //  DotsIndicator(
            //         dotsCount: widget.categorie.length,
            //         position: currentpagevalue,
            //         decorator: DotsDecorator(
            //           size: const Size.square(9.0),
            //           activeSize: const Size(18.0, 9.0),
            //           activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            //                                  ),
            //   ),
              SizedBox(height: Dimensions.height10,),
              Container(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context,index){
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal :5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300]
                      ),
                      child: Text('Family'),
                    );
                  },
                ),

              )

      ],
    );

    
  }

  Widget _buildpageitem(int index){
    Matrix4 matrix = new Matrix4.identity();
    if (index == currentpagevalue.floor()){
      var currscale = 1-(currentpagevalue-index)*(1-scalefactor);
      var currtransform = height*(1-currscale)/2;
      matrix = Matrix4.diagonal3Values(1, currscale, 1)..setTranslationRaw(0,currtransform,0);
    }else if(index ==currentpagevalue.floor()+1){
      var currscale = scalefactor+(currentpagevalue-index+1)*(1-scalefactor);
      var currtransform = height*(1-currscale)/2;
      matrix = Matrix4.diagonal3Values(1, currscale, 1)..setTranslationRaw(0,currtransform,0);
    }else if(index ==currentpagevalue.floor()-1){
      var currscale = 1-(currentpagevalue-index)*(1-scalefactor);
      var currtransform = height*(1-currscale)/2;
      matrix = Matrix4.diagonal3Values(1, currscale, 1);
      matrix = Matrix4.diagonal3Values(1, currscale, 1)..setTranslationRaw(0,currtransform,0);
    }else{
      var currscale=0.8;
      matrix = Matrix4.diagonal3Values(1, currscale, 1)..setTranslationRaw(1, height*(1-currscale)/2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            height: Dimensions.PageViewContainer,
            margin: EdgeInsets.only(left: 5,right: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                 BoxShadow(
                color: Color(0xFFe8e8e8),
                blurRadius: 5.0,
                offset: Offset(0,5),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-5,0)
              ),
               BoxShadow(
                color: Colors.white,
                offset: Offset(5,0)
              )
              ],
              color: Colors.blue[300],
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/psdd_03_06_2022_112.jpg')
              )
            ),
            child: ClipRRect( // make sure we apply clip it properly
            borderRadius: BorderRadius.circular(30),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
          color: Colors.grey.withOpacity(0.1),

        alignment: Alignment.center,
        

      ),
    )),
          ),
          Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: double.maxFinite,
                            height: Dimensions.PageViewTextContainer,        
                            margin: EdgeInsets.only(left: 40,right: 40,bottom: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                                            boxShadow: const [
                                                BoxShadow(
                                                color: Color(0xFFe8e8e8),
                                                blurRadius: 5.0,
                                                offset: Offset(0,5),
                                              ),
                                              BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(-5,0)
                                              ),
                                              BoxShadow(
                                                color: Colors.white,
                                                offset: Offset(5,0)
                                              )
                                              ],
                            ),
                            child: Center(child: Text(widget.categorie[index],style: TextStyle(fontSize: Dimensions.font20,color: Colors.blue[300],letterSpacing: 3),),),
    
                          ),
                  )
      
        ],
      ),
    );
  }
}