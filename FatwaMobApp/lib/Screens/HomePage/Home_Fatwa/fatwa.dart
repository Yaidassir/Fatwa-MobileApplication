class fatwa {
 int userId=0;
 int id=0;
 String title='';
 
  fatwa({required this.userId, required this.id, required this.title});
 
   fatwa.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
}
}


/*

  CurvedNavigationBar Bottombar(BuildContext context) {
    return CurvedNavigationBar(
      color: Colors.blue,
      backgroundColor: Colors.white,
      items: [
        Icon(Icons.home),
        Icon(Icons.forum),
        Icon(Icons.add),
        Icon(Icons.notifications),
        Icon(Icons.person),
      ],
      index: index,
      height: 50,
      onTap: (index){setState(() {
        this.index=index;
      });},

    );
  }

  */