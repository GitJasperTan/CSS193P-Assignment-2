//
//  ContentView.swift
//  Memorize
//
//  Created by Jasper Tan on 3/26/24.
//

import SwiftUI

var cardAdjustment = false

struct ContentView: View {
    
    let halloweenEmojis: [String] = ["👻", "🎃", "🕷️", "💀", "😈", "🕸️", "🧙", "🙀", "👹", "😱", "👺", "😳"]
    let signLanguageEmojis: [String] = ["🤲", "👏", "👍", "👎", "👊", "✊", "🤟", "👌", "🤌", "👉", "🙏", "🫵", "👋", "🖕"]
    let animalEmojis: [String] = ["🐶", "🐼", "🐍", "🐸", "🦄", "🐖", "🐿️", "🐮", "🐙", "🐔", "🐳", "🐻", "🫎", "🐗", "🐝"]
    let emojiArray: [[String]]
    
    let imageDict: [Int: String] = [0: "teddybear.fill", 1: "hand.raised.fill", 2: "pawprint.fill"]
    let themeDict: [Int: String] = [0: "Halloween", 1: "Sign Lang", 2: "Animals"]
    
    init() {
        emojiArray = [halloweenEmojis, signLanguageEmojis, animalEmojis]
    }
    
    
    let numThemes: Int = 3
    @State var cardCount: Int = 4
    @State var themeSelector: Int = 2
    
    var body: some View {
        
        VStack {
            ScrollView {
                
                Text("Memorize!")
                    .font(.largeTitle)

                
                cardInit
                //Spacer()
            }
#if cardAdjustment
            cardCountAdjuster
#endif
            
            themeButtons()

            
        }
        .padding()
        
    }
    
    
    func themeButtons() -> some View {
        HStack {
            ForEach(0..<numThemes, id: \.self) { index in
                Spacer()
                if (themeSelector == index) {
                    ThemeButtonView(imageName: imageDict[index] ?? "questionmark.app", themeNum: index + 1, themeText: themeDict[index] ?? ("Theme " + String(index + 1)), themeSelector: $themeSelector)
                }
                else {
                    ThemeButtonView(imageName: "questionmark.app", themeNum: index + 1, themeText: ("Theme " + String(index + 1)), themeSelector: $themeSelector)
                }
                Spacer()
            }

        }
    }
    
    var cardInit: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: .infinity))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojiArray[themeSelector][index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
    }
    
#if cardAdjustment
    var cardCountAdjuster: some View {
        HStack {
            cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
            Spacer()
            cardCountAdjuster(by: 1, symbol: "rectangle.stack.badge.plus.fill")
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
                cardCount += offset
        }, label: {
            Image(systemName: symbol)
        })
        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
    }
#endif
    
}

struct ThemeButtonView: View {
    
    let imageName: String
    let themeNum: Int
    let themeText: String
    @Binding var themeSelector: Int
    
    var body: some View {
        Button(action: {
            themeSelector = self.themeNum - 1
        }, label: {
            VStack{
                Image(systemName: imageName)
                    .font(.title)
                Text(themeText)
            }
            .padding()
        })
        .disabled(imageName != "questionmark.app")
    }
}

struct CardView: View {
    
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            
            base.fill().opacity(isFaceUp ? 0 : 1)
            

        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
