import 'package:psb/sl/SmallUnion.dart';
import 'package:psb/sl/presenter/Presenter.dart';

abstract class PresenterUnion extends SmallUnion<Presenter> {
  C getPresenter<C>(final String name);
}
