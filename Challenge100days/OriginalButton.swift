//
//  OriginalButton.swift
//  timer
//
//  Created by koala panda on 2023/01/20.
//

import SwiftUI

struct TutorialButton: View {
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    let labelString: String
    let labelImage : String
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 0){
                Text(labelString)
                Image(systemName: labelImage)
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
            
            
            //        RoundedRectangle(cornerRadius: radius)
            //            //.foregroundColor(ボタンの背景)
            //            .frame(width: Setting.screenWidth/1.7 - 4, height: Setting.screenWidth / 5 - 4)
            //
            //            .overlay{
            //                HStack(alignment: .lastTextBaseline){
            //                    Image(systemName: labelImage)
            //                    Text(labelString)
            //                   // Label("シェアする", systemImage: "square.and.arrow.up")
            //                }
            //                .font(.title2.weight(.bold))
            //                .foregroundColor(文字と内側の枠の色)
            //
            //                RoundedRectangle(cornerRadius: radius)
            //                    .stroke(lineWidth: 4)
            //                    .foregroundColor(文字と内側の枠の色)
            //                    .frame(width: Setting.screenWidth/1.7, height: Setting.screenWidth / 5)
            
            //                RoundedRectangle(cornerRadius: radius)
            //                    .stroke(lineWidth: 2.5)
            //.foregroundColor(ボタンの背景)
        }
    }
}


struct OriginalButton2: View {
    let radius:CGFloat = 10.0
    let labelString: String
    let labelImage : String
    //let ボタンの背景 = Color(UIColor.label)
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
        //.foregroundColor(ボタンの背景)
        //.frame(width: width, height: height)
        
            .overlay{
                HStack(alignment: .lastTextBaseline){
                    Image(systemName: labelImage)
                    Text(labelString)
                    // Label("シェアする", systemImage: "square.and.arrow.up")
                }
                //.font(.title2.weight(.bold))
                .foregroundColor(文字と内側の枠の色)
                
                RoundedRectangle(cornerRadius: radius)
                    .stroke(lineWidth: 5)
                    .foregroundColor(文字と内側の枠の色)
                //.frame(width: width-5, height: height-5)
                
                //                RoundedRectangle(cornerRadius: radius)
                //                    .stroke(lineWidth: 2.5)
                //.foregroundColor(ボタンの背景)
            }
    }
}


struct SpeechBubble: Shape {
    private let radius: CGFloat
    private let tailSize: CGFloat
    
    init(radius: CGFloat = 10) {
        self.radius = radius
        tailSize = 20
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2))
            path.addCurve(
                to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2 - tailSize),
                control1: CGPoint(x: rect.minX - tailSize, y: rect.maxY - rect.height / 2),
                control2: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2 - tailSize / 2)
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 270),
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
        }
    }
}


struct SpeechBubble2: Shape {
    private let radius: CGFloat
    private let tailSize: CGFloat
    
    init(radius: CGFloat = 10) {
        self.radius = radius
        tailSize = 20
    }
    
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
        VStack{
            TutorialButton(labelString: "次へ", labelImage: "arrowshape.right")
            CompleteButton(num: 1)
            OriginalButton(labelString: "シェアする", labelImage: "square.and.arrow.up")
            OriginalButton2(labelString: "シェアする", labelImage: "square.and.arrow.up").frame(width: 200, height: 40)
            SpeechBubble2()
                //.frame(width: 100)
        }
    }
}

