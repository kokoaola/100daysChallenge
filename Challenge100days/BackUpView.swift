//
//  BackUpView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/17.
//

import SwiftUI
import Combine


// コピーしました用のメッセージバルーン
class MessageBalloon:ObservableObject{
    
    // opacityモディファイアの引数に使用
    @Published  var opacity:Double = 10.0
    // 表示/非表示を切り替える用
    @Published  var isPreview:Bool = false
    
    private var timer = Timer()
    
    // Double型にキャスト＆opacityモディファイア用の数値に割り算
    func castOpacity() -> Double{
        Double(self.opacity / 10)
    }
    
    // opacityを徐々に減らすことでアニメーションを実装
    func vanishMessage(){
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
            self.opacity = self.opacity - 1.0 // デクリメント
            
            if(self.opacity == 0.0){
                self.isPreview = false  // 非表示
                self.opacity = 10.0     // 初期値リセット
                self.timer.invalidate() // タイマーストップ
            }
        }
    }
}



struct BackUpView: View {
    
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    ///編集文章格納用
    @State var string = ""
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    @ObservedObject  var messageAlert = MessageBalloon()
    
    
    var body: some View {
        
        
        VStack{
            
            
            ///短期目標
            VStack(alignment: .leading){
                Text("このアプリにはデータを外部に保存する機能はありません。\nデータを消して最初から新しく始める際など、これまでの記録を残しておきたい場合は、このページからコピーしてデバイスへ保存をお願いいたします。")
                    .foregroundColor(.primary)
                    .padding([.horizontal, .top])
                
                
                ZStack {
                    ///テキストエディター
                    TextEditor(text: $string)
                        .foregroundColor(Color(UIColor.label))
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 1)
                        .focused($isInputActive)
                        .padding()
                    
                    if (messageAlert.isPreview){
                        Text("コピーしました")
                            .font(.system(size: 25))
                            .padding()
                            .background(.gray)
                            .foregroundColor(.white)
                            .opacity(messageAlert.castOpacity())
                            .cornerRadius(5)
                            .offset(x: -5, y: -20)
                    }
                }
            }
            
            .frame(minHeight: AppSetting.screenHeight/1.6)
            
            
            .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                if let textField = obj.object as? UITextField {
                    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                }
            }
            
            
        }
        .navigationTitle(Text("バックアップ"))
        ///グラデーション背景設定
        .background(.ultraThinMaterial)
        .userSettingGradient(colors: [storedColorTop, storedColorBottom])
//        .background(.secondary)
//        .foregroundStyle(
//            .linearGradient(
//                colors: [storedColorTop, storedColorBottom],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//        )
        
        .toolbarBackground(.visible, for: .navigationBar)
        ///キーボード閉じるボタン
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("閉じる") {
                    isInputActive = false
                }
            }
            
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    UIPasteboard.general.string = string
                    messageAlert.isPreview = true
                    messageAlert.vanishMessage()
                    
                }, label: {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.gray)
                        .frame(width: 65)
                })
                .disabled(messageAlert.isPreview)
            }
        }
        
        ///メモデータが格納されていればテキストエディターの初期値に設定
        .onAppear{
            for item in days{
                string = string + "\n" + "Day" + String(item.num) + "  " +  makeDate(day: item.date ?? Date.now) + "\n" + (item.memo ?? "") + "\n"
            }
        }
    }
}




struct BackUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            BackUpView()
                .environment(\.locale, Locale(identifier:"en"))
            BackUpView()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
