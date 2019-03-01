import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenPresenter<AddressScreenState extends WidgetState> extends AbsPresenter<AddressScreenState> {
  static const String NAME = "AddressScreenPresenter";

  AddressScreenPresenter(AddressScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {}

  @override
  void onReady() {
    super.onReady();
  }
}
