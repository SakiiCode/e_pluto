import 'package:flutter/material.dart';
import 'package:timetable/timetable.dart';
import 'dart:convert' show json;
import '../RequestHelper.dart';
import 'package:time_machine/time_machine.dart';

class TimetableFragment extends StatelessWidget {

  Future<List<dynamic>> load(context) async {
    String response = await RequestHelper.getTimeTable(new DateTime.now().subtract(new Duration(days:7)), new DateTime.now().add(new Duration(days:7)));
    var timetableJson = json.decode(response);
    var lessons = timetableJson["calendarData"][0]["title"];
    return timetableJson["calendarData"];

  }


  Future<void> showEventDetails(String details, context) async {
    String formatted = details.replaceAll(new RegExp(r"\s\s+"), ",").replaceAll(new RegExp(r"[\(\[\(\)\]\)]"), ",");
    List<String> parts = formatted.split(",");
    for(int i=0;i<parts.length;i++){
      parts[i] = parts[i].trim();
      if(parts[i]==""){
        parts.removeAt(i);
      }
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Részletek"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Név',style: TextStyle(fontWeight: FontWeight.bold)),
                Text('  '+(parts.length>1?parts[1]:'Ismeretlen')),
                Text('Hetek',style: TextStyle(fontWeight: FontWeight.bold)),
                Text('  '+(parts.length>4?parts[4]:'Ismeretlen')),
                Text('NEPTUN-kód',style: TextStyle(fontWeight: FontWeight.bold)),
                Text('  '+(parts.length>2?parts[2]:'Ismeretlen')),
                Text('Oktató',style: TextStyle(fontWeight: FontWeight.bold)),
                Text('  '+(parts.length>5?parts[5]:'Ismeretlen')),
                Text('Hely',style: TextStyle(fontWeight: FontWeight.bold)),
                Text('  '+(parts.length>6?parts[6]:'Ismeretlen')),
                Text('Kurzus kódja',style: TextStyle(fontWeight: FontWeight.bold)),
                Text('  '+(parts.length>3?parts[3].substring(2):'Ismeretlen')),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return new Center(
      child: FutureBuilder(
        future: load(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("Hiba történt a betöltéskor"),
                  ),
                );
              }else {

                List<BasicEvent> eventsArr = [];

                for(int i=0;i<snapshot.data.length;i++){
                  var lesson = snapshot.data[i];
                  int start = int.parse(lesson["start"].substring(6,19));
                  int end = int.parse(lesson["end"].substring(6,19));
                  String title = lesson["title"].split("]")[1].split("(")[0].trim();
                  //print(title);
                  eventsArr.add(BasicEvent(
                    id: i,
                    title: title,
                    color: Colors.blue,
                    start: LocalDateTime.dateTime(DateTime.fromMillisecondsSinceEpoch(start)),
                    end: LocalDateTime.dateTime(DateTime.fromMillisecondsSinceEpoch(end)),
                  ));
                }
                var myEventProvider = EventProvider.list(eventsArr);
                DateTime today = DateTime.now();
                var monday = today.subtract(new Duration(days: today.weekday-1));

                return Timetable<Event>(
                  controller: TimetableController(
                    eventProvider: myEventProvider,
                    // Optional parameters with their default values:
                    initialTimeRange: InitialTimeRange.range(
                      startTime: LocalTime(8, 0, 0),
                      endTime: LocalTime(20, 0, 0),
                    ),
                    initialDate: LocalDate.dateTime(monday),
                    visibleRange: VisibleRange.days(5),
                    firstDayOfWeek: DayOfWeek.monday,
                  ),
                  eventBuilder: (event) => BasicEventWidget(
                    event,
                    onTap: () => showEventDetails(snapshot.data[event.id]["title"],context),
                  ),
                  allDayEventBuilder: (context, event, info) =>
                      BasicAllDayEventWidget(event, info: info),
                );
              }
          } else {
            return Container(
              child: Center(
                child: Text("Betöltés..."),
              ),
            );
          }
        },
      ),
    );
  }



}