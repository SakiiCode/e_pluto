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

}
