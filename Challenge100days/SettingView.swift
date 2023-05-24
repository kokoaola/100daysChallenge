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
    
    @State var isButtonPressed = false
    @State var myName = ""
    
    
    ///長期目標再設定用
    ///アラート表示
    @State var isLongTermGoalEditedAlert = false
    ///編集中の文章の格納
    @State var currentLongTermGoal = ""
    ///現在の目標
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    
    ///アラート表示
    @State var isShortTermGoalEditedAlert = false
    ///編集中の文章の格納
    @State var currentShortTermGoal = ""
    ///現在の目標
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    
    var body: some View {
        NavigationStack{
            
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
                            
                            Button("目標を変更する") {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isLongTermGoalEditedAlert = true
                                }
                                currentLongTermGoal = longTermGoal
                            }
                            
                            Button("100日取り組む内容を変更する") {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    isShortTermGoalEditedAlert = true
                                }
                                currentShortTermGoal = shortTermGoal
                            }
                        }
                        
                        Section{
                            
                            NavigationLink {
                                BackUpView()
                            } label: {
                                Text("バックアップ")
                            }
                            
                            
                            NavigationLink {
                                WebView(urlString: "https://kokoaola.github.io/privacy.html")
                            } label: {
                                Text("プライバシーポリシー")
                            }
                            
                            
                            NavigationLink {
                                AboutThisApp()
                            } label: {
                                Text("このアプリについて")
                            }
                            
                            
                            NavigationLink {
                                ContactWebView()
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
                .navigationTitle("設定")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
                
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .scrollContentBackground(.hidden)
                
                .userSettingGradient(colors: [storedColorTop, storedColorBottom])
//                .background(.secondary)
//                .foregroundStyle(
//                    .linearGradient(
//                        colors: [storedColorTop, storedColorBottom],
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                )
                
                if isLongTermGoalEditedAlert{
                    VStack{
                        EditGoal(showAlert: $isLongTermGoalEditedAlert, isLong: true)
                            .transition(.offset(CGSizeZero))
                    }
                    .background(.black.opacity(0.6))

                }else if isShortTermGoalEditedAlert{
                    VStack{
                        EditGoal(showAlert: $isShortTermGoalEditedAlert, isLong: false)
                    }
                    .background(.black.opacity(0.6))
                }
            }
            
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
            //            print("aa")
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
