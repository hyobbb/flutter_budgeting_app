import 'package:budgeting/src/service/date_handler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

@deprecated
class DateSelectModal extends HookWidget {
  final DateTime focused;
  final bool includeDay;

  const DateSelectModal(this.focused, {this.includeDay = true});

  @override
  Widget build(BuildContext context) {
    final year = useState(focused.year);
    final month = useState(focused.month);
    final day = useState(focused.day);
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20.0),
      color: Colors.black.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                DateHandler.toText(
                  DateTime(year.value, month.value, day.value),
                  includeDay: includeDay,
                ),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              IconButton(
                  icon: Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(
                        context, DateTime(year.value, month.value, day.value));
                  }),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                NumberPicker(
                  value: year.value,
                  minValue: focused.year - 10,
                  maxValue: focused.year,
                  onChanged: (value) => year.value = value,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.1)),
                ),
                NumberPicker(
                  value: month.value,
                  minValue: 1,
                  maxValue: 12,
                  infiniteLoop: false,
                  onChanged: (value) => month.value = value,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.1)),
                ),
                if (includeDay)
                  ValueListenableBuilder<int>(
                      valueListenable: year,
                      builder: (_, year, __) {
                        return ValueListenableBuilder<int>(
                          valueListenable: month,
                          builder: (_, month, __) => NumberPicker(
                            value: day.value,
                            minValue: 1,
                            maxValue: DateHandler.numOfDay(month, year),
                            infiniteLoop: true,
                            onChanged: (value) => day.value = value,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white.withOpacity(0.1)),
                          ),
                        );
                      }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
