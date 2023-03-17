//
//  ContentView.swift
//  Bullseye
//
//  Created by Muran Hu on 2023/3/17.
//

import SwiftUI

struct ContentView: View {
    
    @State var alertIsVisible: Bool = false
    @State var sliderValue: Double = 50.0
    @State var target: Int = Int.random(in: 1...100)
    @State var score: Int = 0
    @State var round: Int = 1
    let midnightBlue = Color(red: 0,
                             green: 0.2,
                             blue: 0.4)
    
    var sliderValueRounded: Int {
        Int(sliderValue.rounded())
    }
    
    var sliderTargetDifference: Int {
        abs(sliderValueRounded - target)
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Text("Put the bullseye as close as you can to:")
                    .modifier(LabelStyle())
                
                Text("\(target)")
                    .modifier(ValueStyle())
            }
            
            Spacer()
            
            HStack {
                Text("1").modifier(LabelStyle())
                Slider(value: $sliderValue, in: 1.0...100.0).accentColor(Color.green)
                Text("100").modifier(LabelStyle())
            }
            
            Spacer()
            
            Button(action: {
                alertIsVisible = true
            }){
                Text("Hit me!").modifier(ButtonLargeTextStyle())
            }
            .background(Image("Button-Normal").modifier(Shadow()))
            .alert(isPresented: $alertIsVisible) {
                Alert(title: Text(alertTitle()),
                      message: Text(scoreMessage()),
                      dismissButton: .default(Text("Awesome!")) {
                    startNewRound()
                }
                )
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    startNewGame()
                }){
                    HStack {
                        Image("StartOverIcon")
                        Text("Start over").modifier(ButtonSmallTextStyle())
                    }
                }
                .background(Image("Button-Normal"))
                .modifier(Shadow())
                
                Spacer()
                
                Text("Score:").modifier(LabelStyle())
                Text("\(score)").modifier(ValueStyle())
                
                Spacer()
                
                Text("Round:").modifier(LabelStyle())
                Text("\(round)").modifier(ValueStyle())
                
                Spacer()
                
                Button(action: {
                }){
                    HStack {
                        Image("InfoButton")
                        Text("Info").modifier(ButtonSmallTextStyle())
                    }
                }
                .background(Image("Button-Normal").modifier(Shadow()))
            }
            .padding(.bottom, 20)
            .accentColor(midnightBlue)
        }
        .onAppear() {
            startNewGame()
        }
        .background(Image("Background"))
    }
    
    func pointsForCurrentRound() -> Int {
        let maxScore = 100
        
        let points: Int
        if sliderTargetDifference == 0 {
            points = 200
        } else if sliderTargetDifference == 1 {
            points = 150
        } else {
            points = maxScore - sliderTargetDifference
        }
        
        return points
    }
    
    func scoreMessage() -> String {
        return "The slider's value is \(sliderValueRounded).\n" +
        "The target value is \(target).\n" +
        "You scored \(pointsForCurrentRound()) points this round."
    }
    
    func alertTitle() -> String {
        let title: String
        if sliderTargetDifference == 0 {
            title = "Perfect!"
        } else if sliderTargetDifference < 5 {
            title = "You almost had it!"
        } else if sliderTargetDifference <= 10 {
            title = "Not bad."
        } else {
            title = "Are you even trying?"
        }
        
        return title
    }
    
    func startNewGame() {
        score = 0
        round = 1
        resetSliderAndTarget()
    }
    
    func startNewRound() {
        score = score + pointsForCurrentRound()
        round = round + 1
        resetSliderAndTarget()
    }
    
    func resetSliderAndTarget() {
        sliderValue = Double.random(in: 1...100)
        target = Int.random(in: 1...100)
    }
}

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.white)
            .modifier(Shadow())
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
    }
}

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(Color.black)
    }
}

struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
            .foregroundColor(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
