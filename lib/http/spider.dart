import 'package:celechronalpha/database/database_helper.dart';
import 'package:celechronalpha/utils/tuple.dart';

import 'package:celechronalpha/model/grade.dart';
import 'package:celechronalpha/model/semester.dart';
import 'package:celechronalpha/model/todo.dart';

abstract class Spider {
  set db(DatabaseHelper? db);

  Future<List<String?>> login() async {
    throw UnimplementedError();
  }

  void logout() {
    throw UnimplementedError();
  }

  Future<
      Tuple7<
          List<String?>,
          List<String?>,
          List<Semester>,
          List<Grade>,
          List<double>,
          Map<DateTime, String>,
          List<Todo>>> getEverything() async {
    throw UnimplementedError();
  }
}
