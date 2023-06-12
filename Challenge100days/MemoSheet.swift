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
    @State var editText = ""
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing: 20){
                    
                    ZStack{
                        
                        ///左上のシート破棄用Xボタン
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2).foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        ///画面タイトル
                        Text("メモの追加").font(.title3)
                            .foregroundColor(Color(UIColor.label))
                        
                    }//ZStackここまで
                    .padding()
                    
                    ///テキストエディター
                    TextEditor(text: $editText)
                        .foregroundColor(Color(UIColor.label))
                        .lineSpacing(10)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 3)
                        .frame(height: 300)
                        .focused($isInputActive)
                    
                    
                    Label("\(AppSetting.maxLngthOfMemo)文字以内のみ設定可能です", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(editText.count > AppSetting.maxLngthOfMemo ? .red : .clear)
                    
                    
                    ///保存ボタン
                    Button {
                        days.last?.memo = editText
                        try? moc.save()
                        dismiss()
                    } label: {
                        OriginalButton(labelString: "保存する", labelImage: "checkmark.circle")
                            .foregroundColor(editText.count <= AppSetting.maxLngthOfMemo ? .green : .gray)
                            .opacity(editText.count <= AppSetting.maxLngthOfMemo ? 1.0 : 0.5)
                    }
                    //.buttonStyle(.borderedProminent)
                    .tint(.green)
                    .disabled(editText.count > AppSetting.maxLngthOfMemo)
                    
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
            ///グラデーション背景設定
            .background(.ultraThinMaterial)
            .userSettingGradient(colors: [storedColorTop, storedColorBottom])
//            .background(.secondary)
//            .foregroundStyle(
//                .linearGradient(
//                    colors: [storedColorTop, storedColorBottom],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
            
            
            ///キーボード閉じるボタン
            ///キーボード閉じるボタンを配置
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("閉じる") {
                        isInputActive = false
                    }
                }
            }
            .foregroundColor(Color(UIColor.label))
            
            
            ///メモデータが格納されていればテキストエディターの初期値に設定
            .onAppear{
                editText = days.last?.memo ?? ""
            }
        }
        
    }
}


struct MemoSheet_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MemoSheet()
                .environment(\.locale, Locale(identifier:"en"))
            MemoSheet()
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
