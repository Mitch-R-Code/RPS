//
//  ContentView.swift
//  RPS
//
//  Created by Admin on 4/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var gameState: GameState = .start
    @State private var countdown = 3
    @State private var selectedOption: GameOption?
    @State private var timer: Timer?
    @State private var showGo = false
    
    enum GameState {
        case start
        case countdown
        case result
    }
    
    enum GameOption: String, CaseIterable {
        case rock = "Rock"
        case paper = "Paper"
        case scissors = "Scissors"
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                if gameState == .start {
                    Button(action: startGame) {
                        Text("Start")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 200)
                            .background(Color.green)
                            .clipShape(Circle())
                    }
                } else if gameState == .countdown {
                    if showGo {
                        Text("Go!")
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Text("\(countdown)...")
                            .font(.system(size: 100, weight: .bold))
                            .foregroundColor(.white)
                    }
                } else if gameState == .result {
                    if let option = selectedOption {
                        Image(option.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                }
                
                Spacer()
                
                if gameState == .result {
                    Button(action: resetGame) {
                        Text("Again!")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    private func startGame() {
        gameState = .countdown
        countdown = 3
        showGo = false
        selectedOption = nil
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                showGo = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    timer.invalidate()
                    self.timer = nil
                    showResult()
                }
            }
        }
    }
    
    private func showResult() {
        if selectedOption == nil {
            selectedOption = GameOption.allCases.randomElement()
        }
        gameState = .result
    }
    
    private func resetGame() {
        gameState = .start
        selectedOption = nil
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ContentView()
}
