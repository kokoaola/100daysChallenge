//
//  ActionView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ActionView: View {
    ///CoreDataに保存したデータ呼び出し用
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    ///今日のワークが達成されているかの確認用フラグ
    @State var isComplete = false
    
    ///コンプリートウインドウ出現フラグ
    @State var showCompleteWindew = false
    
    @State var showInfomation = false
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    var startDate: String{
        makeDate(day:days.first?.date ?? Date.now)
    }
    
    var dayNumber: Int{
        days.count + 1
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                
                ///今日のミッションが未達成ならボタンのビューを表示
                VStack(spacing: 20){
                    
                    
                    VStack(){
                        ///リスト非表示用のヘッダー
                        HStack{
                            Text("目標を表示")
                            Image(systemName: "chevron.right.circle")
                                .imageScale(.large)
                                .fontWeight(.thin)
                                .rotationEffect(.degrees(showInfomation ? 90 : 0))
                                .animation(.spring(), value: showInfomation)
                            
                        }
                        .frame(width: AppSetting.screenWidth * 0.8, alignment: .leading)
                        
                        .padding(.top)
                        .onTapGesture {
                            withAnimation{
                                showInfomation.toggle()
                            }
                        }
                        
                        ///リストで表示がONになっていてばリストビューを表示
                        
                        VStack(alignment: .leading, spacing: 0){
                            
                            if showInfomation{
                                VStack(alignment: .leading, spacing: 0){
//                                    Text("開始した日  :  \( makeDate(day:days.first?.date ?? Date.now))〜").font(.caption)
                                        //.font(.body)
                                        //.frame(width: AppSetting.screenWidth * 0.7 ,height: 20,alignment: .center)
                                    
                                    Text("目指している姿  :  ").font(.caption)
                                    Text("あああああああ\(longTermGoal)")
                                        //.font(.body)
                                        .frame(width: AppSetting.screenWidth * 0.7 ,height: 50,alignment: .center)
                                        //.font(.body)
                                    Text("100日取り組むこと : ").font(.caption)
                                    Text("あああああああ\(shortTermGoal)")
                                        .frame(width: AppSetting.screenWidth * 0.7 ,height: 50,alignment: .center)
                                        //.font(.body)
                                    Text("(\( makeDate(day:days.first?.date ?? Date.now))〜)").font(.caption)
                                        .frame(width: AppSetting.screenWidth * 0.7 ,alignment: .trailing)
                                }
                                .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.45)
                                .background(.black.opacity(0.1))
                                .cornerRadius(15)
                            }
                            
                        }
                        .frame(height: AppSetting.screenWidth * 0.45)
                        .foregroundColor(.primary)
                        .fontWeight(.light)
                        //.font(.footnote)
                        
                        
                    }
                    
                    .foregroundColor(Color(UIColor.label))
                    
                    

                    
                    SpeechBubble2()
                        .rotation(Angle(degrees: 180))
                        .foregroundColor(.white)
                        //.padding()
                        .overlay{
                            VStack{
                                
                                
                                
                                VStack{
                                    Text(isComplete ? "本日のチャレンジは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                    
                                    if isComplete{
                                        Button {
                                            showCompleteWindew = true
                                        } label: {
                                            Text("ウインドウを再表示する")
                                        }
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                        .padding(.top, 1)
                                        .frame(width: AppSetting.screenWidth * 0.65, alignment: .trailing)
                                    }
                                    
                                }
                                .padding(.vertical)
                            }
                            .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.3)
                            .foregroundColor(.black)
                        }
                        .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.3)
                        .opacity(0.8)
                        
                    
                    
                    ///Completeボタンが押されたら本日分のDailyDataを保存
                    Button(action: {
                        withAnimation{
                            isComplete = true
                            showCompleteWindew = true
                        }
                        let day = DailyData(context: moc)
                        day.id = UUID()
                        day.date = Date.now
                        day.memo = ""
                        day.num = Int16(dayNumber)
                        try? moc.save()
                    }, label: {
                        CompleteButton(num:isComplete ? dayNumber - 1 : dayNumber)
                            .foregroundStyle(.primary)
                            .opacity(isComplete ? 0.3 : 1.0)
                    })
                    .disabled(isComplete)
                    
                    Spacer()
                    Spacer()
                }
                
                
                
                ///ボタン押下後は完了のビューを重ねて表示
                if showCompleteWindew{
                    CompleteView(showCompleteWindew: $showCompleteWindew)
                        .padding()
                        .transition(.scale)
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.secondary)
            .foregroundStyle(
                .linearGradient(
                    colors: [storedColorTop, storedColorBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            .onAppear{
                
                ///アプリ起動時に今日のミッションがすでに完了しているか確認
                let todaysData = days.filter{
                    ///CoreDataに保存されたデータの中に今日と同じ日付が存在するか確認
                    Calendar.current.isDate(Date.now, equalTo: $0.date ?? Date.now, toGranularity: .day)
                }
                
                ///もし同日が存在していたら完了フラグをTrueにする
                if todaysData.isEmpty{
                    isComplete = false
                }else{
                    isComplete = true
                }
            }
            //.navigationTitle("100days Challenge")
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ActionView_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        ActionView()
    }
}
