import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helper/preference_helper.dart';

class SettingPage extends StatefulWidget {
  static const int NUMBER_OF_PAST_DAYS_MIN = 0;
  static const int NUMBER_OF_PAST_DAYS_INIT = 1;
  static const int NUMBER_OF_PAST_DAYS_MAX = 7;
  static const int NUMBER_OF_COMING_DAYS_MIN = 0;
  static const int NUMBER_OF_COMING_DAYS_INIT = 14;
  static const int NUMBER_OF_COMING_DAYS_MAX = 21;

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _numberOfPastDays = 0;
  int _numberOfComingDays = 0;

  @override
  void initState() {
    PreferenceHelper.getPrefs().then((prefs) {
      setState(() {
        _numberOfPastDays =
            prefs.getInt(PreferenceHelper.KEY_NUMBER_OF_PAST_DAYS) ??
                SettingPage.NUMBER_OF_PAST_DAYS_INIT;
        _numberOfComingDays =
            prefs.getInt(PreferenceHelper.KEY_NUMBER_OF_COMING_DAYS) ??
                SettingPage.NUMBER_OF_COMING_DAYS_INIT;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Settings')),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Slider(
              value: _numberOfPastDays.toDouble(),
              min: SettingPage.NUMBER_OF_PAST_DAYS_MIN.toDouble(),
              max: SettingPage.NUMBER_OF_PAST_DAYS_MAX.toDouble(),
              divisions: (SettingPage.NUMBER_OF_PAST_DAYS_MAX -
                  SettingPage.NUMBER_OF_PAST_DAYS_MIN),
              label: _numberOfPastDays.round().toString(),
              onChangeEnd: (double value) {
                _numberOfPastDays = value.toInt();
                PreferenceHelper.setNumberOfPastDays(_numberOfPastDays);
              },
              onChanged: (double value) {
                setState(() => _numberOfPastDays = value.toInt());
              },
            ),
            Slider(
              value: _numberOfComingDays.toDouble(),
              min: SettingPage.NUMBER_OF_COMING_DAYS_MIN.toDouble(),
              max: SettingPage.NUMBER_OF_COMING_DAYS_MAX.toDouble(),
              divisions: (SettingPage.NUMBER_OF_COMING_DAYS_MAX -
                  SettingPage.NUMBER_OF_COMING_DAYS_MIN),
              label: _numberOfComingDays.round().toString(),
              onChangeEnd: (double value) {
                _numberOfComingDays = value.toInt();
                PreferenceHelper.setNumberOfComingDays(_numberOfComingDays);
              },
              onChanged: (double value) {
                setState(() => _numberOfComingDays = value.toInt());
              },
            )
          ],
        ),
      ),
    );
  }
}
