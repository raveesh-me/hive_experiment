import 'package:hive_experiment/count_hive.dart';
import 'package:hive_experiment/main.dart';
import 'package:mobx/mobx.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'count_store.g.dart';

class CountStore = _CountStoreBase with _$CountStore;

abstract class _CountStoreBase with Store {
  _CountStoreBase() {
    initialize();
  }

  @observable
  int count = 0;

  _updateCountFromLocal() {
    count = getIt<CountHive>().count;
  }

  initialize() {
    _updateCountFromLocal();
    getIt<CountHive>().box.listenable().addListener(_updateCountFromLocal);
  }

  @action
  increment() {
    getIt<CountHive>().count = count + 1;
  }
}
