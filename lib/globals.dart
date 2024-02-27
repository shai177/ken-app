
library globals;
import 'package:shared_preferences/shared_preferences.dart';
String job = " ";
List<String> stringList = [];
addStringToList(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  stringList.add(value);
  await prefs.setStringList('stringList', stringList);
}
