import 'package:flutter/material.dart';
import 'package:fatwa/Dimensions.dart';

class CustomSearchDelegate extends SearchDelegate {
  List <String> searchTerms = [
    "Apple",
    "Banana",
    "Pear",
    "Watermelons",
    "Oranges"
    ,"BlueBerries"
    ,"StrawBerries"
    ,"Raspberries"];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () {query='';}, icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
      return IconButton(onPressed: (){close(context, null);}, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) { 
      List <String> Matchquery =[];
      for (var fruit in searchTerms){
        if (fruit.toLowerCase().contains(query.toLowerCase())){
          Matchquery.add(fruit);
        }
      }
      return ListView.builder(
        itemCount: Matchquery.length,
        itemBuilder: (context,index){
          var result = Matchquery[index];
          return ListTile(
            title: Text(result),
          );
        },
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
          List <String> Matchquery =[];
      for (var fruit in searchTerms){
        if (fruit.toLowerCase().contains(query.toLowerCase())){
          Matchquery.add(fruit);
        }
      }
            return ListView.builder(
        itemCount: Matchquery.length,
        itemBuilder: (context,index){
          var result = Matchquery[index];
          return ListTile(
            title: Text(result),
          );
        },
      );


  }
  
}
