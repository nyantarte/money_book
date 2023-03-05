import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'dart:collection';
import 'package:intl/intl.dart';
class SearchView extends StatefulWidget {
  SearchView(this.beginDate,this.endDate,{super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  DateTime beginDate,endDate;
  @override
  State<SearchView> createState() => _SearchViewState();
}
class _SearchViewState extends State<SearchView> {

  _onDateChange(context,bool isBeginDate) async {
    var curDate = DateTime.now();
    if (isBeginDate) {
      curDate = widget.beginDate;
    }else{
      curDate=widget.endDate;
    }
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: curDate,
        firstDate: DateTime(2003),
        lastDate: DateTime(DateTime.now().year +
            1));
    if (null != datePicked) {
      setState(() {
        if(isBeginDate){
          widget.beginDate=datePicked!;
        }else{
          widget.endDate=datePicked!;

        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final date_fmt=DateFormat(S.of(context).date_fmt);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Search"),
      ),

        body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(S.of(context).begin_date),
                  Text("${date_fmt.format(this.widget.beginDate)}"),
                  ElevatedButton(onPressed:() {
                    this._onDateChange(context, true);
                  }, child: Text(S.of(context).change)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(S.of(context).end_date),
                  Text("${date_fmt.format(this.widget.endDate)}"),
                  ElevatedButton(onPressed: () {
                    this._onDateChange(context,false);
                  }, child: Text(S.of(context).change)),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pop([widget.beginDate,widget.endDate]);
                  }, child: Text("OK")),
                  ElevatedButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text("CANCEL")),
                ],
              )
            ],

        )));
  }
}