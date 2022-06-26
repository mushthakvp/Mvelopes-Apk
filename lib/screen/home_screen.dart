import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvelopes/colors/colors.dart';
import 'package:mvelopes/dbFunctions/transaction_data_functions.dart';
import 'package:mvelopes/localFunction/local_function.dart';
import 'package:mvelopes/pieChart/piechart_screen.dart';
import 'package:mvelopes/screen/add_screen.dart';
import 'package:mvelopes/screen/viewmore_screen.dart';
import 'package:mvelopes/widgets/listview.dart';
import 'package:mvelopes/widgets/local_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Lw().snBars();
    super.initState();
  }

  DateTime pressedtime = DateTime.now();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    TransactionData.instance.refreshUi();
    return WillPopScope(
      onWillPop: () async {
        final deffent = DateTime.now().difference(pressedtime);
        final isExieit = deffent >= const Duration(seconds: 2);
        pressedtime = DateTime.now();

        if (isExieit) {
          LocalWidget().backexitSnackbar(context, "Press again to exit");
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: indigColor,
          elevation: 10,
          onPressed: () {
            Lf().nextPage(context: context, screen: const AddScreen());
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Column(
            children: [
              appBar(),
              _bookxCard(),
              const SizedBox(height: 10),
              _customTapBar(),
              _rvButtons(),
              Expanded(
                child: HomeListView(
                  valueListner: Lf().returnList(index),
                  checkLength: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding _rvButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent',
            style: TextStyle(
              fontSize: 16,
              color: pinkColor,
              fontFamily: 'JosefinSans',
            ),
          ),
          GestureDetector(
            onTap: (() {
              Lf().nextPage(context: context, screen: const ViewMore());
            }),
            child: const Text(
              'ViewMore',
              style: TextStyle(
                fontSize: 16,
                color: indigColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontFamily: 'JosefinSans',
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _customTapBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tapBarItem(name: 'Home', icon: CupertinoIcons.home, idx: 0, ter: 5),
          _tapBarItem(
              name: 'Income',
              icon: FontAwesomeIcons.sackDollar,
              idx: 1,
              ter: 0),
          _tapBarItem(
              name: 'Expense', icon: FontAwesomeIcons.wallet, idx: 2, ter: 0),
          _tapBarItem(
              name: 'Borrow', icon: FontAwesomeIcons.handshake, idx: 3, ter: 0),
          _tapBarItem(
              name: 'Lend', icon: FontAwesomeIcons.coins, idx: 4, ter: 0)
        ],
      ),
    );
  }

  Container _bookxCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [indigColor, indigoLightColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedTextKit(
                isRepeatingAnimation: true,
                animatedTexts: [
                  ColorizeAnimatedText(
                    'User name',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                  ColorizeAnimatedText(
                    'Mvelopes',
                    textStyle: colorizeTextStyle,
                    colors: colorizeColors,
                  ),
                ],
              ),
              _cardContent('BALANCE', CrossAxisAlignment.start,
                  TransactionData.instance.balanceNotifier),
              _cardContent('INCOME', CrossAxisAlignment.start,
                  TransactionData.instance.incomeNotifier),
              _cardContent('EXPENSE', CrossAxisAlignment.start,
                  TransactionData.instance.expenseNotifier),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Lf().nextPage(context: context, screen: const ChartScreen());
                },
                child: ClipRRect(
                  child: Image.asset(
                    'assets/image/presentation.png',
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _cardContent('BORROW', CrossAxisAlignment.end,
                  TransactionData.instance.borrownotifier),
              _cardContent('LEND', CrossAxisAlignment.end,
                  TransactionData.instance.lendNotifier),
            ],
          )
        ],
      ),
    );
  }

  Column _cardContent(headingAtm, alinment, trAmount) {
    return Column(
      crossAxisAlignment: alinment,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          headingAtm,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontFamily: 'redhat',
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: trAmount,
          builder: (context, value, Widget? _) {
            return Text(
              '₹ $value',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'redhat'),
            );
          },
        ),
      ],
    );
  }

  Padding appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'WelcomeBack',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: blackColor),
              ),
              Text(
                'Mushthak!',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: blackColor,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector _tapBarItem({name, icon, idx, ter}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          index = idx;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [indigColor, indigoLightColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          color: index == idx ? indigColor : transparentColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: index == idx
              ? const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 15,
                )
              : const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
          child: Row(
            children: [
              ter == 5
                  ? Icon(icon, color: index == idx ? whiteColor : pinkColor)
                  : FaIcon(icon, color: index == idx ? whiteColor : pinkColor),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                ),
                child: Text(
                  index == idx ? name : '',
                  style: TextStyle(
                      color: index == idx ? whiteColor : pinkColor,
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
