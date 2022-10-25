

class ForumQuestion {
 int userId=0;
 int id=0;
 String title='';
 
  ForumQuestion({required this.userId, required this.id, required this.title});
 
   ForumQuestion.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
}



}