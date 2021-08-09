//
//  ContentView.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

import SwiftUI
import AnxietyLifterCore

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Last 7 Days")
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .padding(.top, 46)
                
                HStack(spacing: 16) {
                    DataPointPreviewView(text: viewModel.positiveTestCount, image: #imageLiteral(resourceName: "AdmissionIcon"))
                    DataPointPreviewView(text: viewModel.deathCount, image: #imageLiteral(resourceName: "DeathIcon"))
                    DataPointPreviewView(text: viewModel.admissionCount, image: #imageLiteral(resourceName: "HospitalIcon"))
                }
                .onAppear() { viewModel.onAppear() }
                .frame(height: 40)
                .padding(.top, 60)
                .padding([.leading, .trailing], 10)
                .offset(y: -20)
                
                StopLightView(viewModel.currentThreatLevel)
                    .frame(width: 200, height: 400)
                    .padding()
                
                Text("Last Updated: \(viewModel.lastUpdated)")
                    .foregroundColor(.white)
                    .font(.footnote)
                Spacer()
            }
            Spacer()
        }
    }
}

private struct DataPointPreviewView: View {
    let text: String
    let image: UIImage
    
    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 40)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .background(Color.black.opacity(0.9))
            .colorScheme(.dark)
            .previewDevice("iPhone 11 Pro")
    }
}
