import 'package:flutter/material.dart';
import 'package:task_0/UI/main_screen.dart';
import 'package:task_0/logic/shared_preferences_controllers.dart';

import '../logic/email_validator.dart';
import '../resources/common_keys.dart';
import '../resources/dimensions_resource.dart';
import '../resources/string_resource.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool passwordIsVisible = false;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    togglePasswordView() {
      setState(() {
        passwordIsVisible = !passwordIsVisible;
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(SIGNUP_SCREEN_TITLE),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensResource.D_12,
                        vertical: DimensResource.D_12),
                    child: Center(
                      child: TextFormField(
                        validator: (value) {
                          if ((value ?? EMPTY_STRING).isEmpty) {
                            return EMPTY_EMAIL_MSG;
                          } else if (isValidEmail(value ?? "")) {
                            return INVALID_EMAIL_MSG;
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius:
                                    BorderRadius.circular(DimensResource.D_12)),
                            labelText: EMAIL_LABEL),
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
                            labelText: NAME_LABEL),
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
                            labelText: PASSWORD),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: DimensResource.D_20,
          ),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  signUp(emailController.text, nameController.text,
                      passController.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                }
              },
              child: const Text(SIGNUP_TXT))
        ],
      ),
    );
  }
}
