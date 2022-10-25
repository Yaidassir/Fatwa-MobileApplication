import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../Welcome/welcome_screen.dart';
import 'DimensionsGetStarted.dart';
import 'IntroPage.dart';

class getstarted extends StatefulWidget {
  

  @override
  State<getstarted> createState() => _getstartedState();
}

class _getstartedState extends State<getstarted> {

      final PageController controller = PageController(initialPage: 0);
       var currpagevalue=0.0;


     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {
        currpagevalue=controller.page!;
      });
    });
  }

    void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => WelcomeScreen()),
    );
  }
bool onlastpage = false;

  @override
  Widget build(BuildContext context) {
     PageController controller = PageController();
     
 
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: DimensionsGetStarted.introwidth40,right: DimensionsGetStarted.introwidth40,bottom: DimensionsGetStarted.introheight100),
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  onlastpage=(index==2);
                });
              },
              controller: controller,
              children: [
                  Intropage1(
                    link: 'assets/images/Group152.png',
                    boldtext: 'مرحبا بك في فتوى',
                    text: "الموقع الدي تجد فيه كل أسئلتك المطروحة",
                  ),
                  Intropage1(
                    link: 'assets/images/Group151.png',
                    boldtext: "اطرح فتواك هنا",
                    text: "جد المنشورات و الفتاوى التي كانت تشغل بالك"),
                  Intropage1(
                    link: 'assets/images/Group154.png',
                    boldtext: "هيا لنبدأ",
                    text: "قم بإنشاء حسابك الخاص"),
              ],
            ),
          ),
          Container(
            alignment: Alignment(0,0.45),
            /// dependency : smooth_page_indicator: ^1.0.0+2
            child: SmoothPageIndicator(controller: controller, count: 3,effect: ExpandingDotsEffect(dotHeight: 8, dotWidth: 8,spacing: 16,),)
          ),
          Positioned(
            bottom: DimensionsGetStarted.introheight40,
            child: RaisedButton(
                      onPressed: () { 
                        onlastpage?
                        _onIntroEnd(context) : controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: <Color> [Color(0xFF023047),Color(0xFF126782)]),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        
                        child: Container(
                          constraints: BoxConstraints(minWidth: DimensionsGetStarted.buttonwidth, minHeight: DimensionsGetStarted.buttonheight), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Text(
                            onlastpage? 'Get Started':'Next',style: TextStyle(fontSize: 20,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
          ),
           Positioned(
            top: DimensionsGetStarted.titletop50,
            child: Row(  
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                      Image.asset("assets/icons/islamique.png",width: 30,height: 30,),
                      SizedBox(width: DimensionsGetStarted.introwidth10,),
                      const Text("فتوى",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    ],
                  ),)
        ],
      )
    );
  }
}



/*


PageView(

      controller: controller,
      children:  <Widget>[
        Scaffold(
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Center(child: Text("MC Entity."),),
                  Image( image: AssetImage('../../../../../../../assets/images/Introductionscreen.jpg'),height: 250,),
                  new DotsIndicator(
                    dotsCount: 3,
                    position: currpagevalue,
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0,9.0),
                      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
                    ),

                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      onPressed: () { },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: <Color> [Color(0xFF023047),Color(0xFF126782)]),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Next',style: TextStyle(fontSize: 20,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        Scaffold(
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Center(child: Text("MC Entity."),),
                  Image( image: AssetImage('../../../../../../../assets/images/Introductionscreen.jpg'),height: 250,),
                  new DotsIndicator(
                    dotsCount: 3,
                    position: currpagevalue,
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0,9.0),
                      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
                    ),

                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      onPressed: () { },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: <Color> [Color(0xFF023047),Color(0xFF126782)]),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Next',style: TextStyle(fontSize: 20,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        Scaffold(
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Center(child: Text("MC Entity."),),
                  Image( image: AssetImage('../../../../../../../assets/images/Introductionscreen.jpg'),height: 250,),
                  new DotsIndicator(
                    dotsCount: 3,
                    position: currpagevalue,
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0,9.0),
                      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
                    ),

                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      onPressed: () { },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: <Color> [Color(0xFF023047),Color(0xFF126782)]),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Next',style: TextStyle(fontSize: 20,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );

    */



    /*



    Scaffold(
      body: Column(
        children: [
          Center(child: Title(color: Colors.black, child: Text("MC Entity."),)),
              PageView(
                controller: controller,
                children:  <Widget>[
                  Column(
                    children: [
                     Text("MC Entity."),
                    Image( image: AssetImage('../../../../../../../assets/images/Introductionscreen.jpg'),height: 250,),
                    Text('First Page',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Some deep shit is going on in here mate , mind solving it '),
                    ],
                  ),
                  Column(
                    children: [
                    Center(child: Text("MC Entity."),),
                    Image( image: AssetImage('../../../../../../../assets/images/Introductionscreen.jpg'),height: 250,),
                    Text('First Page',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Some deep shit is going on in here mate , mind solving it '),
                    ],
                  ),
                  Column(
                    children: [
                    Center(child: Text("MC Entity."),),
                    Image( image: AssetImage('../../../../../../../assets/images/Introductionscreen.jpg'),height: 250,),
                    Text('First Page',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('Some deep shit is going on in here mate , mind solving it '),
                    ],
                  )
                ],
              ),
              DotsIndicator(
                  dotsCount: 3,
                    position: currpagevalue,
                    decorator: DotsDecorator(
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0,9.0),
                      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))
              )),
              RaisedButton(
                      onPressed: () { },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      padding: const EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: <Color> [Color(0xFF023047),Color(0xFF126782)]),
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: const Text(
                            'Next',style: TextStyle(fontSize: 20,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),


        ]),

    );



    */