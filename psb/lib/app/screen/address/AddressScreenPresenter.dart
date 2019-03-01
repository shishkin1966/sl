import 'package:location/location.dart';
import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/DataAction.dart';
import 'package:psb/sl/presenter/AbsPresenter.dart';
import 'package:psb/ui/WidgetState.dart';

class AddressScreenPresenter<AddressScreenState extends WidgetState> extends AbsPresenter<AddressScreenState> {
  static const String NAME = "AddressScreenPresenter";
  static const String LocationChanged = "LocationChanged";

  Location _location;

  AddressScreenPresenter(AddressScreenState lifecycleState) : super(lifecycleState);

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAction(Action action) {}

  @override
  Future onReady() async {
    super.onReady();

    _location = new Location();

    if (_location.hasPermission == false) {
    } else {
      LocationData data = await _location.getLocation();
      getWidget().addAction(new DataAction(LocationChanged).setData(data));

      _location.onLocationChanged().listen((location) async {
        getWidget().addAction(new DataAction(LocationChanged).setData(location));
      });
    }
  }
}
