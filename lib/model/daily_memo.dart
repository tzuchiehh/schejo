import 'package:schejo/Util/date_time_util.dart';
import 'package:schejo/helper/database_helper.dart';

class DailyMemo {
  int id = -1;
  DateTime date = new DateTime(DateTime.now().year);
  String content = '';

  DailyMemo(this.date);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.COLUMN_DATE: DateTimeUtil.convertDateTimeToString(
          date, DatabaseHelper.dailyMemoDateFormat),
      DatabaseHelper.COLUMN_CONTENT: content
    };
    if (id >= 0) {
      map[DatabaseHelper.COLUMN_ID] = id;
    }
    return map;
  }

  DailyMemo.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseHelper.COLUMN_ID];
    date = DateTimeUtil.convertStringToDateTime(
        map[DatabaseHelper.COLUMN_DATE], DatabaseHelper.dailyMemoDateFormat);
    content = map[DatabaseHelper.COLUMN_CONTENT];
  }
}
