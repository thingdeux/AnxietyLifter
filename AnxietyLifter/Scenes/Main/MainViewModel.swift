//
//  MainViewModel.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

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
            .sink(receiveCompletion: { completed in
                switch (completed) {
                case .finished:
                    print("Finished retrieving")
                case .failure(let error):
                    print("Failed to retrieve data \(error)")
                }
            }, receiveValue: { data in
                self.latestData = data
            })
    }    
}
