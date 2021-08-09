//
//  MainViewModel.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

import UIKit
import Combine
import AnxietyLifterCore

class MainViewModel: ObservableObject {
    let service: HHSApiService
    @Published var latestData: HHSCommunityData?
    
    private(set) var data: [HHSCommunityData] = []
    private var acquireDataSubscriber: AnyCancellable?
    
    init(_ apiService: HHSApiService = HHSApiService.shared) {
        service = apiService
    }
    
    func onAppear() {
        acquireDataSubscriber?.cancel()
        acquireDataSubscriber =
            service.acquireLatestData()
            .print("🅥🅜")
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completed in
                switch (completed) {
                case .finished: break
                case .failure(let error):
                    print("🅥🅜 Failed to retrieve data \(error)")
                    // TODO: Error on Screen
                }
            }, receiveValue: { data in
                self.latestData = data
            })
    }    
}
