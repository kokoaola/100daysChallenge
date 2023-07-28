//
//  MemoView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/04.
//

import SwiftUI
import CoreData


///記録の詳細を表示するビュー
struct DetailView: View {
    ///ViewModel用の変数
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @EnvironmentObject var userSettingViewModel: UserSettingViewModel
    
    ///画面破棄用の変数
    @Environment(\.dismiss) var dismiss
    
    ///ビュー生成時にオブジェクトデータ受け取る用変数
    let item: DailyData
    
    ///削除ボタン押下後の確認アラート用のフラグ
    @State private var showCansel = false
    
    ///入力したテキストを格納するプロパティ
    @State private var editText = ""
    
    ///シェア用の画像格納用変数
    @State private var image: Image?
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    
    
    var body: some View {
        
        VStack{
            //100日のうち何日目＋記録の日付を横並びで表示
            HStack{
                Text("\(item.num ) / 100")
                    .font(.title)
                
                Spacer()
                
                Text(makeDate(day: item.date ?? Date.now))
                    .font(.title3.weight(.ultraLight))
                    .padding(.leading, 40)
            }
            .accessibilityElement()
            .accessibilityLabel("\(item.num)日目の記録、\(makeAccessibilityDate(day: item.date ?? Date()))")
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            //メモが何も記入されていない場合はプレースホルダーを表示
            ZStack(alignment: .topLeading){
                if editText.isEmpty{
                    Text("保存されたメモはありません。\nタップで追加できます。")
                        .padding(8)
                        .foregroundColor(.primary)
                        .opacity(0.5)
                }
                //メモ編集用のテキストエディター
                TextEditor(text: $editText)
                    .lineSpacing(2)
                    .scrollContentBackground(Visibility.hidden)
                    .frame(maxHeight: .infinity)
                    .focused($isInputActive)
                    .tint(.white)
            }
        }
        .padding()
        .frame(maxHeight: AppSetting.screenHeight / 1.4)
        .background(.thinMaterial)
        .cornerRadius(15)
        .foregroundColor(.primary)
        .padding(.top, -50)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.ultraThinMaterial)
        .navigationBarBackButtonHidden(true)
        
        //グラデーション背景の設定
        .modifier(UserSettingGradient(appColorNum: userSettingViewModel.userSelectedColor))
        
        
        .onAppear{
            //シェア用の画像を生成
            image = generateImageWithText(number: Int(item.num), day: item.date ?? Date.now)
            
            //保存されたメモ内容があれば、テキストエディターの初期値として表示
            editText = item.memo ?? ""
        }
        
        
        .toolbar{
            //保存ボタンを配置
            ToolbarItemGroup(placement: .keyboard) {
                
                //文字数が上限を超えてる時の注意書き
                Text("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(editText.count > AppSetting.maxLengthOfMemo ? .red : .clear)
                
                //編集内容保存ボタン
                Button("保存する") {
                    coreDataViewModel.updateDataMemo(newMemo:editText, data:item )
                    Task{
                        await coreDataViewModel.assignNumbers()
                    }
                    isInputActive = false
                }
                
                .foregroundColor(editText.count <= AppSetting.maxLengthOfMemo ? .primary : .gray)
                .opacity(editText.count <= AppSetting.maxLengthOfMemo ? 1.0 : 0.5)
                .disabled(editText.count > AppSetting.maxLengthOfMemo)
            }
            
            //表示している日の記録の削除用ごみ箱アイコン
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    showCansel = true
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
                .padding(.trailing)
            }
            
            //画像シェア用のリンク
            ToolbarItem(placement: .navigationBarTrailing) {
                // MARK: -
                ShareLink(item: image ?? Image("noImage") , preview: SharePreview("Image", image:image ?? Image("noImage") )){
                    Image(systemName: "square.and.arrow.up")
                    
                }
            }
            
            //戻るボタン
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack{
                        Image(systemName: "chevron.backward")
                        Text("戻る")
                    }
                }
            }
        }
        .foregroundColor(Color(UIColor.label))
        
        
        //削除ボタン押下時のアラート
        .alert("この日の記録を破棄しますか？", isPresented: $showCansel){
            Button("破棄する",role: .destructive){
                coreDataViewModel.deleteData(data:item)
                
                Task{
                    await coreDataViewModel.assignNumbers()
                }
                
                if notificationViewModel.isNotificationOn{
                    notificationViewModel.setNotification(item: coreDataViewModel.allData.last)
                }
                dismiss()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("表示中のデータは破棄されます。\n（この動作は取り消せません。）")
        }
    }
}

//
//struct MemoView_Previews: PreviewProvider {
//    static private var dataController = DataController()
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//
//        DetailView(item: <#DailyData#>)
//        //            MemoView(num: 1, item: book)
//            .environment(\.managedObjectContext, dataController.container.viewContext)
//
//    }
//}

