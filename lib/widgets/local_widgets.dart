import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvelopes/colors/colors.dart';

class LocalWidget {
  backexitSnackbar(BuildContext context, String text) {
    Fluttertoast.showToast(
        backgroundColor: pinkColor,
        msg: text, // message
        toastLength: Toast.LENGTH_SHORT, // length
        gravity: ToastGravity.BOTTOM, // location
        timeInSecForIosWeb: 1);
  }
}
