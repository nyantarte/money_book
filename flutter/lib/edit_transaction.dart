import 'package:flutter/material.dart';
import 'package:flutter_money_book/transaction.dart';
import 'package:flutter_money_book/edit_method_usages.dart';

class EditTransaction extends StatefulWidget {
  const EditTransaction(this.targetDate,{super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final targetDate;
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

  void _addTransaction() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

    });
  }

  _onTypeChanged(value) {
    setState(() {
      _type = value;
    });
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
          title: Text("Edit transaction"),
        ),

        body: Column(
            children: [Table(
              border: TableBorder.all(color: Colors.white),

              defaultVerticalAlignment: TableCellVerticalAlignment.top,

              children: [


                TableRow(
                    children: [
                      Text("Type"),
                      Flexible(child:

                      RadioListTile(
                          title: Text("Income"),
                          value: _TransactionType.Income,
                          groupValue: _type,
                          onChanged: _onTypeChanged)),
                      Flexible(child: RadioListTile(
                          title: Text("Payment"),
                          value: _TransactionType.Payment,
                          groupValue: _type,
                          onChanged: _onTypeChanged))
                    ]
                ),
                TableRow(
                  children: [
                    Text("Transaction date"),
                    Text(
                        "${this.widget.targetDate.year}/${this.widget.targetDate
                            .month}/${this.widget.targetDate.day}"),
                    ElevatedButton(
                      child: Text("Change"),
                      onPressed: () async {
                        final DateTime? datePicked = await showDatePicker(
                            context: context,
                            initialDate: this.widget.targetDate,
                            firstDate: DateTime(2003),
                            lastDate: DateTime(this.widget.targetDate.year +
                                1));
                      },
                    )
                  ],
                ),
                TableRow(

                  children: [
                    Text("Transaction time"),
                    Text(
                        "${this.widget.targetDate.hour}:${this.widget.targetDate
                            .minute.toString().padLeft(2, "0")}"),
                    ElevatedButton(
                      child: Text("Change"),
                      onPressed: () async {
                        final initialTime = TimeOfDay(
                            hour: this.widget.targetDate.hour,
                            minute: this.widget.targetDate.minute);
                        final newTime = await showTimePicker(
                            context: context, initialTime: initialTime);
                      },
                    )
                  ],
                ),
                TableRow(

                    children: [
                      Text("Method"),
                      DropdownButton<String>(
                        value: _method,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (newValue) {

                        },
                        items: MoneyBookManager.getMethods()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                        child: Text("Edit"),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return EditMethodUsages(title:"",true);
                          }));
                        },
                      )
                    ]
                ),
                TableRow(

                    children: [
                      Text("Usage"),
                      DropdownButton<String>(
                        value: _usage,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                        onChanged: (newValue) {
                          setState(() {});
                        },
                        items: MoneyBookManager.getMethods()
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ElevatedButton(
                        child: Text("Edit"),
                        onPressed: () {},
                      )
                    ]
                ), TableRow(

                    children: [
                      Text("Value"),
                      Flexible(child: TextField()), Spacer()
                    ])
              ],
            ),
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
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("BS"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("/"),
                            onPressed: () {},
                          ),

                        ]
                    ),
                    TableRow(
                        children: [
                          ElevatedButton(
                            child: Text("7"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("8"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("9"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("*"),
                            onPressed: () {},
                          ),

                        ]
                    ),
                    TableRow(
                        children: [
                          ElevatedButton(
                            child: Text("4"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("5"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("6"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("-"),
                            onPressed: () {},
                          )
                        ]),
                    TableRow(
                        children: [
                          ElevatedButton(
                            child: Text("1"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("2"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("3"),
                            onPressed: () {},
                          ),
                          ElevatedButton(
                            child: Text("+"),
                            onPressed: () {},
                          )
                        ]), TableRow(
                      children: [
                        ElevatedButton(
                          child: Text("0"),
                          onPressed: () {},
                        ),
                        ElevatedButton(
                          child: Text("."),
                          onPressed: () {},
                        ),
                        Spacer(),
                        ElevatedButton(
                          child: Text("="),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        ElevatedButton(
                          child: Text("0"),
                          onPressed: () {},
                        ),
                        ElevatedButton(
                          child: Text("."),
                          onPressed: () {},
                        ),
                        Spacer(),
                        ElevatedButton(
                          child: Text("="),
                          onPressed: () {},
                        ),
                      ],
                    ),

                  ]),
              Spacer(),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      child: Text("CANCEL"),
                      onPressed: () {},
                    ),
                    Spacer(),
                    ElevatedButton(
                      child: Text("Delete"),
                      onPressed: () {},
                    )
                  ]),
            ])

    );
  }

}