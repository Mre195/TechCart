import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';
import 'login.dart';
import 'theme_controller.dart';

class Settingsp extends StatefulWidget {
  const Settingsp({super.key});

  @override
  State<Settingsp> createState() => _SettingsState();
}

class _SettingsState extends State<Settingsp> {
  bool show = false;

  final _formKey = GlobalKey<FormState>();
  final curp = TextEditingController();
  final p = TextEditingController();
  final conp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, value, child) {

        Color cardColor = isDarkMode.value ? Colors.grey[850]! : Colors.green;
        Color textColor = Colors.white;

        return Scaffold(
          drawer:AppDrawer(),
          appBar: AppBar(
            title: Text("Settings Page", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  isDarkMode.value = !isDarkMode.value;
                },
                icon: Icon(isDarkMode.value ? Icons.dark_mode : Icons.light_mode),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    height: 430,
                    width: 400,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadiusDirectional.circular(12),
                    ),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Password Update",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 30),

                              TextFormField(
                                controller: curp,
                                obscureText: !show,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: "Current Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon:
                                  Icon(Icons.lock, color: Colors.green),
                                  filled: true,
                                  fillColor:Color(0xFF2A2A2A),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                validator: (password)
                                {
                                  if (password == null || password.isEmpty)
                                  {
                                    return 'Enter Current Password';
                                  }
                                  else if (password.length < 8)
                                  {
                                    return 'Password length atleast 8';
                                  }
                                },
                              ),
                              SizedBox(height: 16),

                              TextFormField(
                                controller: p,
                                obscureText: !show,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: "New Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon:
                                  Icon(Icons.lock, color: Colors.green),
                                  filled: true,
                                  fillColor: Color(0xFF2A2A2A),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                validator: (password)
                                {
                                  if (password == null || password.isEmpty)
                                  {
                                    return 'Enter New Password';
                                  }
                                  else if (password.length < 8)
                                  {
                                    return 'Password length atleast 8';
                                  }
                                },
                              ),
                              SizedBox(height: 16),

                              TextFormField(
                                controller: conp,
                                obscureText: !show,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: "Confirm New Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon:
                                  Icon(Icons.lock, color: Colors.green),
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
                                  ),
                                ),
                                validator: (password)
                                {
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
                              SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: ()
                                  {
                                    if(FirebaseAuth.instance.currentUser != null)
                                    {
                                      updatePass();
                                    }
                                    else
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Please login First"), backgroundColor: Colors.red, duration: Duration(seconds: 3),),);
                                    }
                                  },
                                  child: Text("Update Password", style: TextStyle(fontSize: 16, color: Colors.white),),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    height: 420,
                    width: 400,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadiusDirectional.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Other Settings",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: ()
                            {
                              if(FirebaseAuth.instance.currentUser != null)
                              {
                                deleteAccount(context, "Are you sure you want to delete your account?");
                              }
                              else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Please login First"),
                                    backgroundColor: Colors.red, duration: Duration(seconds: 3),),);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text("Delete Account", style: TextStyle(fontSize: 16, color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void updatePass() async {
    String _p = p.text;
    String _cp = conp.text;

    bool isValid = _formKey.currentState!.validate();

    if (isValid)
    {
      if(_p == _cp)
      {
        try {
          final user = FirebaseAuth.instance.currentUser!;
          final cred = EmailAuthProvider.credential(email: user.email!, password: curp.text);
          await user.reauthenticateWithCredential(cred);
          await user.updatePassword(p.text);

          curp.clear();
          p.clear();
          conp.clear();

          await FirebaseAuth.instance.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (context) => login()),);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Password updated. Please log in again.",style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.white,),);
        }
        catch (e)
        {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ReCheck your Current Password"), backgroundColor: Colors.red, duration: Duration(seconds: 3),),);
        }
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("The Password and the Confirm Password doesn't match"),
            backgroundColor: Colors.red, duration: Duration(seconds: 3),),);
      }
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Valid Data"), backgroundColor: Colors.red, duration: Duration(seconds: 3),),);
    }

  }

  void deleteAccount(BuildContext context, String msg) async {
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (x) => AlertDialog(
        backgroundColor: Colors.green,
        title: Text("Confirmation", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg, style:TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter your password",
                hintStyle:TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions:
        [
          ElevatedButton(
            onPressed: ()
            {
              Navigator.of(x).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser!;
              String password = passwordController.text.trim();

              if (password.isEmpty)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please enter your password"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              try {
                final cred = EmailAuthProvider.credential(email: user.email!, password: password);
                await user.reauthenticateWithCredential(cred);

                final cartOfUser = await FirebaseFirestore.instance.collection("users").doc(user.uid).collection("cart");
                final cartThings = await cartOfUser.get();
                for(var doc in cartThings.docs)
                  {
                    doc.reference.delete();
                  }
                await FirebaseFirestore.instance.collection("users").doc(user.uid).delete();
                await FirebaseFirestore.instance.collection("data").doc(user.uid).delete();

                await user.delete();

                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login()),);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Account Deleted"),
                    backgroundColor: Colors.black,
                    duration: Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text("Failed to delete account. Check your password."),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:Color(0xFF1E2B23),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child:Text("Sure", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
