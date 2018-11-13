import 'package:sl/sl/Validated.dart';
import 'package:sl/sl/model/Model.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class ModelView extends Validated {
  void addStateObserver(final Stateable stateable);

  void exit();

  Model getModel();

  void setModel(Model model);
}
