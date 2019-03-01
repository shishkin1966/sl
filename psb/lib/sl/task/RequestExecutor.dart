import 'package:psb/sl/request/Request.dart';

abstract class RequestExecutor {
  void execute(Request request);

  void cancelRequests(String listener);

  void stop();

  void clear();
}
