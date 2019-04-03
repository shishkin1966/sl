import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/message/AbsMessage.dart';
import 'package:psb/sl/message/Message.dart';
import 'package:psb/sl/message/ResponseListener.dart';
import 'package:psb/sl/specialist/messager/MessengerSubscriber.dart';

class ResultMessage extends AbsMessage {
  static const String NAME = "ResultMessage";

  Result _result;

  ResultMessage.result(final String address, final Result result) : super(null) {
    this.setAddress(address);
    _result = result;
  }

  ResultMessage(Message message) : super(message);

  @override
  ResultMessage copy() {
    return new ResultMessage(this).setResult(getResult());
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  void read(MessengerSubscriber subscriber) {
    if (subscriber is ResponseListener) {
      ResponseListener listener = subscriber as ResponseListener;
      listener.response(_result);
    }
  }

  ResultMessage setResult(Result result) {
    _result = result;
    return this;
  }

  Result getResult() {
    return _result;
  }
}
