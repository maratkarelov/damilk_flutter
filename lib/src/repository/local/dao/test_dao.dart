import 'package:floor/floor.dart';
import 'package:damilk_app/src/repository/local/models/test_entity.dart';

@dao
abstract class TestDao {
  @Query('SELECT * FROM TestEntity')
  Future<List<TestEntity>> getAllEntities();
}
