import 'package:floor/floor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:damilk_app/src/repository/remote/api/models/base_response.dart';
import 'package:damilk_app/src/repository/remote/api/models/client/user_model.dart';
import 'package:damilk_app/src/resources/const.dart';
import 'app_database.dart';

class DamilkLocalRepo {
  static final DamilkLocalRepo _instance = DamilkLocalRepo._internal();

  AppDatabase database;

  factory DamilkLocalRepo() {
    return _instance;
  }

  DamilkLocalRepo._internal() {
    initialDatabase();
  }

  void storeUser(String jwt, bool isActivated) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setString(Const.JWT_TOKEN, jwt);
    sharedPrefs.setBool(Const.IS_REGISTERED, isActivated);
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

  void onUserRegistered(BaseResponse response) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setBool(Const.IS_REGISTERED, response.isSuccessful());
  }
}
