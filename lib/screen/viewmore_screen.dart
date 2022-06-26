import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mvelopes/colors/colors.dart';
import 'package:mvelopes/dbFunctions/transaction_data_functions.dart';
import 'package:mvelopes/widgets/listview.dart';

class ViewMore extends StatefulWidget {
  const ViewMore({Key? key}) : super(key: key);

  @override
  State<ViewMore> createState() => _ViewMoreState();
}

class _ViewMoreState extends State<ViewMore> {
  @override
  void initState() {
    Lw().snBars(snColor: indigColor, stColor: indigColor);
    super.initState();
  }

  @override
  void dispose() {
    Lw().snBars(snColor: transparentColor, stColor: transparentColor);
    super.dispose();
  }

  int indexBottom = 0;
  final pages = [
    HomeListView(
      valueListner: TransactionData().incomListener,
      checkLength: true,
    ),
    HomeListView(
      valueListner: TransactionData().borrowListener,
      checkLength: true,
    ),
    HomeListView(
      valueListner: TransactionData().lendListener,
      checkLength: true,
    ),
    HomeListView(
      valueListner: TransactionData().expenceListener,
      checkLength: true,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          heading(indexBottom),
        ),
        elevation: 0,
        backgroundColor: indigColor,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: indigColor,
        backgroundColor: transparentColor,
        buttonBackgroundColor: indigColor,
        height: 60,
        index: indexBottom,
        items: const [
          Icon(Icons.signpost, size: 25, color: whiteColor),
          Icon(Icons.currency_exchange, size: 25, color: whiteColor),
          Icon(Icons.wallet_giftcard, size: 25, color: whiteColor),
          Icon(Icons.payments_outlined, size: 25, color: whiteColor),
        ],
        onTap: (index) => setState(() {
          indexBottom = index;
        }),
      ),
      body: pages[indexBottom],
    );
  }

  String heading(int value) {
    switch (value) {
      case 1:
        return 'Borrow';
      case 2:
        return 'Lend';
      case 3:
        return 'Expense';
      default:
        return 'Income';
    }
  }
}
