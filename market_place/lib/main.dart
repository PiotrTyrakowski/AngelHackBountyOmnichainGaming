import 'package:flutter/material.dart';
import 'dart:js' as js;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web JS Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Web with JavaScript'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Execute JavaScript code using the js package
            js.context.callMethod('alert', ['Hello from JavaScript!']);
          },
          child: Text('Run JavaScript'),
        ),
      ),
    );
  }
}
