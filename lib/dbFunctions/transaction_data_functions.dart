// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, duplicate_ignore
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mvelopes/dataModel/transaction_model.dart';

const tbName = 'transaction';

abstract class TransactionModelFunction {
  Future<void> addTransaction(TransationModel obj);
  Future<List<TransationModel>> getTransaction();
  Future<void> deleteTransaction(String deleteKey);
  Future<void> updateTransaction(TransationModel obj, String id);
}

class TransactionData implements TransactionModelFunction {
  TransactionData.transactionData();

  static TransactionData instance = TransactionData.transactionData();

  factory TransactionData() {
    return instance;
  }
  ValueNotifier<List<TransationModel>> recentListener = ValueNotifier([]);
  ValueNotifier<List<TransationModel>> incomListener = ValueNotifier([]);
  ValueNotifier<List<TransationModel>> expenceListener = ValueNotifier([]);
  ValueNotifier<List<TransationModel>> borrowListener = ValueNotifier([]);
  ValueNotifier<List<TransationModel>> lendListener = ValueNotifier([]);
  ValueNotifier<List<TransationModel>> toadyListner = ValueNotifier([]);
  ValueNotifier<List<TransationModel>> yesterdayListner = ValueNotifier([]);

  @override
  addTransaction(TransationModel obj) async {
    final data = await Hive.openBox<TransationModel>(tbName);
    data.put(obj.id, obj);
  }

  @override
  Future<List<TransationModel>> getTransaction() async {
    final data = await Hive.openBox<TransationModel>(tbName);
    return data.values.toList();
  }

  @override
  Future<void> deleteTransaction(String deleteKey) async {
    final data = await Hive.openBox<TransationModel>(tbName);
    await data.delete(deleteKey);
  }

  ValueNotifier<double> balanceNotifier = ValueNotifier(0);
  ValueNotifier<double> incomeNotifier = ValueNotifier(0);
  ValueNotifier<double> expenseNotifier = ValueNotifier(0);
  ValueNotifier<double> borrownotifier = ValueNotifier(0);
  ValueNotifier<double> lendNotifier = ValueNotifier(0);

  ValueNotifier<List<TransationModel>> sortListner = ValueNotifier([]);

  // ignore: duplicate_ignore
  refreshUi() async {
    final allCategories = await getTransaction();
    recentListener.value.clear();
    incomListener.value.clear();
    expenceListener.value.clear();
    borrowListener.value.clear();
    lendListener.value.clear();
    recentListener.value.addAll(allCategories);
    balanceNotifier.value = 0;
    incomeNotifier.value = 0;
    expenseNotifier.value = 0;
    borrownotifier.value = 0;
    lendNotifier.value = 0;

    await Future.forEach(allCategories, (TransationModel category) {
      balanceNotifier.value = balanceNotifier.value + category.amount;

      if (category.type == CategoryType.income) {
        incomListener.value.add(category);
        incomeNotifier.value = incomeNotifier.value + category.amount;
      } else if (category.type == CategoryType.expense) {
        expenseNotifier.value = expenseNotifier.value + category.amount;
        expenceListener.value.add(category);
      } else if (category.type == CategoryType.borrow) {
        borrownotifier.value = borrownotifier.value + category.amount;
        borrowListener.value.add(category);
      } else if (category.type == CategoryType.lend) {
        lendNotifier.value = lendNotifier.value + category.amount;
        lendListener.value.add(category);
      }
    });

    balanceNotifier.value = (incomeNotifier.value + lendNotifier.value) -
        (borrownotifier.value + expenseNotifier.value);

    balanceNotifier.notifyListeners();
    incomeNotifier.notifyListeners();
    expenseNotifier.notifyListeners();
    borrownotifier.notifyListeners();
    lendNotifier.notifyListeners();

    incomListener.notifyListeners();
    expenceListener.notifyListeners();
    borrowListener.notifyListeners();
    lendListener.notifyListeners();
  }

  @override
  Future<void> updateTransaction(TransationModel obj, String id) async {
    final data = await Hive.openBox<TransationModel>(tbName);
    data.put(id, obj);
    refreshUi();
  }
}
