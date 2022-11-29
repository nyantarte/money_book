class EditTransactionState extends State{
    init(){
        super.init();
        this.#edit_transaction();
    }
    #edit_transaction(){
    var item=document.createTextNode("Date");
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="date";
    item.id="target_date";
    item.value=app.get_date_string_for_input();

    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="time";
    item.id="target_time";
    item.value=app.get_time_string_for_input();
    document.body.appendChild(item);

    document.body.appendChild(document.createElement("br"));
    item=document.createTextNode("Type");
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="radio";
    item.name="transaction_type";
    item.id="target_income";
   item.value="true";
    document.body.appendChild(item);
    document.body.appendChild(document.createTextNode("Income"));
    item=document.createElement("input");
    item.type="radio";
    item.name="transaction_type";
    item.id="target_payment";
    item.value="false";
    document.body.appendChild(item);
    document.body.appendChild(document.createTextNode("Payment"));
    document.body.appendChild(document.createElement("br"));


    document.body.appendChild(document.createTextNode("Method"));
    item=document.createElement("select");
    item.id="target_method";
    for(var i=0;i < app.data.methods.length;++i){
        var tmp=document.createElement("option");
        tmp.appendChild(document.createTextNode(app.data.methods[i]));
        item.appendChild(tmp);
    }
    
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=this.edit_method;
    item.value="Add";
    document.body.appendChild(item);

    document.body.appendChild(document.createElement("br"));
    document.body.appendChild(document.createTextNode("Usage"));
    item=document.createElement("select");
    item.id="target_usage";

    for(var i=0;i < app.data.usages.length;++i){
        var tmp=document.createElement("option");
        tmp.appendChild(document.createTextNode(app.data.usages[i]));
        item.appendChild(tmp);
    }
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=this.edit_usages;
    item.value="Add";
    document.body.appendChild(item);

    document.body.appendChild(document.createElement("br"));

    document.body.appendChild(document.createTextNode("note"));
    item=document.createElement("input");
    item.type="text";
    item.id="target_note";
    document.body.appendChild(item);
    document.body.appendChild(document.createElement("br"));

    document.body.appendChild(document.createTextNode("value"));
    item=document.createElement("input");
    item.type="text";
    item.id="target_value";
    item.value="0";
    document.body.appendChild(item);
    document.body.appendChild(document.createElement("br"));

    item=document.createElement("input");
    item.type="button";
    item.onclick=this.#clear_value;
    item.value="AC";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=this.#bs_value;
    item.value="BS";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value("%");};
    item.value="%";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value("/");};
    item.value="/";
    document.body.appendChild(item);
    document.body.appendChild(document.createElement("br"));

    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(7);};
    item.value="7";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(8);};
    item.value="8";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(9);};
    item.value="9";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value("*");};
    item.value="*";
    document.body.appendChild(item);
    document.body.appendChild(document.createElement("br"));

    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(4);};
    item.value="4";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(5);};
    item.value="5";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(6);}
    item.value="6";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value("-");};
    item.value="-";
    document.body.appendChild(item);
    document.body.appendChild(document.createElement("br"));

    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(1);};
    item.value="1";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(2);};
    item.value="2";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(3);}
    item.value="3";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value("+");};
    item.value="+";
    document.body.appendChild(item);
    document.body.appendChild(document.createElement("br"));

    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(0);};
    item.value="0";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#add_value(".");};
    item.value=".";
    document.body.appendChild(item);
    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#calc_value();};
    item.value="=";
    document.body.appendChild(item);
    document.body.appendChild(document.createElement("br"));

    item=document.createElement("input");
    item.type="button";
    item.onclick=()=>{this.#regist_transaction();}
    item.value="OK";
    document.body.appendChild(item);
    
        item=document.createElement("input");
        item.type="button";
        item.onclick=app.goback_state;
        item.value="CANCEL";
        document.body.appendChild(item);
    }
    #clear_value(){
        var item=document.getElementById("target_value");
        item.value="0";

    }
    #add_value(v){
        var item=document.getElementById("target_value");
        if("0"==item.value){
            if("%"==v || "*"==v || "/"==v || "-"==v || "+"==v){
                item.value=item.value+v;
            }else{
                item.value=v;
            }
        }else{
            item.value=item.value+v;
        }
    }
    #bs_value(){
        var item=document.getElementById("target_value");
        item.value=item.substr(0,item.value.length-1);
        if(0==item.value.length){
            item.value="0";
        }
    }
    #calc_value(){
        var item=document.getElementById("target_value");
        var v1=0;
        var v2=0;
        var tmp="";
        var op="";
        for(var i=0;i < item.value.length;++i){
            var c=item.value[i];
            if("%"==c || "*"==c || "/"==c || "-"==c || "+"==c){
                if(0==op.length){
                    v1=Number.parseFloat(tmp);
                }else{
                    v2=Number.parseFloat(tmp);
                    if("%"==op){
                        v1=v1%v2;
                    }else if("*"==op){
                        v1=v1*v2;
                    }else if("/"==op){
                        v1=v1/v2;
                    }else if("-"==op){
                        v1=v1-v2;
                    }else if("+"==op){
                        v1=v1+v2;
                    }
                }
                
                
                tmp="";
                op=c;

            }else{
                tmp=tmp+c;
            }

        }
        if(0<tmp.length){
            v2=Number.parseFloat(tmp);
                    if("%"==op){
                        v1=v1%v2;
                    }else if("*"==op){
                        v1=v1*v2;
                    }else if("/"==op){
                        v1=v1/v2;
                    }else if("-"==op){
                        v1=v1-v2;
                    }else if("+"==op){
                        v1=v1+v2;
                    }

        }
        item.value=v1;

    }
    #regist_transaction(){
        var item =document.getElementById("target_date");
        var target_date=item.value;
        console.log("target_date="+target_date);
        item=document.getElementById("target_time");
        var target_time=item.value;
        console.log("target_time="+target_time);
        item=document.getElementById("target_method");
        var target_method=item.value;
        console.log("target_method="+target_method);
        item=document.getElementById("target_usage");
        var target_usage=item.value;
        console.log("target_usage="+target_usage);
        item=document.getElementById("target_note");
        var target_note=item.value;
        item=document.getElementById("target_payment");
        var isPay=item.value;
        console.log("Type payment is "+isPay);
        
        this.#calc_value();
        item=document.getElementById("target_value");
        var target_value=isPay?-item.value:item.value;
        console.log("target_value="+target_value);
        var result=new Transaction();
        result.id=(new Date()).getTime();
        result.target_date=new Date(target_date+" "+target_time);
        console.log(result.target_date);
        result.method=target_method;
        result.usage=target_usage;
        result.note=target_note;
        result.value=target_value;
        app.data.transactions.push(result);
        app.goback_state();


    }
}