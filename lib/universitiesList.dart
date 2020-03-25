import 'package:e_pluto/main.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:e_pluto/globals.dart' as globals;

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
    for(int i=0; i < universities.length; i++){
      items.add(new DropdownMenuItem(
        child: new Text(
          universities[i]["Name"],
        ),
        value: universities[i]["Url"],
      ));
    }
    if(globals.universityUrl == "") {
      selectedValue = universities[0]["Url"];
    }else{
      selectedValue = globals.universityUrl;
    }
    return /*Column(
      children: <Widget>[*/
        /*Flexible(
          child:*/
            new SearchableDropdown(
              isExpanded: true,
              items: items,
                  value: selectedValue,
                  hint: new Text(
                      'Nyomj ide'
                  ),
                  searchHint: new Text(
                    'Keresés',
                    style: new TextStyle(
                        fontSize: 20
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                    setUniversityUrl(value);
                  },
                )
      //  )
   /* ])*/;
  }
}