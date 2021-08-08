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
        List {
            ForEach(viewModel.data, id: \.metaData.county) { data in
                Text(data.metaData.county)
            }
        }
        .onAppear() { viewModel.onAppear() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
