import 'package:sl/sl/request/Request.dart';

abstract class AbsRequest implements Request {
  @override
  int compareTo(Request other) {
    return other.getRank() - this.getRank();
  }

  @override
  int getAction(Request oldRequest) {
    // TODO: implement getAction
    return null;
  }

  @override
  String getPassport() {
    return getName();
  }

  @override
  int getRank() {
    // TODO: implement getRank
    return null;
  }

  @override
  bool isCancelled() {
    // TODO: implement isCancelled
    return null;
  }

  @override
  bool isDistinct() {
    // TODO: implement isDistinct
    return null;
  }

  @override
  void setCanceled() {
    // TODO: implement setCanceled
  }

  @override
  void setRank(int rank) {
    // TODO: implement setRank
  }

  @override
  bool validate() {
    // TODO: implement validate
    return null;
  }
}
