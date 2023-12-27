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
    func embedInNavigationView() -> some View {
        return NavigationView { self }
    }
    
    ///カスタマイズしたテキストエディットのスタイルのextension
    func customTutorialTextEditStyle() -> some View {
        self
            .scrollContentBackground(Visibility.hidden)
            .background(.ultraThinMaterial)
            .border(.white, width: 1)
            .frame(height: AppSetting.screenHeight / 12)
    }
    
    func customAddMemoTextEditStyle() -> some View {
        self
        .foregroundColor(Color(UIColor.label))
        .lineSpacing(10)
        .scrollContentBackground(Visibility.hidden)
        .background(.ultraThinMaterial)
        .border(.white, width: 3)
        .frame(height: 300)
}
    
    ///アクセシビリティに関する項目を追加するextension
    func editAccessibility(label: String? = nil, hint: String? = nil, removeTraits: AccessibilityTraits? = nil, addTraits: AccessibilityTraits? = nil) -> some View {
        self
            .modifier(AccessibilityModifier(label: label, hint: hint, removeTraits: removeTraits, addTraits: addTraits))
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
