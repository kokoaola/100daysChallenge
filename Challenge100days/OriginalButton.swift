//
//  OriginalButton.swift
//  timer
//
//  Created by koala panda on 2023/01/20.
//

import SwiftUI



struct CloseButton: View{
    var body: some View {
        Image(systemName: "xmark")
            .font(.title3).foregroundColor(.primary)
            .padding()
    }
    
}


struct NextButton: View {
    var isStart: Bool
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                Text(isStart ? "始める":"次へ")
                Image(systemName: "arrowshape.right")
            }
            .font(.title2.weight(.bold))
            .foregroundColor(文字と内側の枠の色)
        }
        .foregroundColor(.green)
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
        .foregroundColor(.orange)
    }
}


struct SaveButton: View {
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 3
    let height = AppSetting.screenWidth / 6
    let 文字と内側の枠の色 = Color(UIColor.white)
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                Text("保存する")
                Image(systemName: "checkmark.circle")
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



struct LeftIconButton: View{
    let icon: Image?
    let text: String
    
    let radius:CGFloat = 10.0
    let width = AppSetting.screenWidth / 1.7
    let height = AppSetting.screenWidth / 5
    let borderColor = Color(UIColor.white)
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
                .foregroundColor(borderColor)
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width - 7, height: height - 7)
            HStack(alignment: .lastTextBaseline){
                icon
                Text(text)
            }
            .font(.title2.weight(.bold))
            .foregroundColor(borderColor)
        }
    }
}


//struct ShareButton: View {
//    let radius:CGFloat = 10.0
//    let width = AppSetting.screenWidth / 1.7
//    let height = AppSetting.screenWidth / 5
//    let borderColor = Color(UIColor.white)
//
//    var body: some View {
//        ZStack{
//            RoundedRectangle(cornerRadius: radius)
//                .frame(width: width, height: height)
//                .foregroundColor(borderColor)
//            RoundedRectangle(cornerRadius: radius)
//                .frame(width: width - 7, height: height - 7)
//            HStack(alignment: .lastTextBaseline){
//                Image(systemName: "square.and.arrow.up")
//                Text("シェアする")
//            }
//            .font(.title2.weight(.bold))
//            .foregroundColor(borderColor)
//        }
//    }
//}
//
//
//struct MemoButton: View {
//    let radius:CGFloat = 10.0
//    let width = AppSetting.screenWidth / 1.7
//    let height = AppSetting.screenWidth / 5
//    let borderColor = Color(UIColor.white)
//
//    var body: some View {
//        ZStack{
//            RoundedRectangle(cornerRadius: radius)
//                .frame(width: width, height: height)
//                .foregroundColor(borderColor)
//            RoundedRectangle(cornerRadius: radius)
//                .frame(width: width - 7, height: height - 7)
//            HStack(alignment: .lastTextBaseline){
//                Image(systemName: "rectangle.and.pencil.and.ellipsis")
//                Text("メモを追加")
//            }
//            .font(.title2.weight(.bold))
//            .foregroundColor(borderColor)
//        }
//    }
//}
//
//
//struct SetScheduleButton: View {
//    let radius:CGFloat = 10.0
//    let width = AppSetting.screenWidth / 1.7
//    let height = AppSetting.screenWidth / 5
//    let borderColor = Color(UIColor.white)
//
//    var body: some View {
//        ZStack{
//            RoundedRectangle(cornerRadius: radius)
//                .frame(width: width, height: height)
//                .foregroundColor(borderColor)
//            RoundedRectangle(cornerRadius: radius)
//                .frame(width: width - 7, height: height - 7)
//            HStack(alignment: .lastTextBaseline){
//                Text("決定")
//            }
//            .font(.title2.weight(.bold))
//            .foregroundColor(borderColor)
//        }
//    }
//}


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
                LeftIconButton(icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
//                CloseButton()
//                HStack{
//                    BackButton()
//                    NextButton(isStart: false)
//                }
//                SaveButton()
//                CompleteButton(num: 1)
//                SpeechBubble()
            }
            .environment(\.locale, Locale(identifier:"en"))
            
            VStack{
                CloseButton()
                HStack{
                    BackButton()
                    NextButton(isStart: false)
                }
                SaveButton()
                CompleteButton(num: 1)
//                ShareButton()
//                MemoButton()
//                SetScheduleButton()
                SpeechBubble()
            }
            .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
