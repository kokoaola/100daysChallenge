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
    
    //let isLong: Bool
    @Binding var showAlert: Bool
    
    ///入力したテキストを格納するプロパティ
    // @State private var editText = ""
    
    @State var editText: String = ""
    
    ///画面破棄用
    //@Environment(\.dismiss) var dismiss
    
    //let labelText: String
    let isLong: Bool
    
    var body: some View {
        
        ZStack{
            
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
                
                Text("\(AppSetting.maxLngthOfTerm)文字以内のみ設定可能です").font(.caption) .font(.caption)
                    .foregroundColor(editText.count > AppSetting.maxLngthOfTerm ? .red : .clear)
                
                
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
                        .disabled(editText.isEmpty || editText.count > AppSetting.maxLngthOfTerm)
                    
                    
                    
                }
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                
                //                Text("※一度変更すると元には戻せないので注意してください。")
                //                    .font(.caption)
                //                    .foregroundColor(.red)
            }
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .cornerRadius(15)
            .padding()
            
        }
        .frame(maxHeight: .infinity)
        
        .onAppear{
            if isLong{
                editText = longTermGoal
            }else{
                editText = shortTermGoal 
            }
        }
        
        //        .background(.secondary)
        //        .foregroundStyle(
        //            .linearGradient(
        //                colors: [storedColorTop, storedColorBottom],
        //                startPoint: .topLeading,
        //                endPoint: .bottomTrailing
        //            )
        //        )
        
    }
    
    ///データ保存用関数
    func save() async{
        await MainActor.run{
            if isLong{
                longTermGoal = editText
            }else{
                shortTermGoal = editText
            }
        }
    }
    
    
    //struct EditGoal: View {
    //    @AppStorage("longTermGoal") var longTermGoal: String = ""
    //    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    //
    //    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    //    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    //
    //    let isLong: Bool
    //    @Binding var isEdit: Bool
    //
    //    ///入力したテキストを格納するプロパティ
    //    @State private var editText = ""
    //
    //    ///画面破棄用
    //    @Environment(\.dismiss) var dismiss
    //
    //    let labelText: String
    //
    //    var body: some View {
    //
    //        ZStack{
    //
    //            VStack(alignment: .leading){
    //
    //                    Text(labelText)
    //                    Text("\(isLong ? longTermGoal : shortTermGoal)")
    //                        .frame(maxWidth: .infinity)
    //                        .font(.title3.weight(.bold))
    //
    //                TextEditor(text: $editText)
    //                    .foregroundColor(Color(UIColor.label))
    //                    .scrollContentBackground(Visibility.hidden)
    //                    .background(.ultraThinMaterial)
    //                    .border(.gray, width: 1)
    //                    .frame(height: 80)
    //                    .opacity(editText.isEmpty ? 0.5 : 1)
    //
    ////                    TextField(text: $editText) {
    ////                        Text("新しい項目を入力")
    ////                    }
    ////                    .foregroundColor(Color(UIColor.label))
    ////                    .background(.ultraThinMaterial)
    ////                   // .textFieldStyle(.roundedBorder)
    ////                    .scrollContentBackground(Visibility.hidden)
    //                    //.scrollContentBackground(.hidden)
    //                Text("a").font(.caption)
    //
    //                HStack{
    //                    Button {
    //                        isEdit = false
    //                    } label: {
    //                        Text("キャンセル")
    //                            .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
    //                    }
    //                    .tint(.red)
    //                    Spacer()
    //
    //                    Button {
    //                        if isLong{
    //                            longTermGoal = editText
    //                        }else{
    //                            shortTermGoal = editText
    //                        }
    //                        dismiss()
    //                    } label: {
    //                        Text("変更する")
    //                            .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
    //                    }.tint(.green)
    //                }
    //                .foregroundColor(.white)
    //                .buttonStyle(.borderedProminent)
    //                .padding(.bottom)
    //
    ////                Text("※一度変更すると元には戻せないので注意してください。")
    ////                    .font(.caption)
    ////                    .foregroundColor(.red)
    //            }
    //            .foregroundColor(.black)
    //            .padding()
    //            .background(.white)
    //            .cornerRadius(15)
    //            .padding()
    //
    //        }
    //        .frame(maxHeight: .infinity)
    //        .background(.secondary)
    //        .foregroundStyle(
    //            .linearGradient(
    //                colors: [storedColorTop, storedColorBottom],
    //                startPoint: .topLeading,
    //                endPoint: .bottomTrailing
    //            )
    //        )
    //
    //    }
    //}
}

struct EditGoal_Previews: PreviewProvider {
    @State static var isEdit = false
    @State static var str = "目標を変更する"
    static var previews: some View {
        EditGoal(showAlert: $isEdit,isLong: true)
    }
}
