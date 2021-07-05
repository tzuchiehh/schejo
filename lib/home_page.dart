import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schejo/setting_page.dart';

import 'Util/date_time_util.dart';
import 'helper/database_helper.dart';
import 'helper/preference_helper.dart';
import 'model/daily_memo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _numberOfPastDays = 0;
  int _numberOfComingDays = 0;
  List<DailyMemo> _dailyMemoList = <DailyMemo>[];
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PreferenceHelper.getPrefs().then((prefs) {
      int numberOfPastDays =
          prefs.getInt(PreferenceHelper.KEY_NUMBER_OF_PAST_DAYS) ??
              SettingPage.NUMBER_OF_PAST_DAYS_INIT;
      int numberOfComingDays =
          prefs.getInt(PreferenceHelper.KEY_NUMBER_OF_COMING_DAYS) ??
              SettingPage.NUMBER_OF_COMING_DAYS_INIT;

      if (numberOfPastDays != _numberOfPastDays ||
          numberOfComingDays != _numberOfComingDays) {
        _numberOfPastDays = numberOfPastDays;
        _numberOfComingDays = numberOfComingDays;
        _dailyMemoList.clear();
        loadDatabase().then((dataList) {
          DateTime today = DateTime.now(); // Local time zone
          today =
              new DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
          for (int i = -_numberOfPastDays; i < _numberOfComingDays; i++) {
            DailyMemo dm = DailyMemo(today.add(Duration(days: i)));
            int dataItr = 0;
            while (dataItr < dataList.length) {
              DailyMemo data = dataList[dataItr];
              if (dm.date.isAtSameMomentAs(data.date)) {
                dm.id = data.id;
                dm.content = data.content;
                dataList.removeAt(dataItr);
                break;
              } else {
                dataItr++;
              }
            }
            _dailyMemoList.add(dm);
          }
          dataList.forEach((element) {
            DatabaseHelper.db.deleteDailyMemo(element.id);
          });
          setState(() {});
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 24,
            tooltip: 'Settings',
            alignment: Alignment.center,
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()))
                  .then((value) => setState(() {}));
            },
          ),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
          itemCount: _dailyMemoList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              // height: 50,
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              color: index < _numberOfPastDays
                  ? Theme.of(context).primaryColorDark
                  : Theme.of(context).primaryColorLight,
              child: new InkWell(
                onTap: () {
                  _textFieldController.text = _dailyMemoList[index].content;
                  showMemoDialog(index);
                },
                child: Row(children: [
                  Container(
                    width: 60,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          DateTimeUtil.convertDateTimeToString(
                              _dailyMemoList[index].date, DateFormat('MM/dd')),
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              backgroundColor: Colors.transparent),
                          maxLines: 1,
                        ),
                        Text(
                          DateTimeUtil.convertDateTimeToString(
                              _dailyMemoList[index].date, DateFormat('E')),
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              backgroundColor:
                                  _dailyMemoList[index].date.weekday > 5
                                      ? Theme.of(context).accentColor
                                      : Colors.transparent),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      _dailyMemoList[index].content,
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 20,
                          backgroundColor: Colors.transparent),
                    ),
                  )),
                ]),
              ),
            );
          }),
    );
  }

  Future<void> showMemoDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(DateTimeUtil.convertDateTimeToString(
              _dailyMemoList[index].date, DateFormat('MM/dd E'))),
          content: Builder(
            builder: (context) {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                      maxLines: 16,
                      keyboardType: TextInputType.multiline,
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      )));
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Clear', textAlign: TextAlign.start),
              onPressed: () {
                _textFieldController.text = '';
              },
            ),
            TextButton(
              child: const Text('Cancel', textAlign: TextAlign.right),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save', textAlign: TextAlign.right),
              onPressed: () {
                _dailyMemoList[index].content = _textFieldController.text;
                if (_dailyMemoList[index].content.isEmpty) {
                  if (_dailyMemoList[index].id >= 0) {
                    DatabaseHelper.db
                        .deleteDailyMemo(_dailyMemoList[index].id)
                        .then((value) => setState(() {}));
                  }
                } else {
                  DailyMemo memo = _dailyMemoList[index];
                  if (memo.id < 0) {
                    DatabaseHelper.db.insertDailyMemo(memo).then((value) {
                      _dailyMemoList[index].id = value;
                      setState(() {});
                    });
                  } else {
                    DatabaseHelper.db
                        .updateDailyMemo(memo)
                        .then((value) => setState(() {}));
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

Future<List<DailyMemo>> loadDatabase() async {
  return await DatabaseHelper.db.getDailyMemoList();
}
