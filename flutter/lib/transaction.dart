

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
class Transaction{
  String uuid;
  DateTime transactionDate=DateTime.now();
  String method="";
  String usage="";
  int value=0;
  String note="";
  static final formatter = NumberFormat.currency(locale: "ja",symbol: "￥");
  Transaction(this.uuid,this.transactionDate,this.method,this.usage,this.value,this.note);

  @override
  String toString(){
    return "${transactionDate.year}/${transactionDate.month}/${transactionDate.day} ${transactionDate.hour}:${transactionDate.minute.toString().padLeft(2, "0")} $method $usage ${formatter.format(value.abs())}";
  }


  String convToCSV(){
    return "$uuid,${transactionDate.toIso8601String()},$method,$usage,$value,$note";
  }

  Map<String,dynamic> toMap(){
   return {
     "uuid":uuid,
     "transactionDate":transactionDate.millisecondsSinceEpoch,
     "method":method,
     "usage":usage,
     "value":value,
     "note":note
   };
  }
}

abstract class MoneyBookManager {

  static MoneyBookManager? _self=null;



  void loadFromCSV(String csv) async{
    var data = csv.split("\n");
    var methods=await getMethods();
    var usages=await getUsages();
    for (var l in data) {
      var trans = l.split(",");
      var obj = Transaction(
          trans[0], DateTime.parse(trans[1]), trans[2], trans[3],
          int.parse(trans[4]), trans[5]);
      if (-1 == methods.indexOf(obj.method)) {
        addMethod(obj.method);
      }
      if (-1 == usages.indexOf(obj.usage)) {
        addUsage(obj.usage);
      }
      add(obj);
    }
    //_data.sort((a, b) => a.transactionDate.compareTo(b.transactionDate));
  }

  void add(Transaction t);
  void addMethod(String m);
  void deleteMethod(String m);
  void addUsage(String u);
  void deleteUsage(String u);
  void delete(Transaction t);
  void clear();
  Future<List<Transaction>> getData(DateTime b,DateTime e) ;
  Future<List<String>> getMethods();

  Future<List<String>> getUsages();

  Future<List<Transaction>> _getData();

  Future<String> convToCSV() async{
    var result="";
    for(var t in await _getData()){
      result+=t.convToCSV()+"\n";
    }

    return result;
  }



  static MoneyBookManager getManager(){
    if(null==_self){

      if(kIsWeb){
        _self=LocalMoneyBookManager();

      }else {
        if (Platform.isAndroid || Platform.isIOS) {
          _self=SqliteMoneyBookManager();
        }else{
          _self=LocalMoneyBookManager();
        }
      }
    }
    return _self!!;
  }


}

class LocalMoneyBookManager extends MoneyBookManager{
  var _data = List<Transaction>.empty(growable: true);
  var _methods = List<String>.empty(growable: true);
  var _usages = List<String>.empty(growable: true);




  LocalMoneyBookManager(){
    if(kIsWeb){
      final storage=LocalStorage("moneybook");
      var csv=storage.getItem("data");
      if(null!=csv) {
        loadFromCSV(csv);
      }
    }
  }


  @override
  void clear() {
    _data.clear();
  }

  @override
  Future<void> add(Transaction t) async {
    var idx=_data.indexWhere((element) => t.uuid==element.uuid);
    if(-1==idx) {
      _data.add(t);
    }
    save2Local();
  }
  @override
  void addMethod(String m){
    _methods.add(m);
  }
  @override
  void deleteMethod(String m){
    _methods.remove(m);
  }

  @override
  void addUsage(String u){
    _usages.add(u);
  }
  @override
  void deleteUsage(String u){
    _usages.remove(u);
  }
  @override
  void delete(Transaction t){
    var idx=_data.indexWhere((element) => t.uuid==element.uuid);
    if(-1!=idx) {
      _data.removeAt(idx);
      save2Local();
    }
  }
  @override
  Future<List<String>> getMethods(){
    return Future.value(_methods);
  }

  @override
  Future<List<String>> getUsages(){
    return Future.value(_usages);
  }

