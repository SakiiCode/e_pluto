import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:convert' show json;
import 'RequestHelper.dart';

class UniversitiesList extends StatefulWidget {
  @override
  _UniversitiesListState createState() => _UniversitiesListState();
}

class _UniversitiesListState extends State<UniversitiesList> {
  String selectedValue = "";
  List universities = [];

  @override
  void initState() {
    super.initState();
    loadInstitutes();
  }

  void loadInstitutes() async {
    var response = await RequestHelper.getInstitutes();
    var universitiesJson = json.decode(response);
    await RequestHelper.storage.write(key: "universityUrl", value: universitiesJson[0]["Url"]);
    setState(() {
      universities = universitiesJson;
      selectedValue = universities[0]["Url"];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem> items = [];

    for (int i = 0; i < universities.length; i++) {
      items.add(new DropdownMenuItem(
        child: new Text(
          universities[i]["Name"],
        ),
        value: universities[i]["Url"],
      ));
    }

    return new SearchableDropdown(
      isExpanded: true,
      items: items,
      value: selectedValue,
      hint: new Text('Betöltés...'),
      searchHint: new Text(
        'Keresés',
        style: new TextStyle(fontSize: 20),
      ),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        RequestHelper.storage.write(key: "universityUrl", value: value);
      },
    );
  }
}
