//
//  ContentView.swift
//  Guess the Flag Project by hackingwithswift.com (Paul Hudson) with changes made by me. Changes I made include -
//
//  1. Placing the header text (in a VStack) on a separate layer in the ZStack so that when it the device rotates, it moves to the side (my ZStack aligment is .topLeading)
//
//  2. I implemented the challenge to display the score (also on a separate ZStack layer and had the score increase for wins (by 1) and decrease for losses (by 1)
//
//  3. When loss, I completed the challenge to alert the player which country's flag they incorrectly chose
//
//  4. I added a translucent PNG that I created in Photoshop (using an edited Adobe Stock image) on it's own layer so that it scales to fill even on rotation of the device.
//
// This was fun! All thanks to Paul and all the work he does for FREE (I ended up buying the first book to support. Do the same if you can.)
//
//
//  Created by Anthony Mendez on 4/13/20.
//  Copyright © 2020 Anthony Mendez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var currentScore = 0
    
    var blueMedium = Color(red: 0.2, green: 0.2, blue: 0.8)
    var blueDark = Color(red: 0.1, green: 0.1, blue: 0.2)
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(gradient: Gradient(colors: [blueMedium, blueDark]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image("earthBG").resizable().scaledToFill()
            }
            .edgesIgnoringSafeArea(.all).opacity(0.5)
            .frame(minWidth: 0, maxWidth: .infinity)
            
            VStack {
                Spacer()
                ForEach(0..<3) { number in
                    Button(action:{
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original).clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 1).opacity(0.2))
                            .shadow(color: .black, radius: 10, x: 0, y: 5)
                        .padding(8)
                    }
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            VStack(alignment: .leading) {
            Text("Tap the flag of...")
            Text(countries[correctAnswer])
                .font(.largeTitle)
                .fontWeight(.black)
            }
            .foregroundColor(Color.white)
            .padding(.top, 100)
            .padding(.leading, 20)
            
            VStack(alignment: .leading) {
            Spacer()
            Text("Score:")
            Text("\(currentScore)")
                .font(.largeTitle)
                .fontWeight(.black)
            }
            .foregroundColor(Color.white)
            .padding(.bottom, 100)
            .padding(.leading, 20)
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(currentScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            currentScore += 1
            scoreTitle = "Correct! \nYou earned a point.\n(\(currentScore - 1) + 1 = \(currentScore))"
        } else {
            currentScore -= 1
            scoreTitle = "Wrong. That's the flag of \(countries[number])\n You lose a point.\n(\(currentScore + 1) - 1 = \(currentScore))"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
