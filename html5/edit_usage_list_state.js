class EditUsagesListState extends State{
    init(){
        super.init();
        this.#show_usages_list();

    }
    #show_usages_list(){
    
        var item=null;
    
        var item_list=document.createElement("div");
        item_list.id="usages_list";

    
        for(var i=0;i < app.data.usages.length;++i){
            item=document.createElement("input");
            item.type="checkbox";
            item.name="usages";
            item_list.appendChild(item);
            item_list.appendChild(document.createTextNode(app.data.methods[i]));
            item_list.appendChild(document.createElement("br"));
        }
        document.body.appendChild(item_list);

        item=document.createElement("input");
        item.type="button";
        item.value="DELETE";
        item.onclick=this.#remove_usages;
        document.body.appendChild(item);
        document.body.appendChild(document.createElement("br"));

        item=document.createElement("input");
        item.type="text";
        item.id="new_usage";
        document.body.appendChild(item);
        item=document.createElement("input");
        item.type="button";
        item.value="ADD";
        item.onclick=this.#add_usage;
        document.body.appendChild(item);
        document.body.appendChild(document.createElement("br"));

        item=document.createElement("input");
        item.type="button";
        item.value="OK";
        item.onclick=app.goback_state;
        document.body.appendChild(item);


    }
    #add_usage(){
        var item=document.getElementById("new_usage");
        console.log(item.value);
        app.data.usages.push(item.value);
        var item_list=document.getElementById("usages_list");
        var new_item=document.createElement("input");
        new_item.type="checkbox";
        new_item.name="usages";
        item_list.appendChild(new_item);
        item_list.appendChild(document.createTextNode(item.value));
        item_list.appendChild(document.createElement("br"));
        item.value="";
    }
    #remove_usages(){
        var list=document.getElementById("usages_list");
        var i=0;
        while(i< list.childNodes.length){
            var check=list.childNodes[i];
            if(check.checked){
                delete app.data.usages[i];
                var text=list.childNodes[i+1];
                var br=list.childNodes[i+2];
                check.remove();
                text.remove();
                br.remove();
            }else{
                ++i;
            }
        }
        
    }
}