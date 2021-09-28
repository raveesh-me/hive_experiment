import 'package:mobx/mobx.dart';
part 'count_store.g.dart';

class CountStore = _CountStoreBase with _$CountStore;

abstract class _CountStoreBase with Store {
  @observable
  late int count;

}
