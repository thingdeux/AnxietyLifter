//
//  File.swift
//  
//
//  Created by Joshua Danger on 8/8/21.
//

import Foundation
import Combine

@available(iOS 13.0.0, *)
public struct AlertStateData: Codable {
    public let state: CautionLevel
    public let associatedText: String
    public let rawData: HHSCommunityData
    
    fileprivate enum Constants {
        // Weighted assessment based on how many areas of concern there are in a community.
        // ie: Hospital cases are at a high threatlevel but low tests ... high will always weigh heavily.
        static let UltraThreatThreshold = 15
        static let HighThreatThreshold: Int = 12
        // 1 High but two go's are fine ... but anything else is a worry.
        static let MediumThreatThreshold: Int = 9
        static let NoThreatThreshold: Int = 3
    }
}

@available(iOS 13.0.0, *)
public struct WidgetAlertStateData {
    public let state: CautionLevel
    public let text: (top: String, middle: String, bottom: String)
    public let lastUpdated: String
    
    public init(state: CautionLevel, text: (top: String, middle: String, bottom: String), lastUpdated: String) {
        self.state = state
        self.text = text
        self.lastUpdated = lastUpdated
    }
}

// MARK: Analysis
@available(iOS 13.0.0, *)
extension AlertStateData {
    static func analyze(communityData: HHSCommunityData) -> AnyPublisher<AlertStateData, Never> {
        return processTestCases(communityData.testData).first()
            .combineLatest(processMortalityData(communityData.mortalityData).first(),
                           processHospitalData(communityData.hospitalData).first())
            .map { (testCautionLevel, mortalityCautionLevel, hospitalCautionLevel) in
                let threatAmount = testCautionLevel.rawValue + mortalityCautionLevel.rawValue + hospitalCautionLevel.rawValue
                print("""
                🚨
                     Test Cases Caution Level \(testCautionLevel)
                     Mortality Caution Level \(mortalityCautionLevel)
                     Hospital Caution Level \(hospitalCautionLevel)
                🚨
                """)
                return AlertStateData(state: determineRawThreshold(threatAmount), associatedText: "",
                                      rawData: communityData)

            }
            .eraseToAnyPublisher()
    }

    /// Determine positive cases caution levels
    private static func processTestCases(_ testData: HHSCommunityData.TestData) -> Future<CautionLevel, Never> {
        return Future<CautionLevel, Never> { promise in
            // Find the percentage of new positive cases happening.
            print("🚨 Percentage of Total Tests which were positive: \(testData.percentageOfPositiveTests)")
            switch (testData.percentageOfPositiveTests) {
            case 51...100: promise(.success(CautionLevel.stop))
            case 51...60: promise(.success(CautionLevel.caution))
            case 30...50: promise(.success(CautionLevel.caution))
            default: promise(.success(CautionLevel.go))
            }
            
        }
    }

    /// Determine mortality caution levels
    private static func processMortalityData(_ mortalityData: HHSCommunityData.MortalityData) -> Future<CautionLevel, Never> {
        return Future<CautionLevel, Never> { promise in
            print("🚨 Deaths in the last 7 days: \(mortalityData.deathsInTheLast7Days)")
            switch (mortalityData.deathsInTheLast7Days) {
            case 400...1000: promise(.success(CautionLevel.caution))
            case 0...400: promise(.success(CautionLevel.go))
            default: promise(.success(CautionLevel.stop))
            }
        }
    }

    /// Determine hospital caution levels
    private static func processHospitalData(_ hospitalData: HHSCommunityData.HospitalData) -> Future<CautionLevel, Never>{
        return Future<CautionLevel, Never> { promise in
            let icuCovidCases = hospitalData.percentageCovidICUInpatient
            print("🚨 percentage of Inpatient Covid Beds Filled \(icuCovidCases)")
            switch (icuCovidCases) {
            case 61...100: promise(.success(.stop))
            case 21...60: promise(.success(.caution))
            case 0...20: promise(.success(.go))
            default: promise(.success(.go))
            }
        }
    }
    
    static func determineRawThreshold(_ cautionLevelCount: Int) -> CautionLevel {
        switch (cautionLevelCount) {
        case Constants.UltraThreatThreshold...100:
            return CautionLevel.stop
        case Constants.HighThreatThreshold...Constants.UltraThreatThreshold - 1:
            return CautionLevel.caution
        case Constants.MediumThreatThreshold...Constants.HighThreatThreshold - 1:
            return CautionLevel.caution
        default:
            return CautionLevel.go
        }
    }
}
