//
//  BackUpView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/17.
//

import SwiftUI
import Combine

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
    
    var body: some View {
            ScrollView{

                        ///画面タイトル
                    Text("バックアップ").font(.title3)
                            .foregroundColor(Color(UIColor.label))
                    
                    ///テキストエディター
                    TextEditor(text: $string)
                        .foregroundColor(Color(UIColor.label))
                        //.lineSpacing(1)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 1)
                        //.frame(maxHeight: Setting.screenHeight)
                        .focused($isInputActive)
                        //.fixedSize(horizontal: false, vertical: true)
                        //.frame(maxHeight: Setting.screenHeight)
               
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                        if let textField = obj.object as? UITextField {
                            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                        }
                    }
                
                
            }
            //.padding()
            //.frame(maxHeight: .infinity, alignment: .top)
            //.fixedSize(horizontal: false, vertical: true)
            ///グラデーション背景設定
            .background(.ultraThinMaterial)
            .background(.secondary)
            .foregroundStyle(
                .linearGradient(
                    colors: [storedColorTop, storedColorBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            
            ///キーボード閉じるボタン
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
            
            ///メモデータが格納されていればテキストエディターの初期値に設定
            .onAppear{print(days.count)
                for item in days{
                    string = string + "\n" + "Day" + String(item.num) + "  " +  makeDate(day: item.date ?? Date.now) + "\n" + (item.memo ?? "") + "\n"
//                    if item.memo != ""{
//                        string = string + "\n" + "Day" + String(item.num) + "  " +  makeDate(day: item.date ?? Date.now) + "\n" + (item.memo ?? "") + "\n"
//                    }else{
//                        string = string + "\n" + "Day" + String(item.num) + "  " +  makeDate(day: item.date ?? Date.now) + "\n" }
                    //item.date

                }
                //string = "afoajfioer"
            }
    
        
    }
}

struct BackUpView_Previews: PreviewProvider {
    static var previews: some View {
        BackUpView()
    }
}
