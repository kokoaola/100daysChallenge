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
    
    let isLong: Bool
    @Binding var isEdit: Bool
    
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack{
            
            VStack(alignment: .leading, spacing: 30){
                
                    Text(isLong ? "現在目指している100日達成後の姿：" : "現在取り組んでいること：" )
                    Text("\(isLong ? longTermGoal : shortTermGoal)")
                        .frame(maxWidth: .infinity)
                        .font(.title3.weight(.bold))

                
                       
                    TextField(text: $editText) {
                        Text("新しい項目を入力")
                    }
                    .foregroundColor(Color(UIColor.label))
                    .background(.ultraThinMaterial)
                   // .textFieldStyle(.roundedBorder)
                    .scrollContentBackground(Visibility.hidden)
                    //.scrollContentBackground(.hidden)
                    
                
                HStack{
                    Button {
                        isEdit = false
                    } label: {
                        Text("キャンセル")
                            .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                    }
                    .tint(.red)
                    Spacer()
                    
                    Button {
                        if isLong{
                            longTermGoal = editText
                        }else{
                            shortTermGoal = editText
                        }
                        dismiss()
                    } label: {
                        Text("変更する")
                            .frame(width: AppSetting.screenWidth / 3.5, height: AppSetting.screenWidth * 0.1)
                    }
                }
                .foregroundColor(.white)
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                
                Text("※一度変更すると元には戻せないので注意してください。")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            .foregroundColor(.black)
            .padding()
            .background(.white)
            .cornerRadius(15)
            .padding()
            
        }
        .frame(maxHeight: .infinity)
        .background(.secondary)
        .foregroundStyle(
            .linearGradient(
                colors: [storedColorTop, storedColorBottom],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        
    }
}

struct EditGoal_Previews: PreviewProvider {
    @State static var isEdit = false
    static var previews: some View {
        EditGoal(isLong: true, isEdit: $isEdit)
    }
}
