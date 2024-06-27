import 'dart:ffi';

import 'package:firebase/models/user_model.dart';
import 'package:firebase/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  UserModel _userModel = UserModel();
  AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();

  bool isLoading=false;

  void register() async{
    setState(() {
      isLoading=true;
    });
    _userModel = UserModel(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      status: 1,
      createdAt: DateTime.now(),
    );
    try {
      await Future.delayed(Duration(seconds: 3));
      final userdata = await _authServices.registerUser(_userModel);
      if (userdata != null) {
            Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (route) => false);
         }
    }on FirebaseAuthException catch(e){
      setState(() {
        isLoading=false;
      });
      List err=e.toString().split("]");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(err[1]) ));
    }

}
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Register to your Account",
                    style: themeData.textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: themeData.textTheme.displaySmall,
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a email id";
                      }
                    },
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      hintStyle: themeData.textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: themeData.textTheme.displaySmall,
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is Mandatory";
                      }
                    },
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      hintStyle: themeData.textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: themeData.textTheme.displaySmall,
                    controller: _nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your name";
                      }
                    },
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: "Enter name",
                      hintStyle: themeData.textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
    if(_formKey.currentState!.validate()) {
      register();
      // _userModel = UserModel(
      //       email: _emailController.text,
      //       password: _passwordController.text,
      //       name: _nameController.text,
      //       status: 1,
      //       createdAt: DateTime.now(),
      // );
    };
                    },
                    child: Container(
                      height: 48,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Register",
                        style: themeData.textTheme.displayMedium,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account?",
                        style: themeData.textTheme.displaySmall,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
                            style: themeData.textTheme.displayMedium,
                          ))
                    ],
                  )
                ],
              ),
            ),
            Visibility(
                visible: isLoading,
                child: Center(child: CircularProgressIndicator(),))
          ],
        ),
      ),
    );
  }
}
