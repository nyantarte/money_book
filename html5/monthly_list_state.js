class MonthlyListState extends State{
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
        console.log("show_monthly_list(Info)>>Generateing item list begin");
        var trans_list=new Array();
        for(var i=0;i < app.data.transactions.length;++i){
            var item=app.data.transactions[i];
            if(app.current_date.getFullYear()==item.target_date.getFullYear() &&
                app.current_date.getMonth()==item.target_date.getMonth()){
                trans_list.push(item);
            }
        }
        for(var i=0;i < trans_list.length;++i){
            var item=trans_list[i];
            document.body.appendChild(document.createTextNode(item.toString()));
            var btn=document.createElement("input");
            btn.type="button";
            btn.value="edit";
            document.body.appendChild(btn);

        }
        console.log("show_monthly_list(Info)>>Generateing item list end");
    }
    #on_add_transaction(){
        app.set_mode(new EditTransactionState());
    
    }
    
}