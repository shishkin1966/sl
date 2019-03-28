import 'package:psb/sl/action/Action.dart';
import 'package:psb/sl/action/ActionSubscriber.dart';
import 'package:psb/sl/message/AbsMessage.dart';
import 'package:psb/sl/message/Message.dart';
import 'package:psb/sl/specialist/messager/MessengerSubscriber.dart';

class ActionMessage extends AbsMessage {
  static const String NAME = "ActionMessage";

  Action _action;

  ActionMessage(Message message) : super(message);

  ActionMessage.action(final String address, Action action) : super(null) {
    this.setAddress(address);

    _action = action;
  }

  @override
  Message copy() {
    return new ActionMessage(this).setAction(_action);
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  void read(MessengerSubscriber subscriber) {
    if (subscriber is ActionSubscriber) {
      (subscriber as ActionSubscriber).addAction(_action);
    } else {
      subscriber.read(this);
    }
  }

  ActionMessage setAction(Action action) {
    _action = action;
    return this;
  }

  Action getAction() {
    return _action;
  }
}
