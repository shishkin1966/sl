import 'package:contacts_service/contacts_service.dart';
import 'package:psb/common/StringUtils.dart';
import 'package:psb/sl/SLUtil.dart';
import 'package:psb/sl/data/Result.dart';
import 'package:psb/sl/specialist/repository/Repository.dart';
import 'package:psb/sl/specialist/repository/RepositorySpecialistImpl.dart';

class RepositoryContacts {
  static Future getContacts(Map<String, Object> map) async {
    String subscriber = map[RepositorySpecialistImpl.Subscriber];
    String id = map[RepositorySpecialistImpl.Id];
    String filter = map[RepositorySpecialistImpl.Filter];

    await SLUtil.repositorySpecialist.addLock(Repository.GetContacts, id);

    try {
      if (StringUtils.isNullOrEmpty(filter)) {
        var cache = await SLUtil.cacheSpecialist.get(Repository.GetContacts);
        if (cache != null) {
          Result<List<Contact>> result =
              new Result<List<Contact>>(cache as List<Contact>).setName(Repository.GetContacts);
          SLUtil.repositorySpecialist.onResult(subscriber, result);
          return;
        }
      }
      List<Contact> list = new List();
      Iterable<Contact> data;
      if (StringUtils.isNullOrEmpty(filter)) {
        data = await ContactsService.getContacts(
          withThumbnails: true,
        );
      } else {
        data = await ContactsService.getContacts(
          query: filter,
          withThumbnails: true,
        );
      }
      bool found = await SLUtil.repositorySpecialist.checkLock(Repository.GetContacts, id);
      if (found) {
        list.addAll(data);
        Result<List<Contact>> result = new Result<List<Contact>>(list).setName(Repository.GetContacts);
        SLUtil.repositorySpecialist.onResult(subscriber, result);
        if (StringUtils.isNullOrEmpty(filter)) {
          SLUtil.cacheSpecialist.put(Repository.GetContacts, list);
        }
      }
    } catch (e) {
      SLUtil.repositorySpecialist.onError(subscriber, Repository.GetContacts, e, id);
    }
  }
}
