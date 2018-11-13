import 'package:sl/sl/Validated.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class Model<V> extends Validated {
  V _view;

  Model(V view) {
    _view = view;
  }

  void addStateObserver(final Stateable stateable);

  Presenter getPresenter();

  void setPresenter(Presenter presenter);

  V getView() {
    return _view;
  }
}
