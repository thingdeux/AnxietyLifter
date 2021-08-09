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
    public let caseData: HHSCommunityData.CaseData
    public let metaData: HHSCommunityData.MetaData
    public let testData: HHSCommunityData.TestData
    
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

// MARK: Analysis
@available(iOS 13.0.0, *)
extension AlertStateData {
    static func analyze(communityData: HHSCommunityData) -> AnyPublisher<AlertStateData, Never> {
        return processTestCases(communityData.testData)
            .combineLatest(processMortalityData(communityData.mortalityData), processHospitalData(communityData.hospitalData))
            .map { (testCautionLevel, mortalityCautionLevel, hospitalCautionLevel) in
                let threatAmount = testCautionLevel.rawValue + mortalityCautionLevel.rawValue + hospitalCautionLevel.rawValue
                return AlertStateData(state: determineRawThreshold(threatAmount), associatedText: "",
                                      caseData: communityData.caseData,
                                      metaData: communityData.metaData,
                                      testData: communityData.testData)

            }
            .eraseToAnyPublisher()
    }

    private static func processTestCases(_ communityData: HHSCommunityData.TestData) -> Future<CautionLevel, Never> {
        return Future<CautionLevel, Never> { promise in
            promise(.success(.none))
        }
    }

    private static func processMortalityData(_ communityData: HHSCommunityData.MortalityData) -> Future<CautionLevel, Never> {
        return Future<CautionLevel, Never> { promise in
            promise(.success(.none))
        }
    }

    private static func processHospitalData(_ communityData: HHSCommunityData.HospitalData) -> Future<CautionLevel, Never>{
        return Future<CautionLevel, Never> { promise in
            promise(.success(.none))
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
