
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_money_book/daily_view_state.dart';
import 'package:flutter_money_book/config.dart';
import 'package:flutter_money_book/edit_transaction.dart';
import 'package:flutter_money_book/transaction.dart';
import 'package:intl/intl.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_money_book/search_view.dart';
import 'package:indexed_list_view/indexed_list_view.dart';
import 'package:flutter_money_book/import_file_view.dart';
class MontlyListView extends StatefulWidget {
  const MontlyListView({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MontlyListView> createState() => _MonthlyListViewState();
}

class _MonthlyListViewState extends State<MontlyListView> {
  DateTime beginDateRange = DateTime.now();
  DateTime endDateRange = DateTime.now();
  HashMap<int, bool> selectStateTbl = HashMap();
  Future<List<Transaction>>? data;
  var _isFiltered=false;

  Transaction? _editResult=null;


  _MonthlyListViewState() {
    var nowDate = DateTime.now();
    _setViewMonth(nowDate);
  }

  void _addTransaction() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditTransaction(title: "", DateTime.now(), null);
    })).then((value) => _editResult=value);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _setViewMonth(beginDateRange);
    });
  }

  void _editTransaction(Transaction t) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return EditTransaction(title: "", null, t);
    })).then((value) => _editResult=value);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _setViewMonth(beginDateRange);
    });
  }


  void _onViewPrevMonth() {
    setState(() {
      _setViewMonth(beginDateRange.subtract(Duration(days: 1)));
    });
  }

  void _onViewNextMonth() {
    setState(() {
      _setViewMonth(endDateRange);
    });
  }

  void _onSearch() async{
    if (_isFiltered) {
      setState(() {
        _setViewMonth(DateTime.now());
      });
    } else {
      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SearchView(this.beginDateRange, this.endDateRange.subtract(Duration(days:1)), title: "");
      })).then((value){
        setState(() {
          if (null != value) {
            this.beginDateRange = value[0] as DateTime;
            this.endDateRange = (value[1] as DateTime).add(Duration(days: 1));
          }
        });
      });
    }
  }
  void _onExport() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ImportExportFileView(false, title: "");
    }));
  }
  void _setViewMonth(DateTime targetMonth) {
    beginDateRange = DateTime(targetMonth.year, targetMonth.month, 1);
    if (12 == targetMonth.month) {
      endDateRange = DateTime(beginDateRange.year + 1, 1, 1);
    } else {
      endDateRange = DateTime(beginDateRange.year, beginDateRange.month + 1, 1);
    }
    //endDateRange = endDateRange.add(const Duration(days: -1));

    data = MoneyBookManager.getManager().getData(
        beginDateRange, endDateRange);
    selectStateTbl.clear();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var screenWidth = mediaQueryData.size.width;
    var screenHeight = mediaQueryData.size.height;

    final num_fmt=NumberFormat.currency(symbol: S.of(context).currency_symbol);
    final time_fmt=DateFormat(S.of(context).time_fmt);
    final date_fmt=DateFormat(S.of(context).date_fmt);
    var dateRangeText = "From ${date_fmt.format(beginDateRange)}\nTo ${date_fmt.format(endDateRange.subtract(Duration(days: 1)))}";
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
        title: Text("Monthly list"),
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
              ListTile(title: Text(S.of(context).list)),//'List')),

              ListTile(title: Text(S.of(context).config),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return Config(title: "");
                        }));
                  }),

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    child: Text("<"),

                    onPressed:_isFiltered?null: () {
                      _onViewPrevMonth();
                    }),
                Text(dateRangeText,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(
                  child: Text(">"),
                  onPressed:_isFiltered?null: () {
                    _onViewNextMonth();
                  },
                )
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
              children:[
            FutureBuilder(
                future: data,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Transaction>> snapshot) {
                  if (snapshot.hasData) {
                    if (selectStateTbl.isNotEmpty) {
                      var total = 0;
                      for (var idx in selectStateTbl.keys) {
                        total += snapshot.data![idx].value;
                      }

                      return Text("${num_fmt.format(total)}");
                    }
                  }
                  return Text("");
                }),
            IconButton(
              onPressed:this._onSearch,


              icon: Icon(Icons.search),
              color: Colors.blue,
            ),
            IconButton(
              onPressed:this._onExport,


              icon: Icon(Icons.download),
              color: Colors.blue,
            )]),
          FutureBuilder(
                future: data,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Transaction>> snapshot) {
                  if (snapshot.hasData) {


                    var ioTbl=HashMap();
                    for(var t in snapshot.data!){
                      var tDate=DateTime(t.transactionDate.year,t.transactionDate.month,t.transactionDate.day);
                      if(!ioTbl.containsKey(tDate)){
                        ioTbl[tDate]=[0,0];
                      }
                      if(0 <= t.value){
                        ioTbl[tDate][0]+=t.value;
                      }else{
                        ioTbl[tDate][1]+=t.value.abs();

                      }
                    }

                    var wList = List<Widget>.empty(growable: true);
                    var prevDate = beginDateRange.subtract(const Duration(days: 1));
                    var editResultIdx=-1;

                    for (var index = 0; index <
                        snapshot.data!.length; ++index) {
                      var t = snapshot.data![index];
                      if (prevDate.year != t.transactionDate.year ||
                          prevDate.month != t.transactionDate.month ||
                          prevDate.day != t.transactionDate.day) {
                        prevDate = DateTime(
                            t.transactionDate.year, t.transactionDate.month,
                            t.transactionDate.day);
                        wList.add(
                            ListTile(
                                tileColor: Colors.grey,
                                title: Text("${date_fmt.format(
                                    prevDate)} ?????? ${num_fmt.format(
                                    ioTbl[prevDate][0])} ?????? ${num_fmt.format(
                                    ioTbl[prevDate][1])} ",
                                    style: TextStyle(color: Colors.white))));
                      }
                      wList.add(
                          ListTile(
                              title: Text(
                                  "${time_fmt.format(t.transactionDate)} ${t
                                      .method} ${t.note} ${num_fmt.format(t
                                      .value)}", style: TextStyle(color: Colors
                                  .black)),
                              selected: selectStateTbl.containsKey(index),
                              selectedTileColor: Colors.blue,

                              onTap: () {
                                if (selectStateTbl.containsKey(index)) {
                                  //selectStateTbl.remove(index);

                                } else {
                                  _editTransaction(snapshot.data![index]);
                                }
                              },
                              onLongPress: () {
                                setState(() {
                                  if (selectStateTbl.containsKey(index)) {
                                    selectStateTbl.remove(index);
                                  } else {
                                    selectStateTbl[index] = true;
                                  }
                                });
                              }));
                      if (null != _editResult) {
                        if (t.uuid == _editResult!.uuid) {
                          editResultIdx = wList.length - 1;
                          //_editResult=null;
                          print(editResultIdx);
                        }
                      }
                    }
                    
                    return SizedBox(
                        width:screenWidth,
                        height:screenHeight*0.6, child:
                          IndexedListView.builder(controller: IndexedScrollController(initialIndex: -1!=editResultIdx?editResultIdx:0),
                              minItemCount:0,
                              maxItemCount: wList.length-1,
                              itemBuilder: (context, index) {

                      return wList[index];
                    }));
                  } else {
                    return ListView(shrinkWrap: true);
                  }
                })




          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTransaction,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
