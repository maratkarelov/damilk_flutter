import 'package:floor/floor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/remote/api/models/client/client_auth_model.dart';
import 'package:damilk_app/src/resources/const.dart';
import 'app_database.dart';

class Sim23LocalRepo {
  static final Sim23LocalRepo _instance = Sim23LocalRepo._internal();

  AppDatabase database;

  factory Sim23LocalRepo() {
    return _instance;
  }

  Sim23LocalRepo._internal() {
    initialDatabase();
  }

  void storeUser(ClientAuthModel clientAuthModel) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(Const.JWT_TOKEN, clientAuthModel.tokenModel.token);
    sharedPrefs.setString(
        Const.JWT_EXPIRED_AT, clientAuthModel.tokenModel.expiresAt);
    sharedPrefs.setBool(
        Const.IS_REGISTERED, clientAuthModel.clientModel.firstName.isNotEmpty);
  }

  static List<Migration> createMigrations() {
    List<Migration> migrations = List<Migration>();
    for (int i = 1; i < DB_VERSION; i++) {
      migrations.add(Migration(i, i + 1, (database) async {
        await database.execute("DROP TABLE TestEntity");
      }));
    }

    return migrations;
  }

  void clearDatabase() async {
    final preferences = await SharedPreferences.getInstance();
    final tutorialWatched = preferences.getBool(Const.MAIN_TUTORIAL_COMPLETED);
    await preferences.clear();
    await preferences.setBool(Const.MAIN_TUTORIAL_COMPLETED, tutorialWatched);

    //todo drop tables
  }

  Future<AppDatabase> initialDatabase() async {
    database = await $FloorAppDatabase
        .databaseBuilder('flutter_database.db')
        .addMigrations(createMigrations())
        .build();
    return Future.value(database);
  }

  void onUserRegistered(BaseResponse response) async{
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(Const.IS_REGISTERED, response.isSuccessful());
  }
}
