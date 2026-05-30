import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color scaffoldBg = isDark ? Colors.black : Colors.green;
    Color cardBg = isDark ? Color(0xFF1A1A1A) : Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Center(
        child: Container(
          width: 360,
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: AssetImage("assets/logo.png" ),height: 150,),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),

                  TextFormField(
                    controller: _emailController,
                    style:TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle:TextStyle(color: Colors.grey),
                      prefixIcon:Icon(Icons.email, color: Colors.green),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (email) {
                      if (email == null || email.isEmpty || !email.contains('@'))
                      {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style:TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle:TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (password) {
                      if (password == null || password.isEmpty || password.length < 8) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _cpasswordController,
                    obscureText: true,
                    style:TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (password) {
                      if (password == null || password.isEmpty)
                      {
                        return 'reEnter New Password';
                      }
                      else if (password.length < 8)
                      {
                        return 'Password length atleast 8';
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _firstNameController,
                    style:TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "First Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.person, color: Colors.green),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Last Name
                  TextFormField(
                    controller: _lastNameController,
                    style:TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      hintStyle:TextStyle(color: Colors.grey),
                      prefixIcon:Icon(Icons.person, color: Colors.green),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _signup(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => login()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Back to Login",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signup(BuildContext context) async {
    String userEmail = _emailController.text;
    String userPassword = _passwordController.text;
    String cPassword = _cpasswordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    bool? isvalid = _formKey.currentState?.validate();

    if (isvalid == true) {
      if (userPassword == cPassword) {
        try {
          final cred = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: userEmail, password: userPassword);
          String fullName = "$firstName $lastName";
          await cred.user!.updateDisplayName(fullName);
          await cred.user!.reload();

          String ui = cred.user!.uid;

          await FirebaseFirestore.instance.collection('data').doc(ui).set({
            'first_name': firstName,
            'last_name': lastName,
            'email': userEmail,
          });

          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("wrong data"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("password does not match"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a correct email and password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
