//
//  ContentView.swift
//  Memorize
//
//  Created by Jasper Tan on 3/26/24.
//

import SwiftUI

/* DO NOT ENABLE
    Code under this macro is only for reference purposes
 */
var cardAdjustment = false

struct ContentView: View {
    
    @State var themeSelector: Int = 0
    @State var shuffledEmojiArr: [String] = []

    let emojiArray: [[String]] = [
            ["👻", "🎃", "🕷️", "💀", "😈", "🕸️"],
            ["✈️", "🚁", "🚀", "🚘", "🛵", "⛵️", "🛸", "🚲"],
            ["🐶", "🐼", "🐍", "🐸", "🦄"]
        ]
      
    let imageDict: [Int: String] = [0: "teddybear.fill", 1: "hand.raised.fill", 2: "pawprint.fill"]
    let themeDict: [Int: String] = [0: "Halloween", 1: "Vehicles", 2: "Animals"]
    let cardColorDict: [Int: Color] = [0: .orange, 1: .green, 2: .indigo]
    

    var body: some View {
        VStack {
            ScrollView {
                Text("Memorize!")
                    .font(.largeTitle)
                
                cardInit
            }
            
            themeButtons()
                .onChange(of: themeSelector) {
                    updatedShuffledEmojiArr()
                }
            
#if cardAdjustment
            cardCountAdjuster
#endif
        }
        .padding()
        .onAppear {
            updatedShuffledEmojiArr()
        }
        
    }
    
    
    func themeButtons() -> some View {
        HStack {
            ForEach(0..<emojiArray.count, id: \.self) { index in
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
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth, maximum: .infinity))]) {
            ForEach(0..<shuffledEmojiArr.count, id: \.self) { index in
                CardView(content: shuffledEmojiArr[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundStyle(cardColorDict[themeSelector] ?? .orange)
        
    }
    
    var cardWidth: CGFloat {
        
        if (shuffledEmojiArr.count <= 4) {
            /* If arr has less than or eq 4 cards, make width 120. Max cards on screen with 120 width is 4 cards*/
            return 120
        }
        else if (shuffledEmojiArr.count <= 9) {
            /* If arr has less than or eq 9 cards, make width 100. Max cards on screen with 100 width is 9 cards*/
            return 100
        }
        else {
            /* If arr has more than 9 cards, make width 80. Max cards on screen with 80 width is 16 cards. Scroll view is present though so more than 16 cards allowed*/
            return 80
        }
    }
    
    func updatedShuffledEmojiArr() {
        
        /* Select a random number of cards to display in Memorize Game*/
        
        //Get random number between 1 and number of emojis
        let randNum = Int.random(in: 1...emojiArray[themeSelector].count)
        
        //Shuffle array prior to selecting random number of cards
        shuffledEmojiArr = emojiArray[themeSelector].shuffled()
        
        // Store cards 1 to randNum in to shuffled array
        shuffledEmojiArr.removeSubrange(randNum..<shuffledEmojiArr.count)
        
        // Double the array to create pairs and reshuffle the order
        shuffledEmojiArr = (shuffledEmojiArr + shuffledEmojiArr).shuffled()
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
