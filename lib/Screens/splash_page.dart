import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_services.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});


  @override

  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  String? name;
  String? email;
  String? uid;
  String? token;


  getData() async{
    SharedPreferences _pref=await SharedPreferences.getInstance();

   token=await _pref.getString('token');
   name=await _pref.getString('name');
   email=await _pref.getString('email');
   uid=await _pref.getString('uid');

   setState(() {

   });
  }

  @override
  void initState() {

    getData();

   var d=Duration(seconds: 1);
   Future.delayed(d,(){
     checkLoginStatus();
   });

    super.initState();
  }

  Future<void> checkLoginStatus() async{
    if(token==null){
     Navigator.pushNamed(context, "/") ;

    }
    else{
      Navigator.pushNamed(context, "/home") ;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Center(child:Text("TODO APP",style: TextStyle(color: Colors.white,),)),
    );
  }
}
