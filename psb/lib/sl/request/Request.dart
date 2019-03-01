import 'package:psb/sl/Subscriber.dart';

abstract class Request implements Subscriber, Comparable<Request> {
  int getRank();

  void setRank(int rank);

  void setCanceled();

  bool isCancelled();

  bool validate();

  bool isDistinct();

  int getAction(Request oldRequest);
}
