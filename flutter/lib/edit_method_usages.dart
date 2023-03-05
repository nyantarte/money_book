import 'package:flutter/material.dart';
import 'package:flutter_money_book/transaction.dart';
class EditMethodUsages extends StatefulWidget {
  const EditMethodUsages(this.isMethod,{super.key,required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final bool isMethod;
  @override
  State<EditMethodUsages> createState() => _EditMethodUsagesViewState();
}
class _EditMethodUsagesViewState extends State<EditMethodUsages> {
  int selectedItem = -1;
  TextEditingController newItemController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    var screenWidth = mediaQueryData.size.width;
    var screenHeight = mediaQueryData.size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    Future<List<String>> targetList;
    if(widget.isMethod){
      targetList=MoneyBookManager.getManager().getMethods();
    }else{
      targetList=MoneyBookManager.getManager().getUsages();

    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
        FutureBuilder(
        future:targetList,
            builder: (BuildContext context,
        AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  width: screenWidth, height: screenHeight*0.6,
                    child: ListView.builder(shrinkWrap: true,

                    itemCount:
                    snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                          title: Text(snapshot.data![index]),
                          value: index,
                          groupValue: selectedItem,
                          onChanged: (value) {
                            setState(() {
                              if (null != value) {
                                selectedItem = value;
                              } else {
                                selectedItem = -1;
                              }
                            });
                          });
                    }));
              } else {
                return
                  SizedBox(width: screenWidth, height: screenHeight * 0.6,
                      child: ListView());
              }
            }
          ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Spacer(),
                  ElevatedButton(
                    child: Text("Delete"),
                    onPressed: () async{


                      if(-1!=selectedItem) {
                        var list=await targetList;
                        var value=list[selectedItem];
                        if(widget.isMethod) {
                          MoneyBookManager.getManager().deleteMethod(
                              value);
                        }else{
                          MoneyBookManager.getManager().deleteUsage(
                              value);
                        }
                      }
                      setState(() {
                      });
                    },
                  )
                ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("New item"),
                Spacer(),
                Flexible(child: TextField(
                  controller: newItemController,
                )),
                ElevatedButton(
                  child: Text("Add"),
                  onPressed: () async{
                    if(widget.isMethod) {
                      MoneyBookManager.getManager().addMethod(
                          newItemController.text );
                    }else{
                      MoneyBookManager.getManager().addUsage(
                          newItemController.text);
                    }

                    setState(() {

                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Spacer()
              ],
            )
          ],
        ),
      ),

    );
  }
}