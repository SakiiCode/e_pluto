import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';

class RequestHelper {
  static final storage = new FlutterSecureStorage();




  static Future<String> getStuffFromUrl(String url, String body) async {
    if(!await DataConnectionChecker().hasConnection){
      print("No connection");
      return null;
    }

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true); //todo ezt minél előbb megszüntetni
    final HttpClientRequest request = await client.postUrl(Uri.parse(url))
      ..headers.set("Content-Type", "application/json; charset=utf-8")
      ..headers.set("Content-Length", body.length)
      ..headers.set("Expect", "100-continue")
      ..headers.set("Host", url.split("/")[2])
      ..add(utf8.encode(body));

    print("Request: " + url);
    print(request.headers);
    return await (await request.close()).transform(utf8.decoder).join();
  }

  static Future<String> login(context) async {
    String universityUrl = await RequestHelper.storage.read(key: "universityUrl");
    if (universityUrl != null) {
      String username = await RequestHelper.storage.read(key: "username");
      String password = await RequestHelper.storage.read(key: "password");
      String trainings = await RequestHelper.getTrainings(universityUrl, username, password);
      try {
        Map<String, dynamic> response = json.decode(trainings.trim());

        if (response["ErrorMessage"] == null) {
          await RequestHelper.storage.write(key: "trainingId", value: response["TrainingList"][0]["Id"].toString());
          return "OK";
        } else {
          return "Hiba: " + response["ErrorMessage"];
        }
      } catch (e) {
        return "Hiba: " + e.toString();
      }
    }
    return "Nincs kijelölt intézmény";
  }

  static Future<String> getInstitutes() async {
    final String url = "https://mobilecloudservice.cloudapp.net/MobileServiceLib/MobileCloudService.svc/GetAllNeptunMobileUrls";
    String asd = await getStuffFromUrl(url, "{}");
    return asd;
  }

  static Future<String> getTrainings(String schoolUrl, String userName, String password) {
    String url = schoolUrl + "/GetTrainings";
    String body = '{"OnlyLogin":false,"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"' +
        userName +
        '","Password":"' +
        password +
        '","NeptunCode":null,"CurrentPage":0,"StudentTrainingID":null,"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}';
    Future<String> response = getStuffFromUrl(url, body);

    return response;
  }

  static Future<String> getMessages() async {
    String universityUrl = await storage.read(key: "universityUrl");
    String userName = await storage.read(key: "username");
    String password = await storage.read(key: "password");
    String trainingId = await storage.read(key: "trainingId");
    return getStuffFromUrl(
        universityUrl + "/GetMessages",
        '{"TotalRowCount":-1,"ExceptionsEnum":0,"ForumName":"","UserLogin":"' +
            userName +
            '","Password":"' +
            password +
            '","NeptunCode":"' +
            userName +
            '","CurrentPage":0,"StudentTrainingID":' +
            trainingId +
            ',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');
  }

  Future<String> getEvaluations(String schoolUrl, String userName, String password, String trainingId) => getStuffFromUrl(
      schoolUrl + "/GetMarkbookData",
      '{"filter":{"TermID":0},"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"' +
          userName +
          '","Password":"' +
          password +
          '","NeptunCode":"' +
          userName +
          '","CurrentPage":1,"StudentTrainingID":"' +
          trainingId +
          '","LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');

  Future<String> getForums(String schoolUrl, String userName, String password, String trainingId) => getStuffFromUrl(
      schoolUrl + "/GetForums",
      '{"TotalRowCount":-1,"ExceptionsEnum":0,"ForumName":"","UserLogin":"' +
          userName +
          '","Password":"' +
          password +
          '","NeptunCode":"' +
          userName +
          '","CurrentPage":0,"StudentTrainingID":' +
          trainingId +
          ',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');

  Future<String> getEvents(String schoolUrl, String userName, String password, String trainingId) => getStuffFromUrl(
      schoolUrl + "/GetPeriods",
      '{"PeriodTermID":70618,"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"' +
          userName +
          '","Password":"' +
          password +
          '","NeptunCode":"' +
          userName +
          '","CurrentPage":0,"StudentTrainingID":' +
          trainingId +
          ',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');

  static Future<String> getTimeTable(DateTime from, DateTime to) async {
    String universityUrl = await storage.read(key: "universityUrl");
    String userName = await storage.read(key: "username");
    String password = await storage.read(key: "password");
    String trainingId = await storage.read(key: "trainingId");
    return getStuffFromUrl(
        universityUrl + "/GetCalendarData",
        '{"needAllDaylong":false,"TotalRowCount":-1,"ExceptionsEnum":0,"Time":true,"Exam":true,"Task":true,"Apointment":true,"RegisterList":true,"Consultation":true,"startDate":"\/Date(' +
            from.millisecondsSinceEpoch.toString() +
            ')\/","endDate":"\/Date(' +
            to.millisecondsSinceEpoch.toString() +
            ')\/","entityLimit":0,"UserLogin":"' +
            userName +
            '","Password":"' +
            password +
            '","NeptunCode":"' +
            userName +
            '","CurrentPage":0,"StudentTrainingID":' +
            trainingId +
            ',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');
  }

