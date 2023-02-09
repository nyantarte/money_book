import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';

import 'dart:io';

import 'package:flutter_money_book/transaction.dart';
import "package:universal_html/html.dart" as html;

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class ImportExportFileView extends StatefulWidget {
  ImportExportFileView(this.isImport,{super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  bool isImport;
  @override
  State<ImportExportFileView> createState() => _ImportExportFileViewState();
}
class _ImportExportFileViewState extends State<ImportExportFileView> {

  final _supportTypes = ["Original", "Rakuna Kakeibo"];
  var _curType = null;

  void _onOkClick()async {
    if(widget.isImport) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        var data = kIsWeb? result.files.single.bytes:await File(result.files.single.path!).readAsBytes();

        var supIdx = 0;
        if (_supportTypes[supIdx] == _curType) {
          MoneyBookManager.getManager().loadFromCSV(
              String.fromCharCodes(data!!));
        } else if (_supportTypes[++supIdx] == _curType) {
          var uuid = Uuid();
          /*
        //excelライブラリのバグで数値が正しく読み込めないのでcsv化したものを処理する
        var excel = Excel.decodeBytes(data!!);

        var sheet=excel[excel.getDefaultSheet()!];
        var rowIdx=1;
        while(null!=sheet!.rows[rowIdx]){
          var row=sheet!.row(rowIdx++);

          var dateText=row[0]!.value.toString();
          print(dateText);
          print(row[5]!.value.toString());
          var trans=Transaction(uuid.v1(), DateFormat("y/M/d h:m:s").parse(dateText), row[1]!.value.toString(), row[2]!.toString(),
              int.parse(row[5]!.value.toString()),
              row[4]!.value.toString());
          MoneyBookManager.getManager().add(trans);
        }*/

          var scr = utf8.decode(String
              .fromCharCodes( data!!)
              .runes
              .toList());
          var rows = scr.split("\n");
          var rowIdx = 1;
          var methods = await MoneyBookManager.getManager().getMethods();
          var usages = await MoneyBookManager.getManager().getUsages();
          print(rows.length);

          while (rowIdx < rows.length) {
            var strLine=rows[rowIdx++];
            if(1>=strLine.length) {
              break;
            }
            var line = strLine.split(",");
            if (1 == line.length)
              break;


            var value = int.parse(line[5]);
            var transDate=DateTime.now();
            try {
              transDate=DateFormat("yyyy/MM/dd HH:mm:ss").parse(line[0]);
            }catch(e){
              transDate=DateFormat("yyyy/MM/dd").parse(line[0]);

            }
            var trans = Transaction(
                uuid.v1(),transDate,
                line[1],
                line[2],
                "支出" == line[6] ? -value : value,
                line[4]);
            print("[$rowIdx] $trans");
            MoneyBookManager.getManager().add(trans);
            if (methods.contains(trans.method)) {
              MoneyBookManager.getManager().addMethod(trans.method);
              methods = await MoneyBookManager.getManager().getMethods();
            }
            if (usages.contains(trans.usage)) {
              MoneyBookManager.getManager().addUsage(trans.usage);
              usages = await MoneyBookManager.getManager().getUsages();
            }
          }
        }
      }
      print("Import end");
    }else {
      String csv =await MoneyBookManager.getManager().convToCSV();
      if (kIsWeb) {

        final anchor = html.AnchorElement(
            href: "data:application/json;charset=utf-8," +
                csv);
        anchor.download = "moneybook.csv";
        anchor.click();
      } else {
        String? result = await FilePicker.platform.getDirectoryPath();
        var supIdx = 0;
        if (_supportTypes[supIdx] == _curType) {

            final file = File("$result/moneybook.csv");

            file.writeAsBytes(Utf8Encoder().convert(csv));
            print(result);
        }
        else if (_supportTypes[++supIdx] == _curType) {


        }


      }
    }

    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Import file"),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Method"),
                  DropdownButton<String>(
                      value: _curType,

                      onChanged: (newValue) {
                        setState(() {
                          if (null != newValue) {
                            _curType = newValue;
                          }
                        });
                      },
                      items: _supportTypes.map<DropdownMenuItem<String>>((
                          String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                  )
                ]),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                  child: Text("OK"),
                  onPressed: () async {
                    _onOkClick();
                  },
                ),
                  ElevatedButton(
                    child: Text("CANCEL"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  )
                ])
          ],
        ),
      ),

    );
  }

}