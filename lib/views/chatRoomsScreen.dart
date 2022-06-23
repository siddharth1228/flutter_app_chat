import 'package:flutter/material.dart';
import 'package:flutterappchat/helper/authenticate.dart';
import 'package:flutterappchat/helper/constants.dart';
import 'package:flutterappchat/helper/helperfunctions.dart';
import 'package:flutterappchat/services/auth.dart';
import 'package:flutterappchat/services/database.dart';
import 'package:flutterappchat/views/conversation_screen.dart';
import 'package:flutterappchat/views/search.dart';
import 'package:flutterappchat/views/signin.dart';
import 'package:flutterappchat/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthService authMethods = new AuthService();
  DatabaseMethods databaseMethods=new DatabaseMethods();

  Stream chatRoomssStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomssStream,
      builder: (context,snapshot){
        return snapshot.hasData ?  ListView.builder(itemCount: snapshot.data.documents.length,
        itemBuilder: (context,index){
            return ChatRoomTile(
              snapshot.data.documents[index].data["chatroomId"]
                  .toString().replaceAll("_", "")
                  .replaceAll(Constants.myName, ""),
                snapshot.data.documents[index].data["chatroomId"]
            );
        }) : Container();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  getUserInfo() async{
    Constants.myName=await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      getUserInfo();
      databaseMethods.getUserChats(Constants.myName).then((value){
        setState(() {
          chatRoomssStream=value;
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",
          height: 50,),
        actions:[
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=> Authenticate(),
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(
            builder: (context)=> Search()
          ));
        },
      ),
    );
  }
}
class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding:  EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),),

          ],
        ),
      ),
    );
  }
}

