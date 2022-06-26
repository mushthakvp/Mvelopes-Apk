import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mvelopes/colors/colors.dart';
import 'package:mvelopes/dataModel/transaction_model.dart';
import 'package:mvelopes/dbFunctions/transaction_data_functions.dart';
import 'package:mvelopes/screen/home_screen.dart';
import 'package:mvelopes/widgets/textfield_widget.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _notesController = TextEditingController();
  final _amountController = TextEditingController();
  dynamic _dateNow = DateTime.now();
  final _dropList = ['Income', 'Expense', 'Borrow', 'Lend'];
  String? _dropName;
  late CategoryType _globalType;

  @override
  void initState() {
    Lw().snBars(snColor: whiteColor, stColor: transparentColor);
    super.initState();
  }

  @override
  void dispose() {
    Lw().snBars(snColor: transparentColor, stColor: transparentColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusScope.of(context).unfocus();
      }),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: indigColor,
          centerTitle: true,
          title: const Text(
            'Add Items',
          ),
        ),
        backgroundColor: whiteColor,
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(
              height: 30,
            ),
            SvgPicture.asset(
              'assets/image/addInfo.svg',
              height: 170,
            ),
            const SizedBox(
              height: 30,
            ),
            textFieldsCustoms(),
          ],
        ),
      ),
    );
  }

  Column textFieldsCustoms() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            datePicker();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: greyLight,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: indigColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: const Icon(
                    Icons.date_range_outlined,
                    color: whiteColor,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    DateFormat('yMMMMd').format(_dateNow),
                    style: const TextStyle(
                        color: blackColor, fontSize: 18, fontFamily: 'redhat'),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),
        TextFieldsWidget(
            icon: Icons.notes,
            hint: 'Notes',
            controllerText: _notesController,
            type: TextInputType.name),
        TextFieldsWidget(
            icon: Icons.wallet_giftcard,
            hint: 'Amount',
            controllerText: _amountController,
            type: TextInputType.number),
        dropDownMenu(),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * .84,
          child: ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              submitDetails(context);
            },
            style: ElevatedButton.styleFrom(
              primary: indigColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'SUBMIT',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'redhat',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container dropDownMenu() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: greyLight,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: indigColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: whiteColor,
            ),
          ),
          const SizedBox(width: 15),
          DropdownButtonHideUnderline(
            child: SizedBox(
              width: 230,
              child: DropdownButton(
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'redhat',
                  color: blackColor,
                ),
                borderRadius: BorderRadius.circular(10),
                dropdownColor: whiteColor,
                icon: const Visibility(
                  visible: false,
                  child: Icon(Icons.arrow_downward),
                ),
                hint: const Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'redhat',
                    color: blackColor,
                  ),
                ),
                value: _dropName,
                items: _dropList.map((newList) {
                  return DropdownMenuItem(
                    value: newList,
                    child: Text(newList),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _dropName = value;
                    categoryTypeChecking(value!);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  datePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _dateNow,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    setState(() {
      newDate == null ? _dateNow : _dateNow = newDate;
    });
  }

  categoryTypeChecking(String data) {
    if (data == 'Income') {
      _globalType = CategoryType.income;
    } else if (data == 'Expense') {
      _globalType = CategoryType.expense;
    } else if (data == 'Borrow') {
      _globalType = CategoryType.borrow;
    } else if (data == 'Lend') {
      _globalType = CategoryType.lend;
    }
  }

  submitDetails(BuildContext context) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    final note = _notesController.text.trim();
    final price = _amountController.text.trim();
    if (note.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          padding: EdgeInsets.all(14),
          elevation: 6,
          backgroundColor: indigColor,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Please Fill Fields',
            style: TextStyle(fontSize: 14),
          ),
        ),
      );
    } else {
      final amount = double.tryParse(price);
      final allData = TransationModel(
          notes: note,
          amount: amount!,
          dateTime: _dateNow,
          type: _globalType,
          id: id);

      TransactionData.instance.addTransaction(allData);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: ((context) => const HomeScreen())));
      TransactionData().refreshUi();
    }
  }
}
