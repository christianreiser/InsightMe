

// class TmpRoute extends StatefulWidget {
//   static DatabaseHelperAttribute databaseHelperAttribute =
//       DatabaseHelperAttribute();
//
//   @override
//   TmpRouteState createState() => TmpRouteState();
// }

// class ChartData {
//   ChartData(this.month, this.sales);
//
//   final DateTime month;
//   final double sales;
// }

// class TmpRouteState extends State<TmpRoute> {
//   final DatabaseHelperEntry helperEntry = // error when static
//       DatabaseHelperEntry();

  // TooltipBehavior _tooltipBehavior;
  //
  // @override
  // void initState() {
  //   _tooltipBehavior = TooltipBehavior(enable: true);
  // }

  // List<_SalesData> data = [
  //   _SalesData('Jan', 35),
  //   _SalesData('Feb', 28),
  //   _SalesData('Mar', 34),
  //   _SalesData('Apr', 32),
  //   _SalesData('May', 40)
  // ];

  // final List<ChartData> chartData = <ChartData>[
  //   ChartData(DateTime.utc(1989, 11, 9), 23),
  //   ChartData(DateTime.utc(1999, 11, 9), 35),
  //   ChartData(DateTime.utc(2010, 11, 9), 19)
  // ];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: IconButton(
  //         icon: Icon(Icons.close),
  //         onPressed: () async {
  //           NavigationHelper().navigateToFutureDesign(context); // refreshes
  //         },
  //       ),
  //       title: Text('tmp'),
  //     ),
  //     body: Padding(
  //         padding: const EdgeInsets.all(12.0), child: sfCartesianChart(chartData)),
  //   ); // type lineChart
  // }

  // Widget sfCartesianChart(chartData) {
  //   return SfCartesianChart(
  //       primaryXAxis: CategoryAxis(),
  //       // Chart title
  //       title: ChartTitle(text: 'Half yearly sales analysis'),
  //       // Enable legend
  //       legend: Legend(isVisible: true),
  //       // Enable tooltip
  //       tooltipBehavior: _tooltipBehavior,
  //       series: <ChartSeries>[
  //         // Renders scatter chart
  //         ScatterSeries<ChartData, DateTime>(
  //             dataSource: chartData,
  //             xValueMapper: (ChartData sales, _) => sales.month,
  //             yValueMapper: (ChartData sales, _) => sales.sales,
  //             // Enable data label
  //             dataLabelSettings: DataLabelSettings(isVisible: true))
  //       ]);
  // }
// }
