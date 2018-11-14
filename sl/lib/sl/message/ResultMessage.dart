import 'package:sl/sl/data/Result.dart';
import 'package:sl/sl/message/AbsMessage.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/request/ResponseListener.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';

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
    return new ResultMessage(this).setResult(_result);
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  void read(MessagerSubscriber subscriber) {
    if (subscriber is ResponseListener) {
      (subscriber as ResponseListener).response(this._result);
    }
  }

  ResultMessage setResult(Result result) {
    _result = result;
    return this;
  }
}
