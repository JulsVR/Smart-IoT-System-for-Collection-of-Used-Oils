import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//Global variables to fetch data from the API:
double temperature_f = 0.0;
double water_f = 0.0;
double food_oil_f = 0.0;
double impurities_f = 10.0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const Homepage(),
          );
        },
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: const Text('Projeto LPI OAU 22/23'),
                backgroundColor: Color.fromARGB(255, 14, 136, 45)),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            body: Card(
                //color: Colors.red,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Image.asset('assets/UFP_logo.png')),
              ],
            )),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PercentagesMenu()),
                );
              },
              child: const Icon(Icons.troubleshoot),
              backgroundColor: Color.fromARGB(169, 14, 136, 44),
            )));
  }
}

class PercentagesMenu extends StatelessWidget {
  final List<String> percentages = [
    '0% Água',
    '5% Água',
    '10% Água',
    '15% Água',
    '20% Água',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Percentagens'),
        backgroundColor: Color.fromARGB(255, 14, 136, 45),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: percentages.map((percentage) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                double selectedWater = double.parse(percentage.split('%')[0]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TemperatureMenu(
                      water: selectedWater,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 14, 136, 45),
                padding: EdgeInsets.all(20),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                percentage,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TemperatureMenu extends StatelessWidget {
  final List<String> temperatures = [
    '20% ºC',
    '25% ºC',
    '30% ºC',
    '35% ºC',
    '40% ºC',
  ];
  double? water;

  TemperatureMenu({this.water});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperaturas'),
        backgroundColor: Color.fromARGB(255, 14, 136, 45),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: temperatures.map((temperature) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                double selectedTemperature =
                    double.parse(temperature.split('%')[0]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OAUDetails(
                      temp_x: selectedTemperature,
                      water_x: water!,
                      food_oil_x: 100.0 - water!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 14, 136, 45),
                padding: EdgeInsets.all(20),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                temperature,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class OAUData {
  final String label;
  final double value;

  OAUData(this.label, this.value);
}

class OAUGraph extends State<OAUDetails> {
  late List<OAUData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  List<OAUData> getChartData() {
    final List<OAUData> chartData = [
      //OAUData('Temperature', widget.temp_x),
      OAUData('Água', widget.water_x),
      OAUData('Óleo Alimentar', widget.food_oil_x),
      OAUData('Impurezas', widget.impurities_x),
    ];
    //chartData.removeWhere((data) => data.value == 0.0);
    return chartData;
  }

  @override
  void initState() {
    super.initState();
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('OAU')),
        body: SfCircularChart(
          title: ChartTitle(
            text: 'Temperatura: ${widget.temp_x.toString()}ºC',
          ),
          legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          tooltipBehavior: _tooltipBehavior,
          series: <CircularSeries>[
            PieSeries<OAUData, String>(
              dataSource: _chartData,
              xValueMapper: (OAUData data, _) => data.label,
              yValueMapper: (OAUData data, _) => data.value,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              enableTooltip: true,
            ),
          ],
        ),
      ),
    );
  }
}

class OAUDetails extends StatefulWidget {
  double temp_x = temperature_f;
  double water_x = water_f;
  double food_oil_x = food_oil_f;
  double impurities_x = impurities_f;

  OAUDetails(
      {required this.temp_x, required this.water_x, required this.food_oil_x});

  @override
  OAUGraph createState() => OAUGraph();
}
