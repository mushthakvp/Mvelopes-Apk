import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mvelopes/colors/colors.dart';
import 'package:mvelopes/dataModel/transaction_model.dart';
import 'package:mvelopes/dbFunctions/transaction_data_functions.dart';

class Lf {
  DateTime timeDate = DateTime.now();

  String datesplit(DateTime data) {
    final date = DateFormat.MMMd().format(data);
    final dateSplit = date.split(' ');
    return '${dateSplit.last}\n${dateSplit.first}';
  }

  Color colorChecking(CategoryType data) {
    if (data == CategoryType.income) {
      return greenColor;
    } else if (data == CategoryType.expense) {
      return pinkColor;
    } else if (data == CategoryType.borrow) {
      return pinkColor;
    } else if (data == CategoryType.lend) {
      return greenColor;
    } else {
      return greenColor;
    }
  }

  String checkCategory(CategoryType value) {
    if (value == CategoryType.expense) {
      return 'Expense';
    } else if (value == CategoryType.income) {
      return 'Income';
    } else if (value == CategoryType.borrow) {
      return 'Borrow';
    } else {
      return 'Lend';
    }
  }

  FaIcon listIcon(value) {
    if (value == CategoryType.expense) {
      return FaIcon(FontAwesomeIcons.wallet, color: colorChecking(value));
    } else if (value == CategoryType.income) {
      return FaIcon(FontAwesomeIcons.sackDollar, color: colorChecking(value));
    } else if (value == CategoryType.borrow) {
      return FaIcon(FontAwesomeIcons.handshake, color: colorChecking(value));
    } else {
      return FaIcon(FontAwesomeIcons.coins, color: colorChecking(value));
    }
  }

  ValueNotifier<List<TransationModel>> returnList(int index) {
    switch (index) {
      case 0:
        return TransactionData().recentListener;
      case 1:
        return TransactionData().incomListener;

      case 2:
        return TransactionData().expenceListener;

      case 3:
        return TransactionData().borrowListener;

      default:
        return TransactionData().lendListener;
    }
  }

  nextPage({context, screen}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
                parent: animation, curve: Curves.fastLinearToSlowEaseIn);
            return ScaleTransition(
                alignment: Alignment.center, scale: animation, child: child);
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return screen;
          },
        ));
  }
}
