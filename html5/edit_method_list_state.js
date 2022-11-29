
/**
 * @brief 支払い方法の一覧を編集する状態クラス
 */
class EditMethodListState extends State{

    /**
     * @brief 自身の状態を初期化する
     */
    init(){
        super.init();
        this.#show_method_list();//支払い方法のリストを表示

    }

    /**
     * @brief 支払い方法のリストを表示する
     */
    #show_method_list(){
    
        var item=null;
    
        /**
         * 支払い方法を管理するチェックリストを作成
         */
        var item_list=document.createElement("div");
        item_list.id="methods_list";

    
        /**
         * リスト内に表示する項目を追加
         */
        for(var i=0;i < app.data.methods.length;++i){
            item=document.createElement("input");
            item.type="checkbox";
            item.name="methods";
            item_list.appendChild(item);
            item_list.appendChild(document.createTextNode(app.data.methods[i]));
            item_list.appendChild(document.createElement("br"));
        }
        document.body.appendChild(item_list);

        /**
         * チェックの入った項目を削除するボタンを追加
         */
        item=document.createElement("input");
        item.type="button";
        item.value="DELETE";
        item.onclick=this.#remove_methods;
        document.body.appendChild(item);
        document.body.appendChild(document.createElement("br"));

        /**
         * 新たに追加する支払い方法を入力するためのテキストボックスを追加
         */
        item=document.createElement("input");
        item.type="text";
        item.id="new_method";
        document.body.appendChild(item);
        /**
         * 上記のテキストボックスの入力内容を新たに支払い方法に追加するボタンを追加
         */
        item=document.createElement("input");
        item.type="button";
        item.value="ADD";
        item.onclick=this.#add_method;
        document.body.appendChild(item);
        document.body.appendChild(document.createElement("br"));

        /**
         * 支払い方法のリストの編集を終了するボタンを追加
         */
        item=document.createElement("input");
        item.type="button";
        item.value="OK";
        item.onclick=app.goback_state;
        document.body.appendChild(item);


    }
    /**
     * 
     * @brief テキストボックスに入力された内容を支払い方法に追加する
     */
    #add_method(){
        /**
         * 入力されたテキストボックスを取得
         */
        var item=document.getElementById("new_method");
        console.log(item.value);

        //入力された内容を支払い方法に追加
        app.data.methods.push(item.value);


        /**
         * ページ内の支払い方法のリストを取得
         */
        var item_list=document.getElementById("methods_list");
        var new_item=document.createElement("input");
 
         /**
         * ページ内の支払い方法のリストに追加された内容を項目として追加
         */

        new_item.type="checkbox";
        new_item.name="methods";
        item_list.appendChild(new_item);
        item_list.appendChild(document.createTextNode(item.value));
        item_list.appendChild(document.createElement("br"));
        //追加された項目はデフォルトで非選択に設定
        item.value="";
    }

    /**
     * @brief ページ内の支払い方法のリストにチェックが入った項目を削除する
     */
    #remove_methods(){

        /**
         * 支払い方法のリストを取得
         */
        var list=document.getElementById("methods_list");

        //リスト内の項目のチェック状態を確認する
        var i=0;
        while(i< list.childNodes.length){
            var check=list.childNodes[i];
            if(check.checked){  //チェックが入っていた
                delete app.data.methods[i]; //支払い方法から削除
                var text=list.childNodes[i+1];//ページ内のリストからチェックボックスの直後が項目のテキスト
                var br=list.childNodes[i+2];//テキストの次が改行要素
                check.remove();//チェックボックスを削除
                text.remove(); //テキストを削除
                br.remove();   //改行を削除

                //リスト内の項目が3つ削除されたので、インデックスを進めなくても次の要素を指している
            }else{
                //チェックが入っていないので次の要素を指す
                //++i;//正しくはi=i+3?
                i+=i+3;
            }
        }
        
    }
}
