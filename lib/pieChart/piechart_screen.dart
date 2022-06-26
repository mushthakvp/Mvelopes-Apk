import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:mvelopes/colors/colors.dart';
import 'package:mvelopes/dbFunctions/transaction_data_functions.dart';
import 'package:mvelopes/pieChart/piechart_functions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  DateTime selectedmonth = DateTime.now();
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    getdata(selectedmonth);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Chartdata> chartData =
        listOfData(TransactionData.instance.sortListner.value);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Statistics'),
        centerTitle: true,
        backgroundColor: indigColor,
        actions: [
          IconButton(
              onPressed: () {
                _pickDate(context);
              },
              icon: const Icon(Icons.sort)),
          //
        ],
      ),
      body: SafeArea(
        child: chartData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/image/noChart.svg',
                      height: 160,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'No Transaction Data',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: pinkColor,
                      letterSpacing: 1,
                      fontSize: 16,
                    ),
                  )
                ],
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
                child: SfCircularChart(
                    tooltipBehavior: _tooltipBehavior,
                    legend: Legend(
                        iconHeight: 20,
                        padding: 10,
                        isVisible: true,
                        overflowMode: LegendItemOverflowMode.wrap),
                    series: <CircularSeries>[
                      // Render pie chart
                      PieSeries<Chartdata, String>(
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelIntersectAction: LabelIntersectAction.shift,
                          ),
                          dataSource: chartData,
                          xValueMapper: (Chartdata data, _) => data.categories,
                          yValueMapper: (Chartdata data, _) => data.amount,
                          explode: true,
                          explodeIndex: 1),
                    ]),
              ),
      ),
    );
  }

  _pickDate(context) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: selectedmonth,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    setState(() {
      selectedmonth = selected!;
    });

    getdata(selectedmonth);
  }
}

// ignore: constant_identifier_names
enum Menu { All, Today, Yesterday, Monthly }
