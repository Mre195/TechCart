import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'signup.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => loginn();
}

class loginn extends State<login> {
  final _formKey = GlobalKey<FormState>();
  bool show = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    Color scaffoldBg = isDark ? Colors.black : Colors.green;
    Color cardBg = isDark ? Color(0xFF1A1A1A) : Color(
        0xFF1E1E1E);

    return Scaffold(
      backgroundColor: scaffoldBg,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Container(
            width: 360,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(image: AssetImage("assets/logo.png"), height: 150),
                  SizedBox(height: 8),
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.email, color: Colors.green),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (email) {
                      if (email == null || email.isEmpty ||
                          !email.contains('@')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !show,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.lock, color: Colors.green),
                      suffixIcon: IconButton(
                        icon: Icon(
                          show ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            show = !show;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Color(0xFF2A2A2A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (password) {
                      if (password == null || password.isEmpty ||
                          password.length < 8) {
                        return 'Invalid password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        loggin(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Continue as Guest",
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          _signup(context);
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loggin(BuildContext context) async {
    String userEmail = _emailController.text;
    String userPassword = _passwordController.text;

    bool? isvalid = _formKey.currentState?.validate();

    if (isvalid == true)
    {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: userEmail, password: userPassword);

        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("please enter valid email and password"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _signup(BuildContext context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()),);
  }

}
