import 'package:flutter/material.dart';

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
      body: ListView.builder(
        itemCount: percentages.length,
        itemBuilder: (context, index) {
          return OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TemperatureMenu()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.green, width: 4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    percentages[index],
                    textAlign: TextAlign.center,
                  ))
                ],
              ));
        },
      ),
    );
  }
}

class TemperatureMenu extends StatelessWidget {
  final List<String> percentages = [
    '20% ºC',
    '25% ºC',
    '30% ºC',
    '35% ºC',
    '40% ºC',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperaturas'),
        backgroundColor: Color.fromARGB(255, 14, 136, 45),
      ),
      body: ListView.builder(
        itemCount: percentages.length,
        itemBuilder: (context, index) {
          return OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.green, width: 4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text(
                    percentages[index],
                    textAlign: TextAlign.center,
                  ))
                ],
              ));
        },
      ),
    );
  }
}