/*Future<String> getHomeworkByTeacher(String accessToken,
      String schoolCode, int id) => getStuffFromUrl("https://" + schoolCode +
      ".e-kreta.hu/mapi/api/v1/HaziFeladat/TanarHaziFeladat/" + id.toString(),
      accessToken, schoolCode);*/

  /*void seeMessage(int id, User user) =>
      getStuffFromUrl(user.schoolUrl+"/SetReadedMessage", '{"PersonMessageId":'+id.toString()+',"TotalRowCount":-1,"ExceptionsEnum":0,"UserLogin":"'+user.username+'","Password":"'+user.password+'","NeptunCode":"'+user.username+'","CurrentPage":0,"StudentTrainingID":'+user.trainingId+',"LCID":1038,"ErrorMessage":null,"MobileVersion":"1.5","MobileServiceVersion":0}');
  */

/*Future<http.Response> getBearer(String jsonBody, String schoolCode) {
    try {
      return http.post("https://" + schoolCode + ".e-kreta.hu/idp/api/v1/Token",
          headers: {
            "HOST": schoolCode + ".e-kreta.hu",
            "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
          },
          body: jsonBody);
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "HĂĄlĂłzati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
  }

  void seeMessage(int id, User user) async {
    try {
      String jsonBody =
          "institute_code=" + user.schoolCode +
              "&userName=" + user.username +
              "&password=" + user.password +
              "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

      Map<String, dynamic> bearerMap = json.decode(
          (await RequestHelper().getBearer(jsonBody, user.schoolCode))
              .body);
      String code = bearerMap.values.toList()[0];

      await http.post("https://eugyintezes.e-kreta.hu//integration-kretamobile-api/v1/kommunikacio/uzenetek/olvasott",
          headers: {
        "Authorization": ("Bearer " + code),
          },
          body: "{\"isOlvasott\":true,\"uzenetAzonositoLista\":[$id]}");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "HĂĄlĂłzati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
  }*/

  /*void seeMessage(int id, User user) async {
    try {
      String jsonBody =
          "institute_code=" + user.schoolCode +
              "&userName=" + user.username +
              "&password=" + user.password +
              "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";

      Map<String, dynamic> bearerMap = json.decode(
          (await RequestHelper().getBearer(jsonBody, user.schoolCode))
              .body);
      String code = bearerMap.values.toList()[0];

      await http.post("https://eugyintezes.e-kreta.hu//integration-kretamobile-api/v1/kommunikacio/uzenetek/olvasott",
          headers: {
            "Authorization": ("Bearer " + code),
          },
          body: "{\"isOlvasott\":true,\"uzenetAzonositoLista\":[$id]}");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Hálózati hiba",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
  }*/

  /*Future<String> getStudentString(User user, {bool showErrors=true}) async {
    String instCode = user.schoolUrl;
    String userName = user.username;
    String password = user.password;
    return getTraining(instCode, userName, password);


  }*/
/*
  Future<String> getEventsString(User user) async {
    String instCode = user.schoolCode;
    String userName = user.username;
    String password = user.password;
    String trainingId=user.trainingId;

    String jsonBody = "institute_code=" +
        instCode +
        "&userName=" +
        userName +
        "&password=" +
        password +
        "&grant_type=password&client_id=919e0c1c-76a2-4646-a2fb-7085bbbf3c56";
    Map<String, dynamic> bearerMap;
    try {
      bearerMap =
          json.decode((await getBearer(jsonBody, instCode)).body);
    } catch (e) {
      print(e);
    }

    String code = bearerMap.values.toList()[0];

    String eventsString = await getEvents(code, instCode);

    saveEvents(eventsString, user);

    return eventsString;
  }*/

}
