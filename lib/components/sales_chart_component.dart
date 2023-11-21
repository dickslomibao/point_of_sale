import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/sales_model.dart';
import '../provider/theme_color.dart';

class SalesChart extends StatelessWidget {
  SalesChart({
    required this.data,
    required this.title,
    this.receivable = -1,
    Key? key,
  }) : super(key: key);
  String title;
  List<Sales> data;
  double receivable;
  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  child: SfCartesianChart(
                    title: ChartTitle(
                      textStyle: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: theme.primary,
                      ),
                      text: title,
                    ),
                    primaryXAxis: CategoryAxis(),
                    plotAreaBorderColor: theme.primary,
                    series: <LineSeries<Sales, String>>[
                      LineSeries<Sales, String>(
                        dataSource: data,
                        xValueMapper: (Sales sales, _) => sales.name,
                        yValueMapper: (Sales sales, _) => sales.sales,
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          color: theme.primary,
                        ),
                      )
                    ],
                  ),
                ),
                if (receivable != -1)
                  Text(
                    'Receivable:${receivable}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
