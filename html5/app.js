//import {Transaction,Moneybook} from "./money_book";
//import State from "./state.js";
/**
 * @brif アプリケーションを管理するクラス
 */
class App{
    state_stack=[new OpenMenuState()];/*!遷移状態を管理するスタック*/
    current_date=new Date();          /*!表示対象となる取引記録を指定するための日付*/
    data=new MoneyBook();             /*!家計簿データ*/
    selected_transactions=[];
    static SAVE_LOAD_POS_TBL=["Local storage"]; /*!データの保存先一覧 */
    static FMT_NAME_TBL=["独自形式","楽な家計簿"];/*!取り扱えるデータのフォーマット*/

    /**
     * @brief 新しく状態を設定する
     *        現在の状態はスタック上に保存されており,set_prev_modeでひとつ前の状態へ戻ることができる
     * @param {*} next_mode:設定する状態 
     */
    set_mode(next_mode){
        //スタックの頂上に新しく設定する状態を保存
        this.state_stack.push(next_mode);
        //新しく設定した状態を初期化
        next_mode.init();
    }

    /**
     * @brief アプリケーションを直前の状態に遷移させる
     */
    set_prev_mode(){
        this.state_stack.pop();
    }
    /**
     * 
     * @returns 現在のアプリケーションの状態を返す
     */
    get_state(){
        return this.state_stack[this.state_stack.length-1];
    }

    /**
     * @brief アプリケーションを直前の状態に遷移させ、状態を初期化する
     */
    goback_state(){
        app.set_prev_mode();//直前の状態に戻す
        app.get_state().init();//戻した状態を初期化する
    }


    conv_current_date_string_for_input(){
        //年を取得し、inputが受け入れる形式へ変換
        return this.get_date_string_for_input(this.current_date);
    }
    conv_current_time_string_for_input(){
        //年を取得し、inputが受け入れる形式へ変換
        return this.get_time_string_for_input(this.current_date);
    }
    /**
     * 
     * @returns 参照日時からHTMLのinput要素が解釈できる日付の値を返す
     */
    get_date_string_for_input(target_date){
        var tmp=target_date.getFullYear();  
        if(9>target_date.getMonth()){       //月が一の位のみだったら月の先頭に"-0"を追加
            tmp=tmp+"-0"+(target_date.getMonth()+1);
        }else{
            tmp=tmp+"-"+(target_date.getMonth()+1);//それ以外は月の先頭に"-"を追加
        }

        if(9>target_date.getDay()){//日が一の位のみだったら日の先頭に"-0"を追加
            tmp=tmp+"-0"+(target_date.getDay()+1);
        }else{
            tmp=tmp+"-"+(target_date.getDay()+1);//それ以外は日の先頭に"-"を追加
        }
        return tmp;
    }
    /**
     * 
     * @returns 参照日時からHTMLのinput要素が解釈できる時刻の値を返す
     */
    get_time_string_for_input(target_date){
        var tmp="";
        if(10>target_date.getHours()){//時間が一の位のみだったら月の先頭に"0"を追加
            tmp="0"+(target_date.getHours());
        }else{
            tmp=(target_date.getHours());
        }

        if(10>target_date.getMinutes()){//分が一の位のみだったら月の先頭に":0"を追加
            tmp=tmp+":0"+(target_date.getMinutes());
        }else{
            tmp=tmp+":"+(target_date.getMinutes());//分が2桁だったら月の先頭に":"を追加
        }
        return tmp;
    }

}
var app=new App();

//export default App;