import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mvelopes/colors/colors.dart';
import 'package:mvelopes/dbFunctions/transaction_data_functions.dart';

createPersistentNotification() async {
  await AwesomeNotifications().resetGlobalBadge();

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'persistent_notification',
      title: '💰 TOTAL: ₹ ${TransactionData.instance.balanceNotifier.value}',
      body:
          '⬆️ INCOME: ₹ ${TransactionData.instance.incomeNotifier.value} ⬇️  EXPENSE: ₹ ${TransactionData.instance.expenseNotifier.value}',
      notificationLayout: NotificationLayout.Default,
      autoDismissible: false,
      locked: true,
      displayOnBackground: true,
    ),
    actionButtons: [
      NotificationActionButton(
          key: 'EDIT',
          label: 'Close',
          color: indigColor,
          autoDismissible: true,
          buttonType: ActionButtonType.DisabledAction)
    ],
  );
}
