import 'package:sl/sl/Validated.dart';
import 'package:sl/sl/state/Stateable.dart';

abstract class ModelScreen extends Validated {
  void addStateObserver(final Stateable stateable);

  void exit();

  Model getModel<Model>();

  void setModel<Model>(Model model);
}
