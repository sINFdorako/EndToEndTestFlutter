import 'package:driver_native/battery_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Driver Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Driver Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('replay_kit');

  Future<void> _startRecording() async {
    try {
      await platform.invokeMethod('startRecording');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started'),
        ),
      );
    } on PlatformException catch (e) {
      print("Failed to start recording: '${e.message}'.");
    }
  }

  Future<void> _stopRecording() async {
    try {
      await platform.invokeMethod('stopRecording');
    } on PlatformException catch (e) {
      print("Failed to stop recording: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              key: ValueKey('Hello World'),
              'Hello World',
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            key: const ValueKey('startRecordingButton'),
            onPressed: _startRecording,
            child: const Icon(Icons.fiber_manual_record),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const ValueKey('stopRecordingButton'),
            onPressed: _stopRecording,
            child: const Icon(Icons.stop),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: const ValueKey('batteryButton'),
            onPressed: () => {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BatteryLevel(),
              ))
            },
            child: const Icon(Icons.battery_0_bar),
          ),
        ],
      ),
    );
  }
}
