import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fatwa/Dimensions.dart';
import 'package:fatwa/Screens/Profile/Componenets/Profile_pages/MyAccount/mybutton_widget.dart';

import 'Home_Fatwa/Home_Fatwa.dart';

const kPrimaryColor = Color.fromARGB(255, 61, 166, 252);

class AddContent extends StatefulWidget {
  const AddContent({Key? key}) : super(key: key);

  
  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
String dropdownvalue = 'Khoutba';
String dropdowncategorievalue = "Work";

  var items = [   
    'Khoutba',
    'Dourous',
    'Hadith',
  ];
  var categorieitems=[
    'Work',
    'Familly',
    'Charity',
  ];

  Future pickImage() async {
      await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    bool test=true;
      return  Scaffold(
        
      body: SingleChildScrollView(
        child: test? Column(
          children: [
            PageTitle(pagetitle: 'Add Content',),
            const ListTile(
              leading: Text("Add Post",style: TextStyle(fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                  decoration : InputDecoration(
                    labelText: 'Subject',
                    hintText: 'Your Subject ..',
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                      focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green,width: 1),
                      borderRadius: BorderRadius.circular(10)
                    ),
                  )
              ),
            ),
            SizedBox(height: Dimensions.height25,),
            Padding(
              padding:  EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  isExpanded: true,
                  value : dropdownvalue,
                  dropdownColor: Colors.grey[200],
                  elevation: 1,
                  icon: const Icon(Icons.keyboard_arrow_down), 
                  items: items.map((String items){
                    return DropdownMenuItem(value : items ,child: Text(items));
                  }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });}
                   
                   ),
              ),
            ),
               SizedBox(height: Dimensions.height25,),
               Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                    Text("About",style: TextStyle(fontSize: 18,color: Colors.black),),
                    SizedBox(height: Dimensions.height10,),
                     TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Description ..',
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,width: 1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green,width: 1),
                          borderRadius: BorderRadius.circular(10)
                      ),
                     )),
                     SizedBox(height:Dimensions.height25),
                     buildButton(
                      title : 'Pick From Gallery',
                      icon : Icons.image_outlined,
                      onClicked : (){ pickImage(); }
                     ),
                     SizedBox(height:Dimensions.height25),
                    //  Center(child: ButtonWidget(text: 'Submit', onClicked: (){})),
                     Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.green,Colors.cyan]),
                        borderRadius: BorderRadius.circular(25)
                      ),
                       child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent,
                        ),
                        onPressed: (){},
                         child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20),)),
                     )
                   ],
                 ),
               ),
          ],
        )
        :
        Container(
          
          child: AddaQuestion())
        ,
       
      )
      );
      
  }

  Column AddaQuestion() {
    return Column(
        children: [
          PageTitle(pagetitle: 'Add Question',),
          const ListTile(
            leading: Text("Add a question",style: TextStyle(fontSize: 18,color: Colors.cyan),),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
                decoration : InputDecoration(
                  labelText: 'Title',
                  hintText: 'Question title ..',
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,width: 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                    focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green,width: 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                )
            ),
          ),
          SizedBox(height: Dimensions.height25,),
          const ListTile(
            leading: Text("Question type",style: TextStyle(fontSize: 18,color: Colors.cyan),),
          ),
          Padding(
            padding:  EdgeInsets.only(left: 20.0,right: 20.0),
            child: ButtonTheme(
              textTheme: ButtonTextTheme.primary,
              alignedDropdown: true,
              child: DropdownButton(
                
                isExpanded: true,
                value : dropdownvalue,
                dropdownColor: Colors.grey[200],
                elevation: 1,
                icon: const Icon(Icons.keyboard_arrow_down), 
                items: items.map((String items){
                  return DropdownMenuItem(value : items ,child: Text(items));
                }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });}
                 
                 ),
            ),
          ),
           SizedBox(height: Dimensions.height25,),
           const ListTile(
            leading: Text("Question categorie",style: TextStyle(fontSize: 18,color: Colors.cyan),),
          ),
           Padding(
            padding:  EdgeInsets.only(left: 20.0,right: 20.0),
            child: ButtonTheme(
              textTheme: ButtonTextTheme.primary,
              alignedDropdown: true,
              child: DropdownButton(
                
                isExpanded: true,
                value : dropdowncategorievalue,
                dropdownColor: Colors.grey[200],
                elevation: 1,
                icon: const Icon(Icons.keyboard_arrow_down), 
                items: categorieitems.map((String items){
                  return DropdownMenuItem(value : items ,child: Text(items));
                }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdowncategorievalue = newValue!;
                    });}
                 
                 ),
            ),
          ),
             SizedBox(height: Dimensions.height25,),
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  Text("Question",style: TextStyle(color: Colors.cyan,fontSize: 18),),
                  SizedBox(height: Dimensions.height10,),
                   TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Your Question ..',
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,width: 1),
                        borderRadius: BorderRadius.circular(10)
                      ),
                        focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green,width: 1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                   )),


                   SizedBox(height:Dimensions.height25),
                  //  Center(child: ButtonWidget(text: 'Submit', onClicked: (){})),
                   Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[300],
                      borderRadius: BorderRadius.circular(25)
                    ),
                     child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent,
                      ),
                      onPressed: (){},
                       child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 20),)),
                   )
                 ],
               ),
             ),
        ],
      );
  }
}

Widget buildButton({required String title,required IconData icon,required VoidCallback onClicked})
=> ElevatedButton(
  style: ElevatedButton.styleFrom(
    elevation: 2,
    minimumSize: Size.fromHeight(56),
    primary: Colors.orange[300],
    onPrimary: Colors.white,
    textStyle: TextStyle(fontSize: 20),
  ),
  onPressed: onClicked,
   child: Row(
    children: [
      Icon(icon,size: 28,),
      SizedBox(width: 16,),
      Text(title),

    ],
   )
   );