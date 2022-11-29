class OpenMenuState extends State{
    init(){
        super.init();
        //ファイルオープン画面を表示する
        var create_btn=document.createElement("input");
        create_btn.type="button";
        create_btn.onclick=this.#on_create_new;
        create_btn.value="新規作成";
        document.body.appendChild(create_btn);
        //ファイル参照ボタンを追加
        var input_file=document.createElement("input");
        input_file.type="button";
        input_file.value="ファイルをロード";
        input_file.onclick=this.#on_open_file;
        
        document.body.appendChild(input_file);
    }
    //新規作成時の処理
    #on_create_new(){
        console.log("on_create_new(Info)>>Create a new money book.");
    
        app.set_mode(new MonthlyListState());
        
    }
   
    //ファイル参照時の処理
    #on_open_file(){
        app.set_mode(new FilePickState());
    }
   


}