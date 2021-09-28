import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class CountHive {
  late Box box;

  int get count => box.get('count') ?? 0;
  set count(int a) => box.put('count', a);

  static Future<CountHive> init() async {
    final countHive = CountHive();
    countHive.box = await Hive.openBox('countBox');
    return countHive;
  }

  dispose() {
    box.close();
  }
}
