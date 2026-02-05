import 'package:flutter_music_clean_getx/app/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
}
