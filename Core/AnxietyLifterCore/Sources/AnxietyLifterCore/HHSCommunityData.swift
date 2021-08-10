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
    private let percentChangeInCases: Double
    private let totalCasesToNow: Int
    
    // Mortality Data
    private let percentChangeInDeaths: Double
    private let totalDeathsToNow: Int
    
    // Hospital Data
    private let confirmedCovidAdmissionLast7Days: Int
    private let suspectedCovidAdmissionsToHospitalLast7Days: Int
    private let percentageVentilatorsChange: Double
    private let percentageICUInpatient: Double
    private let percentageCovidICUInpatient: Double
        
    // Test Data
    private let positiveTestsInLast7Days: Double
    private let totalTestsInLast7Days: Double
    private let totalTestsPercentChange: Double
    
    // MetaData
    private let fipsCode: String
    private let county: String
    private let lastUpdated: TimeInterval
    
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
        case suspectedCovidAdmissionsToHospitalLast7Days = "susp_covid_admit_last_7_d"
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
                 percentChangeInCases: percentChangeInCases,
                 totalCasesToNow: totalCasesToNow)
    }
    
    var mortalityData: MortalityData {
        MortalityData(percentChangeInDeaths: percentChangeInDeaths, totalDeathsToNow: totalDeathsToNow, deathsInTheLast7Days: deathsInTheLast7Days)
    }
    
    var hospitalData: HospitalData {
        HospitalData(confirmedCovidAdmissionLast7Days: confirmedCovidAdmissionLast7Days, suspectedCovidAdmissionsToHospitalLast7Days: suspectedCovidAdmissionsToHospitalLast7Days, percentageVentilatorsChange: percentageVentilatorsChange, percentageICUInpatient: percentageICUInpatient, percentageCovidICUInpatient: percentageCovidICUInpatient)
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
        public let lastUpdated: TimeInterval
        
        public func getLastUpdatedDateFormatted() -> String {
            let date = Date(timeIntervalSince1970: self.lastUpdated / 1000.0)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
            dateFormatter.timeZone = .current
            return dateFormatter.string(from: date)
        }
    }
    
    struct MortalityData: Codable {
        public let percentChangeInDeaths: Double
        public let totalDeathsToNow: Int
        public let deathsInTheLast7Days: Int
    }
    
    struct TestData: Codable {
        public let positiveTestsInLast7Days: Double
        public let totalTestsInLast7Days: Double
        public let totalTestsPercentChange: Double
        public var percentageOfPositiveTests: Double {
            return (positiveTestsInLast7Days / totalTestsInLast7Days) * 100
        }
    }
    
    struct HospitalData: Codable {
        public let confirmedCovidAdmissionLast7Days: Int
        public let suspectedCovidAdmissionsToHospitalLast7Days: Int
        public let percentageVentilatorsChange: Double
        public let percentageICUInpatient: Double
        public let percentageCovidICUInpatient: Double
    }
    
    struct CaseData: Codable {
        public let casesInTheLast7Days: Int
        public let percentChangeInCases: Double
        public let totalCasesToNow: Int
    }
}