  @override
  Future<List<Transaction>> _getData(){
    return Future.value(_data);
  }
  @override
  Future<List<Transaction>> getData(DateTime b,DateTime e) async{
    var r=List<Transaction>.empty(growable: true);

    _data.sort((a, b) => a.transactionDate.compareTo(b.transactionDate));

    for(var t in _data){

      if(0<=t.transactionDate.compareTo(e)){
        break;
      }else if(0<=t.transactionDate.compareTo(b) && 0>=t.transactionDate.compareTo(e)){
        r.add(t);
      }

    }
    return r;
  }


  void save2Local()async {
    if(kIsWeb){
      var csv=await convToCSV();
      final storage=LocalStorage("moneybook");
      storage.setItem("data",csv);

    }
  }




}

class SqliteMoneyBookManager extends MoneyBookManager {

  Future<Database>? _sqliteDB;

  SqliteMoneyBookManager() {
    _sqliteDB = _openDatabase();
  }

  Future<Database> _openDatabase() async {
    var dataBase = openDatabase(
      // getDatabasesPath() データベースファイルを保存するパス取得
      join(await getDatabasesPath(), 'moneybook.db'),
      onCreate: (db, version) {
        var r = db.execute(
          // テーブルの作成
          "CREATE TABLE moneybook(uuid  TEXT PRIMARY KEY, transactionDate  INTEGER,method  TEXT,usage  TEXT,value  INTEGER,note  TEXT)",
        );

        r = db.execute("CREATE TABLE methods(key  TEXT)");
        r = db.execute("CREATE TABLE usages(key  TEXT)");
        return r;
      },
      version: 5,
    );
    return dataBase;
  }




  @override
  void clear() async{

      await _sqliteDB!!.delete("moneybook");



  }

  @override
  void add(Transaction t) async {
    await _sqliteDB!!.insert(
        "moneybook", t.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  void addMethod(String m) async {
    await _sqliteDB!!.insert(
        "methods", {"key": m}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  void deleteMethod(String m) async{
    await _sqliteDB!!.delete("methods",where:"key=?",whereArgs:[m]);
  }

  @override
  void addUsage(String u) async {
    await _sqliteDB!!.insert(
        "usages", {"key": u}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  void deleteUsage(String m) async{
    await _sqliteDB!!.delete("usages",where:"key=?",whereArgs:[m]);
  }

  @override
  void delete(Transaction t)async {
    await _sqliteDB!!.delete("moneybook",where:"uuid=?",whereArgs:[t.uuid]);
  }
  @override
  Future<List<String>> getMethods() async {
    var result = List<String>.empty(growable: true);
    var data = await _sqliteDB!!.query("methods");

    for (var row in await data) {
      result.add(row["key"].toString());
    }
    return result;
  }

  @override
  Future<List<String>> getUsages() async {
    var result = List<String>.empty(growable: true);
    var data = await _sqliteDB!!.query("usages");

    for (var row in await data) {
      result.add(row["key"].toString());
    }
    return result;
  }

  @override
  Future<List<Transaction>> _getData() async {
    var result = List<Transaction>.empty(growable: true);
    var data = await _sqliteDB!!.query("moneybook");

    for (var row in await data) {
      var t = Transaction(row["uuid"].toString(),
          DateTime.fromMillisecondsSinceEpoch( int.parse(row["transactionDate"].toString())),
          row["method"].toString(), row["usage"].toString(),
          int.parse(row["value"].toString()),
          row["note"].toString());
      result.add(t);
    }
    return result;
  }

  @override
  Future<List<Transaction>> getData(DateTime b, DateTime e) async {
    var r = List<Transaction>.empty(growable: true);
    var data = await _sqliteDB!!.query(
        "moneybook", where: "transactionDate>=? AND transactionDate<?",
        whereArgs: [b.millisecondsSinceEpoch, e.millisecondsSinceEpoch]);


    for (var row in await data) {
      var t = Transaction(row["uuid"].toString(),
          DateTime.fromMillisecondsSinceEpoch(
              int.parse(row["transactionDate"].toString())),
          row["method"].toString(), row["usage"].toString(),
          int.parse(row["value"].toString()),
          row["note"].toString());
      r.add(t);
    }

    return r;
  }


}
