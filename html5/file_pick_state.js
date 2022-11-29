//import State from "./state";

class FilePickState extends State{

    
    init(){
        super.init();
        //ファイルオープン画面を表示する
        document.body.appendChild(document.createTextNode("場所"));
        var item=document.createElement("select");
        item.id="target_position";
    
        for(var i=0;i < App.SAVE_LOAD_POS_TBL.length;++i){
            var tmp=document.createElement("option");
            tmp.appendChild(document.createTextNode(App.SAVE_LOAD_POS_TBL[i]));
            item.appendChild(tmp);
        }
        document.body.appendChild(item);
        document.body.appendChild(document.createElement("br"));

        document.body.appendChild(document.createTextNode("フォーマット"));
        item=document.createElement("select");
        item.id="target_fmt";
        for(var i=0;i < App.FMT_NAME_TBL.length;++i){
            var tmp=document.createElement("option");
            tmp.appendChild(document.createTextNode(App.FMT_NAME_TBL[i]));
            item.appendChild(tmp);
        }
        
        document.body.appendChild(item);
        document.body.appendChild(document.createElement("br"));
        //ファイル参照ボタンを追加
        var input_file=document.createElement("input");
        input_file.type="file";
        input_file.id="filePicker";
        input_file.addEventListener("change",this.#file_selected);
        
        document.body.appendChild(input_file);
    }
    //新規作成時の処理
    #on_create_new(){
        console.log("on_create_new(Info)>>Create a new money book.");
    
        app.set_mode(new MonthlyListState());
        
    }
    
    #file_selected(){
    var files=document.getElementById("filePicker").files;
    for(var i=0; i< files.length;++i){
        var item=files[i];
        console.log("file_load(Info)>>Target file name is "+item.name); 
        
        //フォーマットチェック

        //CSV形式以外はエラー
        console.log("file_load(Info)>>File type is "+item.name.substr(item.name.length-4));
        if(4 >=item.name.length || ".csv"!=item.name.substr(item.name.length-4)){
            alert(item.name+"はCSV形式ではありません。");
        }else{

            console.log("file_load(Info)>>File type check is passed.");
            var reader=new FileReader();
            var recv=this;
            reader.onload=(evt)=>{
                console.log("on_file_load(Info)>>Begin file parsing");
                //var lines=evt.target.result.split("\n");
                //console.log(lines);

                app.data=new MoneyBook();

                app.data.loadFromCSVString(reader.result);
                app.set_mode(new MonthlyListState());
            };
            reader.addEventListener("error",(evt)=>{this.#errorHandler(evt);});
            reader.readAsText(item);
        }
    
    }
   
}
#errorHandler(evt){
    console.log(evt.toString());
}

}