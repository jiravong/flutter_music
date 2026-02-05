import 'package:flutter_music_clean_getx/app/data/models/user_model.dart';

import '../repositories/user_repository.dart';

class UserUsecase {
  UserUsecase(this._repo);

  final UserRepository _repo;

  Future<UserModel> getUser() {
    return _repo.getUser();
  }


}
