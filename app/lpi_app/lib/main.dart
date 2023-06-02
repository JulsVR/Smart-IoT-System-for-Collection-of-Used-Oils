import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

//Global variables to fetch data from the API:
double? temperature_f;
double? water_f;
double? food_oil_f;
double? impurities_f = 10.0;
double? turbidity_f;
double? air_temp_f;
double? flow_f;
double? humidity_f;

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
            floatingActionButton:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PercentagesMenu()),
                  );
                },
                child: const Icon(Icons.troubleshoot),
                backgroundColor: Color.fromARGB(169, 14, 136, 44),
              ),
              const SizedBox(
                height: 16,
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TablesMenu(
                              temp_x: temperature_f,
                              water_x: water_f,
                              food_oil_x: food_oil_f,
                              impurities_x: impurities_f,
                              turbidity_x: turbidity_f,
                              air_temp_x: air_temp_f,
                              flow_x: flow_f,
                              humidity_x: humidity_f,
                            )),
                  );
                },
                child: const Icon(Icons.dataset),
                backgroundColor: Color.fromARGB(169, 14, 136, 44),
              )
            ])));
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
    '20 ºC',
    '25 ºC',
    '30 ºC',
    '35 ºC',
    '40 ºC',
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
                    double.parse(temperature.split('ºC')[0]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OAUDetails(
                      title: 'Title',
                      temp_x: selectedTemperature,
                      water_x: water!,
                      food_oil_x: 100.0 - water!,
                      impurities_x: 0.0,
                      turbidity_x: 0.0,
                      air_temp_x: 0.0,
                      flow_x: 0.0,
                      humidity_x: 0.0,
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
  //For the chart
  final String label;
  final double? value;
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
      OAUData('Turbidez', widget.turbidity_x),
      OAUData('Temperatura do Ar', widget.air_temp_x),
      OAUData('Fluxo', widget.flow_x),
      OAUData('Humidade', widget.humidity_x),
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
  String? title;
  double? temp_x = temperature_f;
  double? water_x = water_f;
  double? food_oil_x = food_oil_f;
  double? impurities_x = impurities_f;
  double? turbidity_x = turbidity_f;
  double? air_temp_x = air_temp_f;
  double? flow_x = flow_f;
  double? humidity_x = humidity_f;

  OAUDetails(
      {required this.title,
      required this.temp_x,
      required this.water_x,
      required this.food_oil_x,
      required this.impurities_x,
      required this.turbidity_x,
      required this.air_temp_x,
      required this.flow_x,
      required this.humidity_x});

  @override
  OAUGraph createState() => OAUGraph();
}

class TablesMenu extends StatefulWidget {
  double? temp_x = temperature_f;
  double? water_x = water_f;
  double? food_oil_x = food_oil_f;
  double? impurities_x = impurities_f;
  double? turbidity_x = turbidity_f;
  double? air_temp_x = air_temp_f;
  double? flow_x = flow_f;
  double? humidity_x = humidity_f;
  //OAUDetails oauDetails;

  TablesMenu({
    required this.temp_x,
    required this.water_x,
    required this.food_oil_x,
    required this.impurities_x,
    required this.turbidity_x,
    required this.air_temp_x,
    required this.flow_x,
    required this.humidity_x,
    //required this.oauDetails,
  });

  @override
  _TablesMenuState createState() => _TablesMenuState();
}

class _TablesMenuState extends State<TablesMenu> {
  List<OAUDetails> getTableData() {
    return [
      OAUDetails(
        title: 'T1',
        temp_x: 25.0,
        water_x: water_f,
        food_oil_x: food_oil_f,
        impurities_x: impurities_f,
        turbidity_x: turbidity_f,
        air_temp_x: air_temp_f,
        flow_x: flow_f,
        humidity_x: humidity_f,
      ),
      OAUDetails(
        title: 'T2',
        temp_x: 30.0,
        water_x: water_f,
        food_oil_x: food_oil_f,
        impurities_x: impurities_f,
        turbidity_x: turbidity_f,
        air_temp_x: air_temp_f,
        flow_x: flow_f,
        humidity_x: humidity_f,
      ),
      OAUDetails(
        title: 'T3',
        temp_x: 35.0,
        water_x: water_f,
        food_oil_x: food_oil_f,
        impurities_x: impurities_f,
        turbidity_x: turbidity_f,
        air_temp_x: air_temp_f,
        flow_x: flow_f,
        humidity_x: humidity_f,
      ),
      OAUDetails(
        title: 'T4',
        temp_x: 40.0,
        water_x: water_f,
        food_oil_x: food_oil_f,
        impurities_x: impurities_f,
        turbidity_x: turbidity_f,
        air_temp_x: air_temp_f,
        flow_x: flow_f,
        humidity_x: humidity_f,
      ),
      OAUDetails(
        title: 'T5',
        temp_x: 45.0,
        water_x: water_f,
        food_oil_x: food_oil_f,
        impurities_x: impurities_f,
        turbidity_x: turbidity_f,
        air_temp_x: air_temp_f,
        flow_x: flow_f,
        humidity_x: humidity_f,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              title: Text('Tabelas'),
              backgroundColor: Color.fromARGB(255, 14, 136, 45)),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Tabela 1',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: SfDataGrid(
                  source: OAUDataSource(getTableData()),
                  columns: [
                    GridColumn(
                      columnName: 'temp',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Temperatura',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'food_oil',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Óleo Alimentar',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'water',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Água',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'air_temp',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Temperatura do Ar',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'humidity',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Humidade',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'flow',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Fluxo',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'turbidity',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Turbidez',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'impurities',
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Impurezas',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class OAUDataSource extends DataGridSource {
  OAUDataSource(List<OAUDetails> data) {
    dataGridRows = data.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'temp', value: dataGridRow.air_temp_x), //Fix
        DataGridCell(columnName: 'food_oil', value: dataGridRow.food_oil_x),
        DataGridCell(columnName: 'water', value: dataGridRow.water_x),
        DataGridCell(columnName: 'air_temp', value: dataGridRow.air_temp_x),
        DataGridCell(columnName: 'humidity', value: dataGridRow.humidity_x),
        DataGridCell(columnName: 'flow', value: dataGridRow.flow_x),
        DataGridCell(columnName: 'turbidity', value: dataGridRow.turbidity_x),
        DataGridCell(columnName: 'impurities', value: dataGridRow.impurities_x),
      ]);
    }).toList();
  }

  late List<DataGridRow> dataGridRows;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}
