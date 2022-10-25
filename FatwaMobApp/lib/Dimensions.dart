
class Dimensions{
  static double screenheight = 810.6666666666666
;
  static double screenwidth = 384.0;

  static double PageView= screenheight/4.4;
  static double PageViewContainer = screenheight/6.67;
  static double PageViewTextContainer = screenheight/13.34;

  //dynamic height padding and margin
  static double height10 = screenheight/66.7;
  static double height20 = screenheight/33.35;
  static double height25 = screenheight/26.68;
  static double height30 = screenheight/22.33;
  static double height35 = screenheight/19.05;

  //dynamic width padding and margin
  static double width10 = screenheight/66.7;
  static double width20 = screenheight/33.35;
  static double width30 = screenheight/22.23;
  static double width40 = screenheight/16.675;

  static double height200 = screenheight/3.335;




  static double font20 = screenheight/33.35;

  /// Card Widget Height ..
  static double ListViewCardWidget = screenwidth/1.875;
  static double ListViewCardRatingStars = screenwidth/7.5;

}

/*

      body: SingleChildScrollView(
        child: Container(
          height: 200,
          width: double.maxFinite,
          decoration :  BoxDecoration(
          gradient: LinearGradient(colors: [Color.fromARGB(255, 57, 212, 192),Color.fromARGB(255, 0, 156, 177)]),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
        ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: -400,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [ BoxShadow(
                  color : Color.fromARGB(255, 39, 105, 136).withOpacity(0.3),
                  offset: new Offset(-10.0, 0.0),
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                ),]

                  ),
                  height: 450,
                  width: 300,
                  child:
                   Container(
                    padding: EdgeInsets.all(20),
                     child: Column(
                      children: [
                      SizedBox(
                        height: 120,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                           Positioned(
                            top: -80,
                            child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 80,
                           child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("../../../../../assets/images/ProfileImage.png"),),
                     ),
                ),],
                        ),
                      ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("First Name"),
                          Text("Aida"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Family Name "),
                          Text("Riache"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Email "),
                          Text("Aida_Riache@gmail.com"),
                        ],),
                        SizedBox(height: Dimensions.height25,),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Phone Number "),
                          Text("0541728930"),
                        ],),
                        SizedBox(height: Dimensions.height35,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.green
                          ),
                          onPressed: (){
                            print("FUCK");
                          
                            }, child: Text("Edit",style: TextStyle(color: Colors.white),)),
                  
                  ]),
                   ),
                ),
              ),  
              Positioned(
                top: 20,
                left: 20,
                child:
                 GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                   child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100]
                    ),
                    child: Icon(Icons.arrow_back_ios_new,size: 16,),
                   ),
                 )),
              Positioned(
                top: 30,
                child: 
                Text("Profile"))
            ],
          ),
        ),
      ) 
      */