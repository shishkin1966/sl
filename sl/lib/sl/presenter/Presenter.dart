import 'package:sl/sl/model/Model.dart';
import 'package:sl/sl/order/Order.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';
import 'package:sl/sl/state/StateListener.dart';

abstract class Presenter<M extends Model> implements StateListener, MessagerSubscriber {
  void setModel<M>(M model);

  M getModel<M>();

  void onOrder(Order order);

  void doOrder(Order order);

  void doOrder2(String order, List<Object> objects);
}
