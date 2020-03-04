import 'dart:async';
import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:damilk_app/src/repository/local/models/test_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/test_dao.dart';


part 'app_database.g.dart'; // the generated code will be there
const DB_VERSION = 1;

@Database(version: DB_VERSION, entities: [TestEntity])
abstract class AppDatabase extends FloorDatabase {
  TestDao get bannerDataDao;
}