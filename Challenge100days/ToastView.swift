//
//  ToastView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/26.
//

import SwiftUI

struct ToastView: View {
    @Binding var show: Bool
    var text: String
    @State private var opa = 0.0
    @State var timer: Timer?
    
    var body: some View {
        if show {
            Text(text)
//                .frame(width: AppSetting.screenWidth/2)
                .foregroundColor(.black)
                .fontWeight(.semibold)
                .padding(.horizontal, 60)
                .padding(.vertical)
                .background(.white)
                .cornerRadius(15.0)
                .opacity(opa <= 0.3 ? 1 : 1.0 - opa)
//                .opacity(show ? 1 : 0)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                            opa += 0.1
                            if opa >= 0.7{
                                show = false
                                self.timer?.invalidate()
                                opa = 0.0
                            }
                        })
                    }

//                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
//                        opa += 0.1
//                        if opa >= 0.7{
//                            withAnimation(.easeOut(duration: 3.0)) {
//                                show = false
//                            }
//                            self.timer?.invalidate()
//                            opa = 0.0
//                        }
////                        if opa >= 1.0{
////                            self.timer?.invalidate()
////                            show = false
////                            opa = 0.0
////                        }
//                    })
                }
//                .frame(width: AppSetting.screenWidth * 0.8)
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        ToastView(show: $show, text: "コピーしました")
    }
}
