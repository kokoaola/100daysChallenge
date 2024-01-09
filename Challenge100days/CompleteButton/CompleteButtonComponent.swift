//
//  CompleteButtonComponent.swift
//  Challenge100days
//
//  Created by koala panda on 2023/12/27.
//

import SwiftUI

///目標を表示するビュー
struct GoalView: View {
    var longTermGoal: String
    var shortTermGoal: String
    
    var body: some View{
        VStack(alignment: .center, spacing: 10){
            VStack{
                //長期目標の表示
                Text("目指している姿  :  ")
                    .fontWeight(.bold)
                    .frame(width: AppSetting.screenWidth * 0.8, alignment: .leading)
                
                Text("\(longTermGoal)")
            }
            .contentShape(Rectangle())
            .accessibilityElement()
            .accessibilityLabel("目指している姿、\(longTermGoal)")
            
            //短期目標の表示
            VStack{
                Text("100日取り組むこと : ")
                    .fontWeight(.bold)
                    .frame(width: AppSetting.screenWidth * 0.8, alignment: .leading)
                Text("\(shortTermGoal)")
            }
            .contentShape(Rectangle())
            .accessibilityElement()
            .accessibilityLabel("100日取り組むこと、\(shortTermGoal)")
        }
        .GoalBackground()
    }
}

///コンプリートボタンビュー
struct CompleteButton: View {
    ///番号を受け取って格納する変数
    let num: Int
    
    var body: some View {
        ///ボタンの高さと幅を格納する変数
        let width = 300.0
        let height = 170.0
        
        Capsule()
            .frame(width: width, height: height)
            .shadow(color:Color.black, radius: 5.0,
                    x: 8, y: 8)
            .overlay{
                VStack{
                    Text("\(num) / 100")
                    Text("Complete!")
                }
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.white)
                
                Capsule()
                    .stroke(lineWidth: 10)
                    .foregroundColor(.white)
                    .frame(width: width-10, height: height-10)
            }
            .editAccessibility(label: "\(num)日目を完了する")
    }
}

///吹き出しのビュー
struct SpeechBubbleView: View{
    var body: some View {
        SpeechBubblePath()
            .rotation(Angle(degrees: 180))
            .foregroundColor(.white)
            .frame(width: AppSetting.screenWidth * 0.9, height: AppSetting.screenWidth * 0.3)
            .opacity(0.8)
            .padding(.top)
            .offset(x:0, y:-10)
    }
}


///吹き出しのパス
struct SpeechBubblePath: Shape {
    private let radius = 10.0
    private let tailSize = 20.0
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + rect.width / 2, y: rect.minY))
            path.addCurve(
                to: CGPoint(x: rect.minX + rect.width / 2 + tailSize, y: rect.minY),
                control1: CGPoint(x: rect.minX + rect.width / 2, y: rect.minY - tailSize),
                control2: CGPoint(x: rect.minX + rect.width / 2 + tailSize / 2, y: rect.minY)
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
        }
    }
}
