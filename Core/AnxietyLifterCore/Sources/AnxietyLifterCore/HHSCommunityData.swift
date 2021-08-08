//
//  File.swift
//
//
//  Created by Joshua Danger on 8/3/21.
//

import UIKit

public struct HHSResponse: Decodable {
    public let features: [HHSDataWrapper]
    public var allCommunityData: [HHSCommunityData] {
        return features.map { $0.attributes }
    }
}

public struct HHSDataWrapper: Decodable {
    public let attributes: HHSCommunityData
}

public struct HHSCommunityData: Codable {

    // Case Data
    private let casesInTheLast7Days: Int
    private let deathsInTheLast7Days: Int
    private let percentChangeInCases: Int
    private let totalCasesToNow: Int
    
    // Mortality Data
    private let percentChangeInDeaths: Int
    private let totalDeathsToNow: Int
    
    // Hospital Data
    private let confirmedCovidAdmissionLast7Days: Int
    private let suspectedCovidAdmissionAdmissionsToHospitalLast7Days: Int
    private let percentageVentilatorsChange: Int
    private let percentageICUInpatient: Int
    private let percentageCovidICUInpatient: Int
        
    // Test Data
    private let positiveTestsInLast7Days: Int
    private let totalTestsInLast7Days: Int
    private let totalTestsPercentChange: Int
    
    // MetaData
    private let fipsCode: String
    private let county: String
    private let lastUpdated: Double
    
    enum CodingKeys: String, CodingKey {
        case fipsCode = "FIPS_code"
        case county = "County"
        case casesInTheLast7Days = "Cases_last_7_days"
        case deathsInTheLast7Days = "Deaths_last_7_days"
        case percentChangeInCases = "Cases_percent_change"
        case percentChangeInDeaths = "Deaths_percent_change"
        case totalCasesToNow = "Cumulative_cases"
        case totalDeathsToNow = "Cumulative_deaths"
        case positiveTestsInLast7Days = "test_positivity_rate_last_7_d"
        case totalTestsInLast7Days = "total_tests_last_7_d"
        case totalTestsPercentChange = "total_tests_pct_change"
        case confirmedCovidAdmissionLast7Days = "conf_covid_admit_last_7_d"
        case suspectedCovidAdmissionAdmissionsToHospitalLast7Days = "susp_covid_admit_last_7_d"
        case percentageVentilatorsChange = "pct_vent_covid"
        case percentageICUInpatient = "pct_inpatient"
        case percentageCovidICUInpatient = "pct_inpatient_covid"
        case lastUpdated = "last_updated"
    }

}

// Wrapper Class Definitions
public extension HHSCommunityData {
    var caseData: CaseData {
        CaseData(casesInTheLast7Days: casesInTheLast7Days,
                 deathsInTheLast7Days: deathsInTheLast7Days,
                 percentChangeInCases: percentChangeInCases,
                 totalCasesToNow: totalCasesToNow)
    }
    
    var mortalityData: MortalityData {
        MortalityData(percentChangeInDeaths: percentChangeInDeaths, totalDeathsToNow: totalDeathsToNow)
    }
    
    var hospitalData: HospitalData {
        HospitalData(confirmedCovidAdmissionLast7Days: confirmedCovidAdmissionLast7Days, suspectedCovidAdmissionAdmissionsToHospitalLast7Days: suspectedCovidAdmissionAdmissionsToHospitalLast7Days, percentageVentilatorsChange: percentageVentilatorsChange, percentageICUInpatient: percentageICUInpatient, percentageCovidICUInpatient: percentageCovidICUInpatient)
    }
    
    var metaData: MetaData {
        MetaData(fipsCode: fipsCode, county: county, lastUpdated: lastUpdated)
    }
    
    var testData: TestData {
        TestData(positiveTestsInLast7Days: positiveTestsInLast7Days,
                 totalTestsInLast7Days: totalTestsInLast7Days,
                 totalTestsPercentChange: totalTestsPercentChange)
    }
}


// Namespaced Container Structs
public extension HHSCommunityData {
    struct MetaData: Codable {
        public let fipsCode: String
        public let county: String
        public let lastUpdated: Double
    }
    
    struct MortalityData {
        public let percentChangeInDeaths: Int
        public let totalDeathsToNow: Int
    }
    
    struct TestData: Codable {
        public let positiveTestsInLast7Days: Int
        public let totalTestsInLast7Days: Int
        public let totalTestsPercentChange: Int
    }
    
    struct HospitalData {
        public let confirmedCovidAdmissionLast7Days: Int
        public let suspectedCovidAdmissionAdmissionsToHospitalLast7Days: Int
        public let percentageVentilatorsChange: Int
        public let percentageICUInpatient: Int
        public let percentageCovidICUInpatient: Int
    }
    
    struct CaseData: Codable {
        public let casesInTheLast7Days: Int
        public let deathsInTheLast7Days: Int
        public let percentChangeInCases: Int
        public let totalCasesToNow: Int
    }
}

@available(iOS 13.0.0, *)
public struct AlertStateData: Codable {
    public let state: StopLightView.State
    public let associatedText: String
    public let caseData: HHSCommunityData.CaseData
    public let metaData: HHSCommunityData.MetaData
    public let testData: HHSCommunityData.TestData
}
