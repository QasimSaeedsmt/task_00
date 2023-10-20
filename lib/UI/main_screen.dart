import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_0/UI/signup_screen.dart';
import 'package:task_0/logic/shared_preferences_controllers.dart';

import '../logic/email_validator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordIsVisible = false;
  TextEditingController passController = TextEditingController();
  bool editable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Main Screen"),
        actions: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text("Do you want to log out?"),
                      title: const Text("Log out"),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        ElevatedButton(
                            onPressed: () {
                              logOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: const Text("Log out"))
                      ],
                    );
                  },
                );
              },
              child: const Text("Log out")),
          const SizedBox(
            width: 10,
          ),
          editable
              ? const SizedBox(
                  width: 45,
                )
              : ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      editable = true;
                      if (emailController.text.isEmpty) {
                        emailController.text =
                            prefs.getString("email").toString();
                      }
                      if (nameController.text.isEmpty) {
                        nameController.text =
                            prefs.getString("name").toString();
                      }
                      if (passController.text.isEmpty) {
                        passController.text =
                            prefs.getString("Password").toString();
                      }
                    });
                  },
                  child: const Text("Edit Profile")),
          const SizedBox(width: 15)
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
              void togglePasswordView() {
                setState(() {
                  passwordIsVisible = !passwordIsVisible;
                });
              }

              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Center(
                        child: TextFormField(
                          enabled: editable ? true : false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email';
                            } else if (!isValidEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: snapshot.data!.getString("email")),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Center(
                        child: TextFormField(
                          enabled: editable ? true : false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter your Full Name";
                            }
                            return null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: snapshot.data!.getString("name"),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Center(
                        child: TextFormField(
                          enabled: editable ? true : false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter a Password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          obscureText: passwordIsVisible ? false : true,
                          controller: passController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: togglePasswordView,
                                icon: passwordIsVisible
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off)),
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(12)),
                            hintText: snapshot.data!.getString("Password"),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          editable
              ? ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUp(emailController.text, nameController.text,
                          passController.text);
                      setState(() {
                        editable = false;
                      });
                    }
                    // setState(() {
                    //   editable = false;
                    // });
                  },
                  child: const Text("Done"))
              : Container()
        ],
      ),
    );
  }
}
