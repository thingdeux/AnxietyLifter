//
//  ContentView.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

import SwiftUI
import AnxietyLifterCore

struct MainView: View {
    @State var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            Text("Forecast")
                .foregroundColor(Color.white)
                .font(.largeTitle)
                .padding(.top, 46)
            
            HStack(spacing: 8) {
                Rectangle()
                    .cornerRadius(10)
                    .overlay(
                        Text("High Transmission!")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .foregroundColor(.red)
                
                Rectangle()
                    .cornerRadius(10)
                    .overlay(
                        Text("Double Mask It")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .foregroundColor(.yellow)
                
                Rectangle()
                    .cornerRadius(10)
                    .overlay(
                        Text("All good")
                            .foregroundColor(.black)
                            .font(.caption)
                    )
                    .foregroundColor(.green)
            }
            .onAppear() { viewModel.onAppear() }
            .frame(height: 40)
            .padding(.top, 20)
            .padding([.leading, .trailing], 10)
            .offset(y: -20)
            StopLightView(.caution).frame(width: 200, height: 400)
            Spacer()
        }
        .background(Color.black.opacity(0.9))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .colorScheme(.dark)
            .previewDevice("iPhone 11 Pro")
    }
}
