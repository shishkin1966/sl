import 'dart:core';

import 'package:sl/common/StringUtils.dart';
import 'package:sl/sl/message/Message.dart';

abstract class AbsMessage extends Message {
  String _address;
  String _sender;
  List<String> _copyTo = new List();
  int _id = 0;
  int _endTime = -1;

  AbsMessage(final Message message) {
    if (message != null) {
      _address = message.getAddress();
      _sender = message.getSender();
      _copyTo = message.getCopyTo();
      _id = message.getId();
      _endTime = message.getEndTime();
    }
  }

  @override
  String getAddress() {
    return _address;
  }

  @override
  AbsMessage setAddress(final String address) {
    _address = address;
    return this;
  }

  @override
  String getSender() {
    return _sender;
  }

  @override
  AbsMessage setSender(final String sender) {
    _sender = sender;
    return this;
  }

  @override
  List<String> getCopyTo() {
    return _copyTo;
  }

  @override
  AbsMessage setCopyTo(List<String> copyTo) {
    if (copyTo == null) return this;

    _copyTo.clear();
    _copyTo.addAll(copyTo);
    return this;
  }

  @override
  int getId() {
    return _id;
  }

  @override
  AbsMessage setId(int id) {
    _id = id;
    return this;
  }

  @override
  bool contains(String address) {
    if (StringUtils.isNullOrEmpty(address)) {
      return false;
    }

    if (address == _address) {
      return true;
    }

    return _copyTo.contains(address);
  }

  @override
  int getEndTime() {
    return _endTime;
  }

  @override
  String getPasport() {
    return getName();
  }

  @override
  bool isCheckDublicate() {
    return false;
  }

  @override
  AbsMessage setEndTime(int keepAliveTime) {
    _endTime = keepAliveTime;
    return this;
  }
}
