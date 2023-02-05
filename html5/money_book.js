class Transaction{
    id=0;
    target_date=null;
    method="";
    usage="";
    value=0;
    note="";


    
    toString(){
        return this.target_date.toString()+" "+this.method+" "+this.usage+" "+this.value.toString();
    }
    toCSVString(){
        return this.id.toString()+","+
            this.target_date.toString()+","+
            this.method+","+
            this.usage+","+
            this.value.toString()+","+
            this.note;
    }
    static parseFromCSVData(src){
        var params=src.split(",");
        var result=new Transaction();
        result.id=params[0];
        result.target_date=new Date(params[1]);
        result.method=params[2];
        result.usage=params[3];
        result.value=params[4];
        result.note=params[5];
        return result;
    }
}
class MoneyBook{
    transactions=new Array();
    methods=new Array();
    usages=new Array();
    

    toCSVString(){
        var result="";
        for(var i=0;i < this.transactions.length;++i){
            var tmp=this.transactions[i];
            result+=tmp.toCSVString()+"\n";
        }
        return result;
    }
    loadFromCSVString(csvStr){
        console.log(csvStr);
        var lines=csvStr.split("\n");
        for(var i=0;i < lines.length;++i){
            var trans=Transaction.parseFromCSVData(lines[i]);
            this.transactions.push(trans);
        }
    }
}
//export default {Transaction, MoneyBook};
