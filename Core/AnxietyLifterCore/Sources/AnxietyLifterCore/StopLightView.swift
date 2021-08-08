//
//  StopLightView.swift
//
//
//  Created by Joshua Danger on 8/8/21.
//

import SwiftUI

@available(iOS 13.0.0, *)
public struct StopLightView: View {
    public enum State {
        case go
        case stop
        case caution
        case none
    }
    
    private let activeLight: State
    
    public init(_ activeLight: State) {
        self.activeLight = activeLight
    }
    
    public var body: some View {
        StopLightViewShapes(activeLight: activeLight)
    }
}

@available(iOS 13.0.0, *)
private struct StopLightViewShapes: View {
    let activeLight: StopLightView.State
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Border
                Capsule().foregroundColor(.gray)
                
                // Inner Stop Light
                Capsule()
                    .overlay (
                        VStack {
                            Circle()
                                .foregroundColor(.red)
                                .opacity(activeLight == .stop ? 1.0 : 0.2)
                                .padding([.bottom, .top], geometry.size.width * 0.011)
                            
                            Circle()
                                .foregroundColor(.yellow)
                                .opacity(activeLight == .caution ? 1.0 : 0.2)
                                .padding([.bottom, .top], geometry.size.width * 0.011)
                            
                            Circle()
                                .foregroundColor(.green)
                                .opacity(activeLight == .go ? 1.0 : 0.2)
                                .padding([.bottom, .top], geometry.size.width * 0.011)
                        }
                        .padding()
                    )
                    .padding()
                    .foregroundColor(.black).opacity(0.95)
            }
        }
    }
}

@available(iOS 13.0.0, *)
struct StopLightView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(alignment: .center) {
                StopLightView(.go)
                    .frame(width: 200, height: 400)
                
                Text("What do you want to know")
                    .foregroundColor(.white)
                    .font(.title)
                    .padding(.bottom)
            }
            .background(Color.red)
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            StopLightView(.stop)
                .frame(width: 200, height: 400)
                .colorScheme(.dark)
            
            VStack {
                Text("What you need to know?")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(.top)
                
                HStack(spacing: 30) {
                    Rectangle()
                        .cornerRadius(10)
                        .overlay(
                            Text("High Transmission!")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        )
                        .foregroundColor(.red)
                    
                    Rectangle()
                        .cornerRadius(10)
                        .overlay(
                            Text("Double Mask It")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        )
                        .foregroundColor(.yellow)
                    
                    Rectangle()
                        .cornerRadius(10)
                        .overlay(
                            Text("All good")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                        )
                        .foregroundColor(.green)
                }
                .frame(height: 80)
                .padding(.top, 40)
                .padding([.leading, .trailing], 30)
                .offset(y: -20)
                                                                
                StopLightView(.caution)
                    .frame(width: 400, height: 800)
            }
            .colorScheme(.dark)
            .background(Color.black.opacity(0.75))
            .previewDevice("iPad Pro (12.9-inch) (5th generation)")
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
        }
    }
}
