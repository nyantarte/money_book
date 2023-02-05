class MonthlyListState extends State{
    #trans_list=[];
    init(){
        super.init();

        this.create_main_menu();
        this.#show_monthly_list();
    }
    #show_monthly_list(){
        var add_btn=document.createElement("input");
        add_btn.type="button";
        add_btn.value="+";
        add_btn.onclick=this.#on_add_transaction;
        document.body.appendChild(add_btn);
        document.body.appendChild(document.createElement("br"));

        console.log("show_monthly_list(Info)>>Generateing item list begin");
        this.#trans_list=new Array();
        for(var i=0;i < app.data.transactions.length;++i){
            var item=app.data.transactions[i];
            if(app.current_date.getFullYear()==item.target_date.getFullYear() &&
                app.current_date.getMonth()==item.target_date.getMonth()){
                this.#trans_list.push(item);
            }
        }
        var list=document.createElement("ul");
        list.id="transaction_list"; 
        for(var i=0;i < this.#trans_list.length;++i){
           
            var check=document.createElement("input");
            check.type="checkbox";
            check.value="false";
            list.appendChild(check);
            var item=this.#trans_list[i];
            list.appendChild(document.createTextNode(item.toString()));
            list.appendChild(document.createElement("br"));

        }
        document.body.appendChild(list);
        console.log("show_monthly_list(Info)>>Generateing item list end");
        this.create_command_menu();
    }
    #on_add_transaction(){
        app.set_mode(new EditTransactionState());
    
    }
    edit_transaction(){
        app.selected_transactions=[];
        var list=document.body.getElementsById("list")[0];
        for(var i=0;i < list.childNodes.length;i+=3){
            var check=list[i];
            if(check.value){
                app.selected_transactions.push(this.#trans_list[i/3]);
            }
        }

    }
}