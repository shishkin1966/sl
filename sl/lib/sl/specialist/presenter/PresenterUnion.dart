import 'package:sl/sl/SmallUnion.dart';
import 'package:sl/sl/presenter/Presenter.dart';

abstract class PresenterUnion extends SmallUnion<Presenter> {
  C getPresenter<C>(final String name);
}
