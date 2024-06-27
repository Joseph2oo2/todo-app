import 'dart:ffi';

import 'package:firebase/models/user_model.dart';
import 'package:firebase/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  UserModel _userModel = UserModel();
  AuthServices _authServices = AuthServices();

  bool isLoading = false;
  void _loginUser() async {
    setState(() {
      isLoading = true;
    });



    try {
      _userModel = UserModel(
          email: _emailController.text,
          password: _passwordController.text);
      await Future.delayed(Duration(seconds: 3));
      final data = await _authServices.loginUser(_userModel);
      if (data != null) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      List err = e.toString().split("]");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err[1])));
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
                    "Login to your Account",
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
              InkWell(
                onTap: ()async{
                  if(_formKey.currentState!.validate()){
                    _loginUser();
                  }

                },
                child:Container(
                    height: 48,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child:Text(
                      "Login",
                      style: themeData.textTheme.displayMedium,
                    )),
                  ),),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account?",
                        style: themeData.textTheme.displaySmall,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            "Create Account",
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
