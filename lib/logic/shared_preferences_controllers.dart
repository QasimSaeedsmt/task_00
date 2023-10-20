import 'package:shared_preferences/shared_preferences.dart';

signUp(String emailController, String nameController,
    String passController) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("email", emailController);
  prefs.setString("name", nameController);
  prefs.setString("Password", passController);
  prefs.setBool("isLogin", true);
}

logOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("name");
  prefs.remove("email");
  prefs.remove("Password");
  prefs.remove("isLogin");
}
