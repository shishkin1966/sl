import 'package:psb/sl/Subscriber.dart';
import 'package:psb/sl/specialist/observable/ObservableSubscriber.dart';

abstract class Observable<K extends ObservableSubscriber> extends Subscriber {
  void addObserver<K extends ObservableSubscriber>(K subscriber);

  void removeObserver<K extends ObservableSubscriber>(K subscriber);

  void register();

  void unregister();

  void onChange<T>(T object);

  List<K> getObservers<K extends ObservableSubscriber>();
}
