import 'package:sl/sl/specialist/observable/ObservableSubscriber.dart';

abstract class ObjectObservableSubscriber extends ObservableSubscriber {
  List<String> getListenObjects();
}
