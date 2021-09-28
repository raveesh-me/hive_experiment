import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// # Reactive persistence with Hive Value Listener
main() async {
  /// Initialize Hive on flutter |  boilerplate
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  
  /// Store the reference to the box singleton over here. Subsequent 
  /// [Hive.openBox] will lead to the same singleton, but better to 
  /// do with a reference
  late Box _hiveBox;

  int count = 0;

  /// A callback that gets called on [Box.put]
  /// use this to update local reference, preferably within store
  notifyHiveUpdated() {
    print('Hive Updated');
    setState(() {
      count = _hiveBox.get('count');
    });
  }

  /// initialize the box properly, add listener and stuff, 
  /// call the listener once to make sure that at startup, we load UI from
  /// local database
  _initHive() async {
    setState(() {
      _isLoading = true;
    });
    _hiveBox = await Hive.openBox('count');
    _hiveBox.listenable().addListener(notifyHiveUpdated);
    notifyHiveUpdated();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$count'),
      ),
      floatingActionButton: FloatingActionButton(
        /// cache-able actions should ideally end in a write to the hive db
        onPressed: () {
          _hiveBox.put('count', count + 1);
        },
      ),
    );
  }
}
