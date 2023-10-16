import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_emilator_1/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase for the default app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'V0001',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'V0001 Home Page'),
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
  int _counter = 0;
  bool _emulator = true;
  late FirebaseFirestore db;
  // String host = Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
  String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    db.settings = const Settings(
      persistenceEnabled: false,
    );

    debugPrint(' Platform.isAndroid  ${Platform.isAndroid}');

    if (_emulator) {
      // Initialize Firestore with emulator settings
      db.useFirestoreEmulator(host, 8080, sslEnabled: false);
    }
  }

  @override
  void didChangeDependencies() async {
    // Now you can use Firestore with the emulator
    await db.collection("users").doc("tadas").get().then((value) {
      setState(() {
        if (value.exists) {
          _counter = value.data()!['count'];
        }
      });
    });
    super.didChangeDependencies();
  }

  // void onUseEmulatorChange(bool? value) {
  //   if (value != null) {
  //     setState(() {
  //       _emulator = value;
  //       // Reinitialize Firestore with the emulator or cloud settings
  //       db = FirebaseFirestore.instance;

  //       if (_emulator) {
  //         db.useFirestoreEmulator(host, 8080);
  //       }
  //     });
  //   }
  //   super.didChangeDependencies();
  // }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      db.collection("users").doc("tadas").set({'count': _counter});
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 100,
            ),
            // CheckboxListTile(
            //   title: const Text('Enable Firebase Emulator'),
            //   value: _emulator,
            //   onChanged: onUseEmulatorChange,
            //   controlAffinity: ListTileControlAffinity.trailing,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
