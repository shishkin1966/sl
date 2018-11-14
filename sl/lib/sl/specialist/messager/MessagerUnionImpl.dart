import 'package:rxdart/rxdart.dart';
import 'package:sl/sl/AbsSmallUnion.dart';
import 'package:sl/sl/Secretary.dart';
import 'package:sl/sl/SecretaryImpl.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/specialist/messager/MessagerSubscriber.dart';
import 'package:sl/sl/specialist/messager/MessagerUnion.dart';
import 'package:sl/sl/state/States.dart';
import 'package:sl/sl/util/StringUtils.dart';

class MessagerUnionImpl extends AbsSmallUnion<MessagerSubscriber> implements MessagerUnion {
  static const String NAME = "MessagerUnionImpl";

  Observable myObservable;
  Map<int, Message> _messages = new Map();
  Secretary<List<String>> _messagingList = new SecretaryImpl();
  int _id = 0;

  @override
  int compareTo(other) {
    return (other is MessagerUnion) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAddSubscriber(final MessagerSubscriber subscriber) {
    readMessages(subscriber);
  }

  @override
  void readMessages(final MessagerSubscriber subscriber) {
    if (subscriber == null) return;

    final List<Message> list = getMessage(subscriber);
    for (Message message in list) {
      final String state = subscriber.getState();
      if (state == States.StateReady) {
        message.read(subscriber);
        removeMessage(message);
      }
    }
  }

  @override
  List<Message> getMessage(final MessagerSubscriber subscriber) {
    if (subscriber != null) {
      if (_messages.isEmpty) {
        return new List();
      }

      // удаляем старые письма
      final String name = subscriber.getName();
      final int currentTime = new DateTime.now().millisecondsSinceEpoch;
      List<Message> list = _messages.values
          .where(
              (message) => (message.contains(name) && message.getEndTime() != -1 && message.getEndTime() < currentTime))
          .toList();
      if (list.isNotEmpty) {
        for (Message message in list) {
          _messages.remove(message.getId());
        }
      }
      if (_messages.isEmpty) {
        return new List();
      }
      list = _messages.values
          .where((message) =>
              message.contains(name) &&
              (message.getEndTime() == -1 || (message.getEndTime() != -1 && message.getEndTime() > currentTime)))
          .toList();
      list.sort((a, b) => a.getId().compareTo(b.getId()));
      return list;
    }

    return new List();
  }

  @override
  void removeMessage(final Message message) {
    if (message != null && _messages.containsKey(message.getId())) {
      _messages.remove(message.getId());
    }
  }

  @override
  void clearMail(final MessagerSubscriber subscriber) {
    if (subscriber == null) return;
    if (_messages.isEmpty) return;

    final String name = subscriber.getName();
    final List<Message> list = _messages.values.where((message) => message.contains(name)).toList();
    if (list.isNotEmpty) {
      for (Message message in list) {
        _messages.remove(message.getId());
      }
    }
  }

  @override
  void addMailingList(final String name, final List<String> addresses) {
    if (StringUtils.isNullOrEmpty(name) || addresses == null) return;
    if (addresses.isEmpty) return;

    _messagingList.put(name, addresses);
  }

  @override
  void removeMailingList(final String name) {
    if (StringUtils.isNullOrEmpty(name)) return;

    _messagingList.remove(name);
  }

  @override
  List<String> getMailingList(final String name) {
    if (StringUtils.isNullOrEmpty(name)) return null;

    if (_messagingList.containsKey(name)) {
      return _messagingList.get(name);
    } else {
      return null;
    }
  }
}
