import 'package:flutter/material.dart';

void main() {
  runApp(MyMain());
}

class MyMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

int count = 0;

class _DashboardState extends State<Dashboard> {
  void mCounters() {
    count++;

    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#CounterApp"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("#: $count"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          mCounters();
        },
        child: Text("ok"),
      ),
    );
  }
}
