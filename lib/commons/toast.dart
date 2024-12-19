import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColor.blueColor,
        textColor: MyColor.whiteColor,
        fontSize: 16);
  }

  static showDangerToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColor.redColor,
        textColor: MyColor.whiteColor,
        fontSize: 16);
  }
}
