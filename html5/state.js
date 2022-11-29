class State{

    init(){
        this.remove_nodes();
    }

    remove_nodes(){
        //現在の画面を削除
        while(0 < document.body.childNodes.length){
            document.body.childNodes[0].remove();
        }

    }
    create_main_menu(){
        var menu_tbl=document.createElement("menu");
        menu_tbl.type="toolbar";
        var item=document.createElement("input");
        item.type="button";
        item.onclick=this.#on_monthly_click;
        item.value="Monthly";
        menu_tbl.appendChild(item);
        item=document.createElement("input");
        item.type="button";
        item.value="Daily";
        menu_tbl.appendChild(item);
        document.body.appendChild(menu_tbl);
        menu_tbl.appendChild(item);
        item=document.createElement("input");
        item.type="button";
        item.value="Save";
        item.onclick=this.#on_save_click;
        menu_tbl.appendChild(item);
    

    }
    edit_method(){
        app.set_mode(new EditMethodListState());
        
    }
    edit_usages(){
        app.set_mode(new EditUsagesListState());
       

    }
    #on_monthly_click(){
        app.set_mode(MODE_MONTHLY_LIST);
        init();
    }
    async #on_save_click(){
       //---ファイルダイアログを使ってファイルを指定して保存する例
        if ("showSaveFilePicker" in window) {
            const options = {
                suggestedName : "moneybook.csv", //デフォルトのファイル名
                types :
                    [ //ファイルの種類のフィルター
                        {
                            //ファイルの説明
                            description : "Transaction data",  
                            //MIME typeと対象の拡張子
                            accept : {"application/csv": [".csv"]} 
                        }
                    ]
            };
            try {
                //---ファイルダイアログを表示し、ファイルを指定する。FileSystemFileHandleが返される
                const fileHandle = await window.showSaveFilePicker(options);
                //---書き込みを扱う FileSystemWritableFileStream を返す
                const writer = await fileHandle.createWritable();
                //---JSONなどテキストをそのまま全部書き込む
                
                await writer.write(app.data.toCSVString());

                

                await writer.close();
            }catch(e) {
                //---ファイルが選択されなかった・ファイル名が入力されなかったなど
                alert("ファイルが入力・指定されませんでした！");
            }
        }

    }
}
//export default State;