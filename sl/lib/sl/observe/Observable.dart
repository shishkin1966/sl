import 'package:sl/sl/Subscriber.dart';
import 'package:sl/sl/specialist/observable/ObservableSubscriber.dart';

abstract class Observable<T, K extends ObservableSubscriber> extends Subscriber {
  void addObserver<K extends ObservableSubscriber>(K subscriber);

  void removeObserver<K extends ObservableSubscriber>(K subscriber);

  void register();

  void unregister();

  void onChange<T>(T object);

  List<K> getObservers<K extends ObservableSubscriber>();
}
