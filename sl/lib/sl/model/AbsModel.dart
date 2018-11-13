import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/model/Model.dart';
import 'package:sl/sl/model/ModelView.dart';
import 'package:sl/sl/presenter/Presenter.dart';
import 'package:sl/sl/state/StateObservable.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class AbsModel implements Model, Stateable {
  ModelView _modelView;
  Presenter _presenter;
  StateObservable _lifecycle;

  AbsModel(final ModelView modelView) {
    _modelView = modelView;
    _lifecycle = new StateObservable();
    if (_modelView != null) {
      _modelView.addStateObserver(this);
    }
  }

  @override
  void addStateObserver(Stateable stateable) {
    if (stateable == null) return;

    _lifecycle.addObserver(stateable);
  }

  @override
  Presenter getPresenter() {
    return _presenter;
  }

  @override
  AbsModel setPresenter(Presenter<Model> presenter) {
    _presenter = presenter;
    addStateObserver(presenter);
    return this;
  }

  @override
  ModelView getView() {
    return _modelView;
  }

  @override
  bool validate() {
    return validateExt().getData();
  }

  @override
  Result<bool> validateExt() {
    if (_modelView != null) {
      return _modelView.validateExt();
    }
    return new Result<bool>(false);
  }

  @override
  String getState() {
    return _lifecycle.getState();
  }

  @override
  void setState(String state) {
    _lifecycle.setState(state);
  }
}
