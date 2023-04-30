//
//  MemoSheet.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/02.
//

import SwiftUI

struct MemoSheet: View {
    
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var days: FetchedResults<DailyData>
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss

    ///編集文章格納用
    @State var string = ""
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing: 30){
                    
                    ZStack{
                        
                        ///左上のシート破棄用Xボタン
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2).foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ///画面タイトル
                        Text("メモの追加").font(.title3)
                            .foregroundColor(Color(UIColor.label))
                        
                    }//ZStackここまで
                    

                    ///テキストエディター
                    TextEditor(text: $string)
                        .foregroundColor(Color(UIColor.label))
                        .lineSpacing(10)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 3)
                        .frame(height: 300)
                        .focused($isInputActive)
                    
                    
                    ///保存ボタン
                    Button {
                        days.last?.memo = string
                        try? moc.save()
                        dismiss()
                    } label: {
                        OriginalButton(labelString: "保存する", labelImage: "checkmark.circle")
                            .foregroundColor(.green)
                    }

                    
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
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
            .foregroundColor(Color(UIColor.label))
            
            ///メモデータが格納されていればテキストエディターの初期値に設定
            .onAppear{
                string = days.last?.memo ?? ""
            }
        }

    }
}

struct MemoSheet_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        MemoSheet()
            //.environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
