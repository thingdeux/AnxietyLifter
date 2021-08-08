//
//  MainViewModel.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

import Foundation
import AnxietyLifterCore

class MainViewModel: ObservableObject {
    let service: HHSApiService
    private(set) var data: [HHSCommunityData] = []
    
    init(_ apiService: HHSApiService = HHSApiService.shared) {
        service = apiService
    }
    
    func onAppear() {
        
    }    
}
