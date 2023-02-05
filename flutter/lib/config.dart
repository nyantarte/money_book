import 'package:flutter/material.dart';


import 'package:flutter_money_book/edit_method_usages.dart';
import 'package:flutter_money_book/import_file_view.dart';
import 'dart:io';

import 'package:flutter_money_book/transaction.dart';
import "package:universal_html/html.dart" as html;
import 'package:flutter_money_book/monthly_list_view.dart';
class Config extends StatefulWidget {
  const Config({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Config> createState() => _ConfigViewState();
}
class _ConfigViewState extends State<Config> {

  void _onLoadClicked() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return ImportExportFileView(true, title: "");
        }));
  }

  void _onExport2FileClicked() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return ImportExportFileView(false, title: "");
        }));

  }

  void _onMonthlyClicked() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return MontlyListView(title: "");
        }));
  }

  void _onEditMethodsClicked() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return EditMethodUsages(true, title: "");
        }));
  }

  void _onEditUsagesClicked() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return EditMethodUsages(false, title: "");
        }));
  }

  void _onClearTransactionsCLicked() {
    MoneyBookManager.getManager().clear();
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
          title: Text("Config"),
        ),
        drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(child:
                Text("Moneybook",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    )
                ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    )),
                ListTile(title: Text('Monthly'),

                    onTap: _onMonthlyClicked),
                ListTile(title: Text('Daily')),

              ],
            )
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
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _onLoadClicked();
                            },

                            iconSize: 40,
                            icon: Icon(Icons.upload_file),
                            color: Colors.amber,
                          ),
                          Text("Import from file"),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              _onExport2FileClicked();
                            }
                            ,
                            iconSize: 40,
                            icon: Icon(Icons.download_sharp),
                            color: Colors.amber,
                          ),
                          Text("Export to file"),

                        ],
                      )
                    ]
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                        children: [
                          IconButton(
                            onPressed: _onEditMethodsClicked,
                            iconSize: 40,
                            icon: Icon(Icons.card_giftcard),
                            color: Colors.amber,
                          ),
                          Text("Edit methods"),
                        ]),
                    Spacer(),
                    Column(
                        children: [
                          IconButton(
                            onPressed: _onEditUsagesClicked,
                            iconSize: 40,
                            icon: Icon(Icons.shopping_bag),
                            color: Colors.amber,
                          ),
                          Text("Edit usages"),

                        ])
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                          children: [
                            IconButton(
                              onPressed: _onClearTransactionsCLicked,
                              iconSize: 40,
                              icon: Icon(Icons.delete),
                              color: Colors.amber,
                            ),
                            Text("Clear transactions"),
                          ]),
                    ]
                )
              ]),

        ));
  }

}