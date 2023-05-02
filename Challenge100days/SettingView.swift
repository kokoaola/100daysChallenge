//
//  SettingView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/15.
//

import SwiftUI

struct SettingView: View {
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    @AppStorage("isFirst") var isFirst = true
    @AppStorage("colorNumber") var colorNumber = 0
    @AppStorage("showInfomation") var showInfomation = true
    @State var selectedColor = 10
    @State var isRiset = false
    @State var isEdit = false
    @State var isLong = false
    
    var body: some View {
        
        ZStack{
            
            VStack(spacing: 50) {
                List{
                    Section(){
                        Picker(selection: $selectedColor) {
                            Text("青").tag(0)
                            Text("オレンジ").tag(1)
                            Text("紫").tag(2)
                            Text("モノトーン").tag(3)
                        } label: {
                            Text("アプリの色を変更する")
                        }
                            Toggle("目標を表示", isOn: $showInfomation)
                            .tint(.green)
                                //.frame(width: AppSetting.screenWidth * 0.4)
                    }
                    
                    Section{
                        
                        
                        NavigationLink {
                            EditGoal(isLong: true, isEdit: $isEdit)
                        } label: {
                            Text("１００日後のビジョンを変更する")
                        }
                        
                        
                        
                        NavigationLink {
                            EditGoal(isLong: false, isEdit: $isEdit)
                        } label: {
                            Text("日々取り組む内容を変更する")
                        }
                        
                        
                    }
                    
                    Section{
                        NavigationLink {
                            AboutThisApp()
                        } label: {
                            Text("このアプリについて")
                        }
                        
                        NavigationLink {
                            AboutThisApp()
                        } label: {
                            Text("プライバシーポリシー")
                        }
                        
                        NavigationLink {
                           BackUpView()
                        } label: {
                            Text("バックアップ")
                        }
                        
                        NavigationLink {
                            AboutThisApp()
                        } label: {
                            Text("お問い合わせ")
                        }
                    }
                    
                    Section{
                        HStack{
                            Spacer()
                            Text("リセット")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isRiset = true
                        }
                    }
                    
                }
                .disabled(isEdit)
                .foregroundColor(Color(UIColor.label))
                
            }
            
            
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .scrollContentBackground(.hidden)
            .background(.secondary)
            
            .foregroundStyle(
                .linearGradient(
                    colors: [storedColorTop, storedColorBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            
            
            
        }
        
        .onChange(of: selectedColor) { newValue in
            switch newValue{
            case 0:
                storedColorTop = .blue
                storedColorBottom = .green
                
            case 1:
                storedColorTop = .green
                storedColorBottom = .yellow
            case 2:
                storedColorTop = .purple
                storedColorBottom = .blue
            case 3:
                storedColorTop = .black
                storedColorBottom = .black
                
            default:
                storedColorTop = .blue
                storedColorBottom = .green
            }
            colorNumber = selectedColor
        }
        
        .onAppear{
            selectedColor = colorNumber
            print("aa")
        }
        
        ///削除ボタン押下時のアラート
        .alert("リセットしますか？", isPresented: $isRiset){
            Button("破棄する",role: .destructive){
                isFirst = true
                delete()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("この動作は取り消せません。")
        }
        
    }
    
    ///削除用の関数
    func delete(){
        for item in days{
            moc.delete(item)
            try? moc.save()
        }
        UserDefaults.standard.set(1, forKey: "todayIs")
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
