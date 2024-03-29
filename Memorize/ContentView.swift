//
//  ContentView.swift
//  Memorize
//
//  Created by Jasper Tan on 3/26/24.
//

import SwiftUI

struct ContentView: View {
    
    let emojis: [String] = ["👻", "🎃", "🕷️", "💀", "😈", "🕸️", "🧙", "🙀", "👹", "😱", "👺", "😳"]
    @State var cardCount: Int = 4
    
    var body: some View {
        
        VStack {
            ScrollView {
                cardInit
                //Spacer()
            }
            cardCountAdjuster
        }
        .padding()
        
    }
    
    var cardInit: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: .infinity))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
    }
    
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
