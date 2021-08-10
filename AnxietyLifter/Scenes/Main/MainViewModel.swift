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
    @Published var latestData: AlertStateData?
    @Published var currentThreatLevel: CautionLevel = .none
    @Published var admissionCount: String = "- -"
    @Published var positiveTestCount: String = "- -"
    @Published var deathCount: String = "- -"
    @Published var lastUpdated: String = "- -"
    
    private(set) var data: [HHSCommunityData] = []
    private var acquireDataSubscriber: AnyCancellable?
    
    init(_ apiService: HHSApiService = HHSApiService.shared) {
        service = apiService
    }
    
    func onAppear() {
        acquireDataSubscriber?.cancel()
        acquireDataSubscriber =
            service.acquireLatestData()
            .flatMap { _ in
                return HHSApiService.retrieveLatestStoredData()
            }
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
                self.currentThreatLevel = data.state
                self.positiveTestCount = "\(data.rawData.testData.positiveTestsInLast7Days)%"
                self.deathCount = "\(data.rawData.mortalityData.deathsInTheLast7Days)"
                self.admissionCount = "\(data.rawData.hospitalData.percentageCovidICUInpatient)%"
                self.lastUpdated = data.rawData.metaData.getLastUpdatedDateFormatted()
            })
    }
}
