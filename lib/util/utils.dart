import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showMessage(String message, [bool isError = true]) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: isError ? Colors.red : Colors.green,
        webShowClose: true,
        timeInSecForIosWeb: 3,
        webBgColor: isError ? '#ff0000' : '#00ff00');
  }
}