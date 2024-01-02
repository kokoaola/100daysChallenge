//
//  ToastView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/26.
//

import SwiftUI


///ポップアップのビュー
struct ToastView: View {
    ///自分自身の表示状態を格納するフラグ
    @Binding var show: Bool
    
    ///トースト内に表示する文章を格納する変数
    var text: String
    
    ///opacityの値を格納する変数
    @State private var opa = 0.0
    
    ///タイマー用変数
    @State private var timer: Timer?
    
    
    var body: some View {
        //フラグがtrueで表示
        if show {
            Text(LocalizedStringKey(text))
                .foregroundColor(.black)
                .fontWeight(.semibold)
                .padding(.horizontal, 60)
                .padding(.vertical)
                .background(.gray.opacity(0.4))
                .cornerRadius(15.0)
                .opacity(opa <= 0.3 ? 1 : 1.0 - opa)
            //0.1秒は普通に表示、その後徐々に消失0.5秒経過で完全消失
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                            opa += 0.1
                            if opa >= 0.8{
                                show = false
                                self.timer?.invalidate()
                                opa = 0.0
                            }
                        })
                    }
                }
        }
    }
}


struct ToastView_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        ToastView(show: $show, text: "コピーしました")
    }
}
