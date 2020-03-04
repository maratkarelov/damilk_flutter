import 'package:floor/floor.dart';

@entity
class TestEntity {
  @primaryKey
  final String id;

  TestEntity(this.id);
}