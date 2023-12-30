//
//  View+Extensions.swift
//  WeatherApp
//
//  Created by koala panda on 2023/12/12.
//

import Foundation
import SwiftUI

extension View {
    ///自身をナビゲーションビューに入れるextension
    func embedInNavigationStack() -> some View {
        return NavigationStack { self }
    }
    
    ///カスタマイズしたテキストエディットのスタイルのextension
    ///チュートリアルのテキストエディット
    func customTutorialTextEditStyle() -> some View {
        self
            .scrollContentBackground(Visibility.hidden)
            .background(.ultraThinMaterial)
            .border(.white, width: 1)
            .frame(height: AppSetting.screenHeight / 12)
    }
    
    ///DetailViewのテキストエディット
    func customDetailViewTextEditStyle() -> some View {
        self
            .lineSpacing(2)
            .scrollContentBackground(Visibility.hidden)
            .frame(maxHeight: .infinity)
            .tint(.white)
    }
    
    
    ///AddMemoViewのテキストエディット
    func customAddMemoTextEditStyle() -> some View {
        self
        .foregroundColor(Color(UIColor.label))
//        .lineSpacing(10)
        .scrollContentBackground(Visibility.hidden)
        .background(.ultraThinMaterial)
        .border(.white, width: 3)
        .padding(.horizontal)
//        .frame(height: 200)
}
    
    ///アクセシビリティに関する項目を追加するextension
    func editAccessibility(label: String? = nil, hint: String? = nil, removeTraits: AccessibilityTraits? = nil, addTraits: AccessibilityTraits? = nil) -> some View {
        self
            .modifier(AccessibilityModifier(label: label, hint: hint, removeTraits: removeTraits, addTraits: addTraits))
    }
    
    ///DetailViewのスクリーンに表示するセルのサイズのextension
    func detailViewStyle() -> some View {
        self
            .padding()
            .frame(maxHeight: AppSetting.screenHeight / 1.4)
            .background(.thinMaterial)
            .cornerRadius(15)
            .foregroundColor(.primary)
            .padding(.top, -30)
            .padding([.bottom, .horizontal])
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.ultraThinMaterial)
            .navigationBarBackButtonHidden(true)
    }
    
    func GoalBackground() -> some View{
        self
            .font(.callout.weight(.medium))
            .padding()
            .frame(width: AppSetting.screenWidth * 0.9)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .padding(.top,32)
            .padding(.bottom, 42)
            .foregroundColor(.primary)
    }
}


///アクセシビリティに関する項目を追加するAccessibilityModifier
private struct AccessibilityModifier: ViewModifier {
    let label: String?
    let hint: String?
    let removeTraits: AccessibilityTraits?
    let addTraits: AccessibilityTraits?
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(LocalizedStringKey(label ?? ""))
            .accessibilityHint(LocalizedStringKey(hint ?? ""))
            .accessibilityAddTraits(addTraits ?? AccessibilityTraits())
            .accessibilityRemoveTraits(removeTraits ?? AccessibilityTraits())
    }
}


///引数で受け取った番号に応じた背景色を指定するViewModifier
struct UserSettingGradient: ViewModifier{
    let appColorNum: Int
    var colors:[Color]{
        switch appColorNum{
        case 0:
            return [.blue, .green]
        case 1:
            return [.green, .yellow]
        case 2:
            return [.purple, .blue]
        case 3:
            return [.black, .black]
        default:
            return [.blue, .green]
        }
    }
    
    func body(content: Content) -> some View{
        content.background(.secondary).foregroundStyle(LinearGradient(
            colors: [colors[0], colors[1]],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
    }
}

///引数で受け取った番号に応じた背景色を指定するViewModifier
struct GradientColor: View{
    let appColorNum: Int
    var colors:[Color]{
        switch appColorNum{
        case 0:
            return [.blue, .green]
        case 1:
            return [.green, .yellow]
        case 2:
            return [.purple, .blue]
        case 3:
            return [.black, .black]
        default:
            return [.blue, .green]
        }
    }
    
    var body: some View{
        ZStack{
            LinearGradient(
                colors: [colors[0], colors[1]],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Rectangle()
                .fill(Material.ultraThinMaterial)
        }
    }
    
//    func body(content: Content) -> some View{
//        content.background(.secondary).foregroundStyle(LinearGradient(
//            colors: [colors[0], colors[1]],
//            startPoint: .topLeading,
//            endPoint: .bottomTrailing
//        ))
//    }
}


/*
 使う時：
 
 @State private var selectedColor = 0
 VStack{
 Picker(selection: $selectedColor) {
 Text("青").tag(0)
 Text("オレンジ").tag(1)
 Text("紫").tag(2)
 Text("モノトーン").tag(3)
 } label: {
 Text("アプリの色を変更する")
 }
 }
 //背景グラデーション設定
 .modifier(UserSettingGradient(appColorNum: selectedColor))
 
 
 */
