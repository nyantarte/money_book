class Transaction{
  int id=0;
  DateTime transactionDate=DateTime.now();
  String method="";
  String usage="";
  int value=0;
  String note="";

  Transaction(int _id,DateTime _transactionDate,String _method,String _usage,int _value,String _note){
    id=_id;
    transactionDate=_transactionDate;
    method=_method;
    usage=_usage;
    value=_value;
    note=_note;
  }

}

class MoneyBookManager{
  static var _data=List<Transaction>.empty(growable: true);
  static var _methods=List<String>.empty(growable: true);
  static var _usages=List<String>.empty(growable: true);

  static void loadFromCSV(String csv){
    var data=csv.split("\n");
    for(var l in data){
      var trans=l.split(",");
      var obj=Transaction(int.parse(trans[0]), DateTime.parse(trans[1]), trans[2], trans[3], int.parse(trans[4]), trans[5]);
      if(-1==_methods.indexOf(obj.method)){
        _methods.add(obj.method);
      }
      if(-1==_usages.indexOf(obj.usage)){
        _usages.add(obj.usage);
      }
      _data.add(obj);

    }
    _data.sort((a,b)=>a.transactionDate.compareTo(b.transactionDate));
  }
  static void clear(){
    _data.clear();
  }

  static List<String> getMethods(){
    return _methods;
  }
  static List<String> getUsages(){
    return _usages;
  }

}