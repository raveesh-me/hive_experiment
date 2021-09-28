import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_experiment/count_hive.dart';
import 'package:hive_experiment/count_store.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

_registerDependencies() async {
  getIt.registerSingletonAsync<CountHive>(() async => await CountHive.init());
  await getIt.allReady();
  getIt.registerSingletonWithDependencies<CountStore>(() => CountStore(),
      dependsOn: [CountHive]);
}

/// # Reactive persistence with Hive Value Listener
main() async {
  /// Initialize Hive on flutter |  boilerplate
  await Hive.initFlutter();
  await _registerDependencies();
  await getIt.allReady();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(builder: (_) {
        return Center(
          child: Text('${getIt<CountStore>().count}'),
        );
      }),
      floatingActionButton: FloatingActionButton(
        /// cache-able actions should ideally end in a write to the hive db
        onPressed: () {
          getIt<CountStore>().increment();
        },
      ),
    );
  }
}
