import 'package:shared_preferences/shared_preferences.dart';

import '../resourses/common_keys.dart';

signUp(String emailController, String nameController,
    String passController) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(EMAIL, emailController);
  prefs.setString(NAME, nameController);
  prefs.setString(PASSWORD, passController);
  prefs.setBool(IS_LOGIN, true);
}

logOut() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(NAME);
  prefs.remove(EMAIL);
  prefs.remove(PASSWORD);
  prefs.remove(IS_LOGIN);
}
