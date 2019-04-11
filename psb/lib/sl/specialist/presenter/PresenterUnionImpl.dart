import 'package:psb/sl/AbsSmallUnion.dart';
import 'package:psb/sl/presenter/Presenter.dart';
import 'package:psb/sl/specialist/presenter/PresenterUnion.dart';

class PresenterUnionImpl extends AbsSmallUnion<Presenter> implements PresenterUnion {
  static const String NAME = "PresenterUnionImpl";

  @override
  int compareTo(other) {
    return (other is PresenterUnion) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  C getPresenter<C>(String name) {
    return this.getSubscriber(name);
  }
}
