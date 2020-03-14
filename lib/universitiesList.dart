
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class UniversitiesList extends StatefulWidget{

  @override
  _UniversitiesListState createState() => _UniversitiesListState();

}

class _UniversitiesListState extends State<UniversitiesList> {

  List<DropdownMenuItem> items = [];
  String selectedValue;


  @override
  Widget build(BuildContext context) {
    items.clear();
    for(int i=0; i < 20; i++){
      items.add(new DropdownMenuItem(
        child: new Text(
          'test ' + i.toString(),
        ),
        value: 'test ' + i.toString(),
      ));
    }

    return new SearchableDropdown(
      items: items,
      value: selectedValue,
      hint: new Text(
          'Select One'
      ),
      searchHint: new Text(
        'Select One',
        style: new TextStyle(
            fontSize: 20
        ),
      ),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }
}