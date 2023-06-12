//
//  OriginalButton.swift
//  timer
//
//  Created by koala panda on 2023/01/20.
//

import SwiftUI

struct NextButton: View {
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                Text("次へ")
                Image(systemName: "arrowshape.right")
            }
            .font(.title2.weight(.bold))
            .foregroundColor(文字と内側の枠の色)
        }
    }
}

struct BackButton: View {
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                Image(systemName: "arrowshape.left")
                Text("戻る")
            }
            .font(.title2.weight(.bold))
            .foregroundColor(文字と内側の枠の色)
        }
    }
}

struct StartButton: View {
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                Text("始める")
                Image(systemName: "arrowshape.right")
            }
            .font(.title2.weight(.bold))
            .foregroundColor(文字と内側の枠の色)
        }
    }
}

struct TutorialButton2: View {
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    let labelString: String
    let labelImage : String
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            HStack(alignment: .lastTextBaseline){
                Image(systemName: labelImage)
                Text(labelString)
                
            }
            .font(.title2.weight(.bold))
            .foregroundColor(文字と内側の枠の色)
            
        }
    }
}



struct CompleteButton: View {
    let width = 300.0
    let height = 170.0
    let num: Int
    
    var body: some View {
        
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
    }
}

struct OriginalButton: View {
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 1.7
    let height = AppSetting.screenWidth / 5
    //let height = 70.0
    let labelString: String
    let labelImage : String
    //let ボタンの背景 = Color(UIColor.label)
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
                .foregroundColor(文字と内側の枠の色)
            
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width - 7, height: height - 7)
            
            HStack(alignment: .lastTextBaseline){
                Image(systemName: labelImage)
                Text(labelString)
            }
            .font(.title2.weight(.bold))
            .foregroundColor(文字と内側の枠の色)
        }
    }
}


struct SpeechBubble: Shape {
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




struct OriginalButton_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            
            VStack{
                NextButton()
                BackButton()
                CompleteButton(num: 1)
                OriginalButton(labelString: "シェアする", labelImage: "square.and.arrow.up")
                SpeechBubble()
            }
            .environment(\.locale, Locale(identifier:"en"))
            
            VStack{
                NextButton()
                BackButton()
                CompleteButton(num: 1)
                OriginalButton(labelString: "シェアする", labelImage: "square.and.arrow.up")
                SpeechBubble()
            }
            .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
