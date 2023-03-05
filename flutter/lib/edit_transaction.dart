

import 'package:flutter/material.dart';
import 'package:flutter_money_book/transaction.dart';
import 'package:flutter_money_book/edit_method_usages.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
class EditTransaction extends StatefulWidget {
  EditTransaction(this.targetDate,this.targetData,{super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  DateTime? targetDate=null;
   Transaction? targetData=null;
  @override
  State<EditTransaction> createState() => _EditTransactionState();
}
enum _TransactionType{
  Income,
  Payment
}
class _EditTransactionState extends State<EditTransaction> {
  var _type = _TransactionType.Income;
  var _method = "";
  var _usage = "";
  var _valueController = TextEditingController(text: "0");
  var _noteController = TextEditingController();
  DateTime? _targetDate=null;
  DateTime? _targetTime=null;
  Future<List<String>> methodList = Future(() => List.empty());
  Future<List<String>> usageList = Future(() => List.empty());


  _EditTransactionState(){
    methodList = MoneyBookManager.getManager().getMethods();
    usageList = MoneyBookManager.getManager().getUsages();
  }
  _onTypeChanged(value) {

    setState(() {
      _type = value;
      if(_type==_TransactionType.Income && null!=widget.targetData){
        widget.targetData!.value=widget.targetData!.value.abs();
      }else if(_type==_TransactionType.Payment &&null!=widget.targetData){
        widget.targetData!.value=-widget.targetData!.value.abs();

      }
    });
  }

  _showEditMethodUsagesView(bool isMethod) async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) {
          return EditMethodUsages(title: "", isMethod);
        }));

    if (isMethod) {
      methodList = MoneyBookManager.getManager().getMethods();
    } else {
      usageList = MoneyBookManager.getManager().getUsages();
    }


    setState(() {});
  }

  _onValueAdded(String valueAdded) {
    if ("0" != _valueController.text) {
      _valueController.text = _valueController.text + valueAdded;
    } else {
      _valueController.text = valueAdded;
    }
  }

  _onDateChange(context) async {
    var curDate = DateTime.now();
    if (null != this.widget.targetDate) {
      curDate = widget.targetDate!!;
    }
    final DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: curDate,
        firstDate: DateTime(2003),
        lastDate: DateTime(curDate.year +
            1));
    if (null != datePicked) {
      setState(() {
        _targetDate = datePicked;

      });
    }
  }

  _onTimeChange(context) async {
    var curDate = DateTime.now();
    if (null != widget.targetDate) {
      curDate = widget.targetDate!!;
    }
    final initialTime = TimeOfDay(
        hour: curDate.hour,
        minute: curDate.minute);
    final TimeOfDay? newTime = await showTimePicker(
        context: context, initialTime: initialTime);
    if (null != newTime) {
      setState(() {
        _targetTime = DateTime(
            curDate.year, curDate.month, curDate.day, newTime.hour,
            newTime.minute);
      }
      );
    }
  }

  void _calc() {
    var item = _valueController.text;
    var v1 = 0.0;
    var v2 = 0.0;
    var tmp = "";
    var op = "";
    for (var i = 0; i < item.length; ++i) {
      var c = item[i];
      if ("%" == c || "*" == c || "/" == c || "-" == c || "+" == c) {
        if (0 == op.length) {
          v1 = double.parse(tmp);
        } else {
          v2 = double.parse(tmp);
          if ("%" == op) {
            v1 = v1 % v2;
          } else if ("*" == op) {
            v1 = v1 * v2;
          } else if ("/" == op) {
            v1 = v1 / v2;
          } else if ("-" == op) {
            v1 = v1 - v2;
          } else if ("+" == op) {
            v1 = v1 + v2;
          }
        }


        tmp = "";
        op = c;
      } else {
        tmp = tmp + c;
      }
    }
    if (tmp.isNotEmpty) {
      v2 = double.parse(tmp);
      if ("%" == op) {
        v1 = v1 % v2;
      } else if ("*" == op) {
        v1 = v1 * v2;
      } else if ("/" == op) {
        v1 = v1 / v2;
      } else if ("-" == op) {
        v1 = v1 - v2;
      } else if ("+" == op) {
        v1 = v1 + v2;
      } else {
        v1 = v2;
      }
    }
    _valueController.text = v1.toString();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather



    if(null!=_targetDate){}
    else if (null != widget.targetData) {

      var data = widget.targetData!!;
      _type =
      (0 < data.value) ? _TransactionType.Income : _TransactionType.Payment;
      _method = data.method;
      _usage = data.usage;
      _valueController =
          TextEditingController(text: data.value.abs().toString());
      _noteController = TextEditingController(text: data.note);
      _targetDate = data.transactionDate;
      _targetTime=data.transactionDate;
    }else if (null != widget.targetDate) {
      _targetDate = widget.targetDate!!;
      _targetTime=widget.targetDate!!;
    }

    final date_fmt=DateFormat(S.of(context).date_fmt);
    final time_fmt=DateFormat(S.of(context).time_fmt);

    return Scaffold(

        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Edit transaction"),
        ),

        body:
        SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                  children: [
                    Text("Type"),
                    Flexible(child: RadioListTile(
                        title: Text("In"),
                        value: _TransactionType.Income,
                        groupValue: _type,
                        onChanged: _onTypeChanged)),
                    Flexible(child: RadioListTile(
                        title: Text("Pay"),
                        value: _TransactionType.Payment,
                        groupValue: _type,
                        onChanged: _onTypeChanged))
                  ]
              ),
              Table(
                  children: [
                    TableRow(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date"),

                        Text(
                            "${date_fmt.format(_targetDate!!)}"),
                        ElevatedButton(
                          child: Text(S.of(context).change),
                          onPressed: () {
                            _onDateChange(context);
                          },
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Text("Time"),
                        Text(
                            "${time_fmt.format(_targetTime!!)}"),
                        ElevatedButton(
                          child: Text(S.of(context).change),
                          onPressed: () {
                            _onTimeChange(context);
                          },
                        )
                      ],
                    ),
                    TableRow(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Method"),
                          FutureBuilder(future: methodList,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<String>> snapshot) {
                                if (snapshot.hasData) {
                                  if (!snapshot.data!.isEmpty && !snapshot.data!
                                      .contains(_method)) {
                                    _method = snapshot.data!.first;
                                  }
                                  return DropdownButton<String>(
                                      value: _method,

                                      onChanged: (newValue) {
                                        setState(() {
                                          if (null != newValue) {
                                            _method = newValue;
                                          }
                                        });
                                      },
                                      items:
                                      snapshot.data!.map<
                                          DropdownMenuItem<String>>((
                                          String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                  );
                                } else {
                                  return DropdownButton<String>(
                                      value: null,
                                      onChanged: (value) {},
                                      items: []);
                                }
                              }),
                          ElevatedButton(
                            child: Text("Edit"),
                            onPressed: () async {
                              _showEditMethodUsagesView(true);
                            },
                          )
                        ]
                    ),
                    TableRow(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Usage"),
                          FutureBuilder(future: usageList,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<String>> snapshot) {
                                if (snapshot.hasData) {
                                  if (!snapshot.data!.isEmpty && !snapshot.data!
                                      .contains(_usage)) {
                                    _usage = snapshot.data!.first;
                                  }

                                  return DropdownButton<String>(
                                    value: _usage,

                                    onChanged: (newValue) {
                                      setState(() {
                                        if (null != newValue) {
                                          _usage = newValue;
                                        }
                                      });
                                    },
                                    items:
                                    snapshot.data!.map<DropdownMenuItem<
                                        String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return DropdownButton<String>(
                                      value: null,
                                      onChanged: (value) {},
                                      items: []);
                                }
                              }
                          ),
                          ElevatedButton(
                            child: Text("Edit"),
                            onPressed: () {
                              _showEditMethodUsagesView(false);
                            },
                          )
                        ]
                    ),
                  ]),
              Row(

                  children: [
                    Text("Value"),
                    Spacer(),
                    Text(S.of(context).currency_symbol),
                    Flexible(child: TextField(controller: _valueController
                    )),
                    Spacer()
                  ]),
              Row(

                  children: [
                    Text("Note"),
                    Spacer(),
                    Flexible(child: TextField(controller: _noteController,)),
                    Spacer()
                  ]),
              Table(
                  children: [
                    TableRow(
                        children: [
                          ElevatedButton(
                            child: Text("%"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("AC"),
                            onPressed: () {
                              _valueController.text = "0";
                            },
                          ),
                          ElevatedButton(
                            child: Text("BS"),
                            onPressed: () {
                              var text = _valueController.text;
                              if (0 < text.length) {
                                _valueController.text =
                                    text.substring(0, text.length - 1);
                              } else {
                                _valueController.text = "0";
                              }
                            },
                          ),
                          ElevatedButton(
                            child: Text("/"),
                            onPressed: () {
                              _onValueAdded("/");
                            },
                          ),

                        ]
                    ),
                    TableRow(
                        children: [
                          ElevatedButton(
                            child: Text("7"),
                            onPressed: () {
                              _onValueAdded("7");
                            },
                          ),
                          ElevatedButton(
                            child: Text("8"),
                            onPressed: () {
                              _onValueAdded("8");
                            },
                          ),
                          ElevatedButton(
                            child: Text("9"),
                            onPressed: () {
                              _onValueAdded("9");
                            },
                          ),
                          ElevatedButton(
                            child: Text("*"),
                            onPressed: () {
                              _onValueAdded("*");
                            },
                          ),

                        ]
                    ),
                    TableRow(
                        children: [
                          ElevatedButton(
                            child: Text("4"),
                            onPressed: () {
                              _onValueAdded("4");
                            },
                          ),
                          ElevatedButton(
                            child: Text("5"),
                            onPressed: () {
                              _onValueAdded("5");
                            },
                          ),
                          ElevatedButton(
                            child: Text("6"),
                            onPressed: () {
                              _onValueAdded("6");
                            },
                          ),
                          ElevatedButton(
                            child: Text("-"),
                            onPressed: () {
                              _onValueAdded("-");
                            },
                          )
                        ]),
                    TableRow(
                        children: [
                          ElevatedButton(
                            child: Text("1"),
                            onPressed: () {
                              _onValueAdded("1");
                            },
                          ),
                          ElevatedButton(
                            child: Text("2"),
                            onPressed: () {
                              _onValueAdded("2");
                            },
                          ),
                          ElevatedButton(
                            child: Text("3"),
                            onPressed: () {
                              _onValueAdded("3");
                            },
                          ),
                          ElevatedButton(
                            child: Text("+"),
                            onPressed: () {
                              _onValueAdded("+");
                            },
                          )
                        ]),
                    TableRow(
                      children: [
                        ElevatedButton(
                          child: Text("0"),
                          onPressed: () {
                            _onValueAdded("0");
                          },
                        ),
                        ElevatedButton(
                          child: Text("."),
                          onPressed: () {
                            _onValueAdded(".");
                          },
                        ),
                        Text(""),
                        ElevatedButton(
                          child: Text("="),
                          onPressed: () {
                            _calc();
                          },
                        ),
                      ],
                    ), //*/

                  ]),

              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {

                        _calc();

                        var dateTarget=DateTime(_targetDate!.year,_targetDate!.month,_targetDate!.day,_targetTime!.hour,_targetTime!.minute);
                        var value=double.parse(_valueController.text).toInt();
                        value=_TransactionType.Payment== _type?-value:value;
                        if (null == widget.targetData) {



                          //assert(0 != int.parse(_valueController.text));
                          var data = Transaction(Uuid().v1(),
                              dateTarget, _method, _usage,
                              value,
                              _noteController.text);
                          widget.targetData = data;
                        }else{
                          var data=widget.targetData!!;

                          data.transactionDate=dateTarget;
                          data.method=_method;
                          data.usage=_usage;
                          data.value=value;
                          data.note=_noteController.text;

                          widget.targetData = data;
                        }


                        MoneyBookManager.getManager().add(widget.targetData!!);
                        //MoneyBookManager.getManager().save2Local();
                        Navigator.of(context).pop(widget.targetData!!);
                      },
                    ),
                    ElevatedButton(
                      child: Text("CANCEL"),
                      onPressed: () {

                        Navigator.of(context).pop();
                      },
                    ),
                    Spacer(),
                    ElevatedButton(
                      child: Text("Delete"),

                      onPressed:null!=widget.targetData? () {
                        if(null!=widget.targetData){
                          MoneyBookManager.getManager().delete(widget.targetData!);
                          Navigator.of(context).pop();
                        }

                      }:null,
                    )
                  ]),
            ]))

    );
  }

}