import 'package:flutter/material.dart';

import '../../constants/utils/text_utility.dart';
import '../../style/colors.dart';

void customConfirmationAlertDialog(
  BuildContext context,
  void Function() onConfirmPress,
  String title,
  String content,
  String cofirmText,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: AppText(
          text: title,
          fontsize: 20,
          fontWeight: FontWeight.w500,
          textColor: AppColors.primaryBg,
        ),
        content: AppText(
          text: content,
          fontWeight: FontWeight.w500,
          fontsize: 16,
          textColor: Colors.black,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const AppText(
              text: 'Cancel',
              fontWeight: FontWeight.w500,
              fontsize: 16,
              textColor: AppColors.buttonColor,
            ),
          ),
          TextButton(
            onPressed: onConfirmPress,
            child: AppText(
              text: cofirmText,
              fontWeight: FontWeight.w500,
              fontsize: 16,
              textColor: AppColors.buttonColor,
            ),
          ),
        ],
      );
    },
  );
}
