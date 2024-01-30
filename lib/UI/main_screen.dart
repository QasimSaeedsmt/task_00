import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_0/UI/signup_screen.dart';
import 'package:task_0/logic/shared_preferences_controllers.dart';

import '../logic/email_validator.dart';
import '../resources/common_keys.dart';
import '../resources/dimensions_resource.dart';
import '../resources/string_resource.dart';

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
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(MAIN_SCREEN_TITLE),
        actions: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text(LOGOUT_CONFIRMATION),
                      title: const Text(LOG_OUT),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(CANCEL_TEXT)),
                        ElevatedButton(
                            onPressed: () {
                              logOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: const Text(LOG_OUT))
                      ],
                    );
                  },
                );
              },
              child: const Text(LOG_OUT)),
          const SizedBox(
            width: DimensResource.D_10,
          ),
          editable
              ? const SizedBox(
                  width: DimensResource.D_45,
                )
              : ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    setState(() {
                      editable = true;
                      if (emailController.text.isEmpty) {
                        emailController.text =
                            prefs.getString(EMAIL).toString();
                      }
                      if (nameController.text.isEmpty) {
                        nameController.text = prefs.getString(NAME).toString();
                      }
                      if (passController.text.isEmpty) {
                        passController.text =
                            prefs.getString(PASSWORD).toString();
                      }
                    });
                  },
                  child: const Text(EDIT_PROFILE_TXT)),
          const SizedBox(width: DimensResource.D_15)
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
                          horizontal: DimensResource.D_12,
                          vertical: DimensResource.D_12),
                      child: Center(
                        child: TextFormField(
                          enabled: editable ? true : false,
                          validator: (value) {
                            if ((value ?? EMPTY_STRING).isEmpty) {
                              return EMPTY_EMAIL_MSG;
                            } else if (!isValidEmail(value ?? "")) {
                              return INVALID_EMAIL_MSG;
                            }
                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(
                                      DimensResource.D_12)),
                              hintText: snapshot.data?.getString(EMAIL)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensResource.D_12,
                          vertical: DimensResource.D_12),
                      child: Center(
                        child: TextFormField(
                          enabled: editable ? true : false,
                          validator: (value) {
                            if ((value ?? EMPTY_STRING).isEmpty) {
                              return NAME_ERROR_MSG;
                            }
                            return null;
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius:
                                    BorderRadius.circular(DimensResource.D_12)),
                            hintText: snapshot.data?.getString(NAME),
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensResource.D_12,
                          vertical: DimensResource.D_12),
                      child: Center(
                        child: TextFormField(
                          enabled: editable ? true : false,
                          validator: (value) {
                            if ((value ?? EMPTY_STRING).isEmpty) {
                              return EMPTY_PASSWORD_MSG;
                            } else if ((value?.length ?? 0) <
                                DimensResource.D_6) {
                              return INVALID_PASSWORD_MSG;
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
                                borderRadius:
                                    BorderRadius.circular(DimensResource.D_12)),
                            hintText: snapshot.data?.getString(PASSWORD),
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
            height: DimensResource.D_20,
          ),
          editable
              ? ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      signUp(emailController.text, nameController.text,
                          passController.text);
                      setState(() {
                        editable = false;
                      });
                    }
                  },
                  child: const Text(DONE_TXT))
              : Container()
        ],
      ),
    );
  }
}
