import 'package:music_roop/app/data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
}
