import 'package:MegaObra/widgets/alerts/simple.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/utils/customization.dart';

class ErrorMsg {
  static const String UNAUTHORIZED = 'UNAUTHORIZED';
  static const String POST = 'FAILED TO POST';
  static const String LOAD = 'FAILED TO LOAD';
  static const String POST_USER = 'FAILED TO POST USER';
  static const String LOAD_USER = 'FAILED TO LOAD USER/USERS';
  static const String GENERIC = 'FAIL';
  static const String DECODE_BODY = 'ERROR DECODING RESPONSE BODY';
  static const String RESPONSE_FORMAT = 'INVALID RESPONSE FORMAT';
  static const String NETWORK = 'NETWORK ERROR';
  static const String GET_TOKEN = 'FAILED TO GET AUTH TOKEN';
  static const String DEPRECATED_GONE = 'DEPRECATED OR GONE';
  static const String INVALID = 'INVALID';

  static void throwError(BuildContext context, Uri url, String msg, String? info, {String? stacktrace = ""}) {
    String displayMessage;

    if (info != null) {
      displayMessage = "${url.toString()} - $msg: $info. $stacktrace";
    } else {
      displayMessage = "${url.toString()} - $msg. $stacktrace";
    }

    print(displayMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          displayMessage,
          style: TextStyle(
            color: megaobraSnackBarText(),
          ),
        ),
        backgroundColor: megaobraSnackBarBackground(),
        duration: const Duration(seconds: 10),
      ),
    );
  }
}

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String text,
  VoidCallback? onConfirm,
  bool? pop,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MegaObraAlertDialog(
        title: title,
        text: text,
        onConfirm: onConfirm,
        pop: pop == null ? false : true,
      );
    },
  );
}

void showQuestionAlertDialog({
  required BuildContext context,
  required String title,
  required String text,
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
  required VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MegaObraQuestionAlertDialog(
        title: title,
        text: text,
        onConfirm: onConfirm,
        onCancel: onCancel,
        cancelText: cancelText,
        confirmText: confirmText,
      );
    },
  );
}
