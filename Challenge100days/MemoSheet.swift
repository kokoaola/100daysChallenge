//
//  MemoSheet.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/02.
//

import SwiftUI

struct MemoSheet: View {
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    ///CoreData用の変数
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(sortDescriptors: []) var days: FetchedResults<DailyData>
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    ///編集文章格納用
    @State var editText = ""
    
//    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
//    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing: 20){
                    
                    ZStack{
                        
                        ///左上のシート破棄用Xボタン
                        Button {
                            dismiss()
                        } label: {
                           CloseButton()
//                                .font(.title2).foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ///画面タイトル
                        Text("メモの追加").font(.title3)
                            .padding()
                            .foregroundColor(Color(UIColor.label))
                        
                    }//ZStackここまで
                    
                    ///テキストエディター
                    TextEditor(text: $editText)
                        .foregroundColor(Color(UIColor.label))
                        .lineSpacing(10)
                        .scrollContentBackground(Visibility.hidden)
                        .background(.ultraThinMaterial)
                        .border(.white, width: 3)
                        .frame(height: 300)
                        .focused($isInputActive)
                    
                    
                    Label("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です", systemImage: "exclamationmark.circle")
                        .font(.footnote)
                        .padding(5)
                        .foregroundColor(editText.count > AppSetting.maxLengthOfMemo ? .red : .clear)
                    
                    
                    ///保存ボタン
                    Button {
//                        days.last?.memo = editText
//                        try? moc.save()
                        coreDataViewModel.updateDataMemo(newMemo: editText, data: nil)
                        dismiss()
                    } label: {
                        SaveButton()
                            .foregroundColor(editText.count <= AppSetting.maxLengthOfMemo && editText.count > 0 ? .green : .gray)
                            .opacity(editText.count <= AppSetting.maxLengthOfMemo ? 1.0 : 0.5)
                    }
                    .accessibilityLabel("メモを保存する")
                    .tint(.green)
                    .disabled(editText.count > AppSetting.maxLengthOfMemo || editText.count <= 0)
                    
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
            ///グラデーション背景設定
            .background(.ultraThinMaterial)
            //背景色の設定
            .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
            
            
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
                editText = coreDataViewModel.allData.last?.memo ?? ""
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
        .environmentObject(CoreDataViewModel())
        .environmentObject(UserSettingViewModel())
    }
}
