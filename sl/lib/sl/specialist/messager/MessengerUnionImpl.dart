import 'package:sl/common/StringUtils.dart';
import 'package:sl/sl/AbsSmallUnion.dart';
import 'package:sl/sl/Secretary.dart';
import 'package:sl/sl/SecretaryImpl.dart';
import 'package:sl/sl/message/Message.dart';
import 'package:sl/sl/specialist/messager/MessengerSubscriber.dart';
import 'package:sl/sl/specialist/messager/MessengerUnion.dart';
import 'package:sl/sl/state/States.dart';

class MessengerUnionImpl extends AbsSmallUnion<MessengerSubscriber> implements MessengerUnion {
  static const String NAME = "MessagerUnionImpl";

  Map<int, Message> _messages = new Map();
  Secretary<List<String>> _messagingList = new SecretaryImpl();
  int _id = 0;

  @override
  int compareTo(other) {
    return (other is MessengerUnion) ? 0 : 1;
  }

  @override
  String getName() {
    return NAME;
  }

  @override
  void onAddSubscriber<T>(T subscriber) {
    readMessages(subscriber as MessengerSubscriber);
  }

  @override
  void readMessages(final MessengerSubscriber subscriber) {
    if (subscriber == null) return;

    final List<Message> list = getMessages(subscriber);
    for (Message message in list) {
      final String state = subscriber.getState();
      if (state == States.StateReady) {
        message.read(subscriber);
        removeMessage(message);
      }
    }
  }

  @override
  List<Message> getMessages(final MessengerSubscriber subscriber) {
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
  void clearMessages(final MessengerSubscriber subscriber) {
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
  void addMessagingList(final String name, final List<String> addresses) {
    if (StringUtils.isNullOrEmpty(name) || addresses == null) return;
    if (addresses.isEmpty) return;

    _messagingList.put(name, addresses);
  }

  @override
  void removeMessagingList(final String name) {
    if (StringUtils.isNullOrEmpty(name)) return;

    _messagingList.remove(name);
  }

  @override
  List<String> getMessagingList(final String name) {
    if (StringUtils.isNullOrEmpty(name)) return null;

    if (_messagingList.containsKey(name)) {
      return _messagingList.get(name);
    } else {
      return null;
    }
  }

  List<String> _getAddresses(final String address) {
    final List<String> addresses = new List();
    if (_messagingList.containsKey(address)) {
      for (String adr in _messagingList.get(address)) {
        addresses.addAll(_getAddresses(adr));
      }
    } else {
      addresses.add(address);
    }
    return addresses;
  }

  @override
  void addMessage(final Message message) {
    if (message != null) {
      List<String> list = message.getCopyTo();
      list.add(message.getAddress());
      List<String> addresses = new List();
      for (String address in list) {
        addresses.addAll(_getAddresses(address));
      }
      for (String address in addresses) {
        _id++;
        final Message newMessage = message.copy();
        newMessage.setId(_id);
        newMessage.setAddress(address);
        newMessage.setCopyTo(new List());

        if (!message.isCheckDublicate()) {
          _messages[_id] = newMessage;
        } else {
          _removeDublicate(newMessage);
          _messages[_id] = newMessage;
        }

        _checkAndAddMessage(address);
      }
    }
  }

  void _removeDublicate(final Message message) {
    if (message != null &&
        !StringUtils.isNullOrEmpty(message.getName()) &&
        !StringUtils.isNullOrEmpty(message.getAddress())) {
      for (Message tmpMail in _messages.values) {
        if (tmpMail != null) {
          if (message.getName() == (tmpMail.getName()) && message.getAddress() == (tmpMail.getAddress())) {
            removeMessage(tmpMail);
          }
        }
      }
    }
  }

  void _checkAndAddMessage(final String address) {
    if (StringUtils.isNullOrEmpty(address)) {
      return;
    }

    final MessengerSubscriber subscriber = getSubscriber(address);
    if (subscriber != null) {
      final String state = subscriber.getState();
      if (state == States.StateReady) {
        readMessages(subscriber);
      }
    }
  }

  @override
  void addNotMandatoryMessage(final Message message) {
    if (message != null) {
      List<String> list = message.getCopyTo();
      list.add(message.getAddress());
      List<String> addresses = new List();
      for (String address in list) {
        addresses.addAll(_getAddresses(address));
      }
      for (String address in addresses) {
        final MessengerSubscriber subscriber = _checkSubscriber(address);
        if (subscriber != null) {
          message.read(subscriber);
        }
      }
    }
  }

  MessengerSubscriber _checkSubscriber(final String address) {
    if (StringUtils.isNullOrEmpty(address)) {
      return null;
    }

    final MessengerSubscriber subscriber = getSubscriber(address);
    if (subscriber != null) {
      final String state = subscriber.getState();
      if (state == States.StateReady) {
        return subscriber;
      }
    }
    return null;
  }
}
