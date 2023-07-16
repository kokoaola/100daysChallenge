//
//  SwiftUIView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/17.
//

import SwiftUI

struct EditGoal: View {
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green

    @Binding var showAlert: Bool
    
    ///入力したテキストを格納するプロパティ
    @State var editText: String = ""
    
    let isLong: Bool
    
    var body: some View {
        
//        VStack{
            
            VStack(alignment: .leading){
                
                Text(isLong ? "目標を変更する" : "100日取り組む内容を変更する")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title3)
                
                TextEditor(text: $editText)
                    .foregroundColor(Color(UIColor.black))
                    .tint(.black)
                    .scrollContentBackground(Visibility.hidden)
                    .background(.gray.opacity(0.5))
                    .border(.gray, width: 1)
                    .frame(height: 80)
                    .opacity(editText.isEmpty ? 0.5 : 1)
                    .accessibilityLabel("目標変更用のテキストフィールド")
                
                Text("\(AppSetting.maxLengthOfTerm)文字以内のみ設定可能です").font(.caption) .font(.caption)
                    .foregroundColor(editText.count > AppSetting.maxLengthOfTerm ? .red : .clear)
                
                
                HStack{
                    Button {
                        showAlert = false
                    } label: {
                        Text("キャンセル")
                            .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                    }
                    .tint(.red)
                    Spacer()
                    
                    Button {
                        Task{
                            await save()
                        }
                        showAlert = false
                    } label: {
                        Text("変更する")
                            .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                    }.tint(.green)
                        .disabled(editText.isEmpty || editText.count > AppSetting.maxLengthOfTerm)
                }//HStackここまで
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                
            }//VStackここまで
        
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .cornerRadius(15)
            .padding()
        
        .onAppear{
            if isLong{
                editText = longTermGoal
            }else{
                editText = shortTermGoal
            }
        }
    }
    
    ///データ保存用関数
    func save() async{
        if !editText.isEmpty && AppSetting.maxLengthOfTerm >= editText.count{
            
            await MainActor.run{
                if isLong{
                    longTermGoal = editText
                }else{
                    shortTermGoal = editText
                }
            }
        }
    }
}




struct EditGoal_Previews: PreviewProvider {
    @State static var isEdit = false
    @State static var str = "目標を変更する"
    static var previews: some View {
        Group{
            EditGoal(showAlert: $isEdit,isLong: true)
                .environment(\.locale, Locale(identifier:"en"))
            EditGoal(showAlert: $isEdit,isLong: true)
                .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
