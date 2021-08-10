//
//  HHSApiService.swift
//  AnxietyLifter
//
//  Created by Joshua Danger on 8/8/21.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public class HHSApiService {
    public typealias CommunityResponse = [HHSCommunityData]
    public class NoStoredDataFoundError: Error {}
    public class UnableToDecodeAlertStateError: Error {}
    public class UnableToEncodeAlertStateError: Error {}
    public class EmptyCommunityResponseError: Error {}
    
    private static let url: String = "https://services5.arcgis.com/qWZ7BaZXaP5isnfT/arcgis/rest/services/Community_Profile_Report_Counties/FeatureServer/0/query?f=json&geometry=%7B%22spatialReference%22%3A%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D%2C%22x%22%3A-13066018.365149321%2C%22y%22%3A4026346.3903181115%7D&outFields=*&spatialRel=esriSpatialRelIntersects&where=County%20NOT%20LIKE%20%27%25unallocated%25%27&geometryType=esriGeometryPoint&inSR=102100&outSR=102100&returnGeometry=false"
    
    private static let requestUri: URL = URL(string: url)!
    private var cancellable: Cancellable?
    private var dataStoragePublisher: Cancellable?
    
    private init() {}
        
    public static let shared: HHSApiService = HHSApiService()
    
    public enum Constants {
        public static let appGroupName = "group.land.josh.AnxietyLifter"
        public static let latestAlertStateKey = "alertStateLatest"
    }
    
    public final func acquireLatestData() -> Future<HHSCommunityData, Error> {
        cancellable?.cancel()
        
        return Future<HHSCommunityData, Error> { [weak self] promise in
            guard let self = self else { return }
            let request = URLRequest(url: HHSApiService.requestUri)
            self.cancellable =
                URLSession.DataTaskPublisher(request: request, session: .shared).first()
                    .print("🌎")
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: DispatchQueue.global())
                    .tryMap() { element -> Data in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                            }
                        return element.data
                        }
                    .decode(type: HHSResponse.self, decoder: JSONDecoder())
                    .tryMap() { value -> HHSCommunityData in
                        value.allCommunityData.first!
                    }
                    .print("💾")
                    .flatMap { (data) in
                        HHSApiService.storeLatestData(data).first()
                    }
                    .print("🌎")
                    .sink(receiveCompletion: { complete in
                        switch (complete) {
                        case .failure(let error):
                            print("🌎 Error Received during community data request")
                            promise(.failure(error))
                        case .finished: break
                        }
                        self.cancellable?.cancel()
                        self.cancellable = nil
                    },
                    receiveValue: { data in
                        print ("🌎 Received community data: \(data).")
                        promise(.success(data))
                    })
        }
    }
    
    private typealias StoredSuccessfully = Bool
    private static func storeLatestData(_ data: HHSCommunityData) -> AnyPublisher<HHSCommunityData, Error>  {
        return AlertStateData
            .analyze(communityData: data)
            .encode(encoder: JSONEncoder())
            .tryMap { (encodedData) -> HHSCommunityData in
                guard let userDefaults = UserDefaults(suiteName: Constants.appGroupName) else {
                    print("💾 Unable to encode alert state!!")
                    throw UnableToEncodeAlertStateError()
                }
                userDefaults.set(encodedData, forKey: Constants.latestAlertStateKey)
                print("💾 Stored Latest Data \(data)")
                return data
            }
            .eraseToAnyPublisher()
    }
    
    public static func retrieveLatestStoredData() -> Future <AlertStateData, Error> {
        return Future<AlertStateData, Error> { promise in
            /* Read the encoded data from the shared App Group Container */
            guard let encodedData = UserDefaults(suiteName: Constants.appGroupName )?.object(forKey: Constants.latestAlertStateKey) as? Data else {
                print("💾 Unable to retrieve stored data for key \(Constants.latestAlertStateKey)")
                promise(.failure(NoStoredDataFoundError()))
                return
            }
                        
            if let alertStateDecoded = try? JSONDecoder().decode(AlertStateData.self, from: encodedData) {
                promise(.success(alertStateDecoded))
            } else {
                print("💾 Unable to retrieve stored data for key \(Constants.latestAlertStateKey)")
                promise(.failure(UnableToDecodeAlertStateError()))
            }
        }
    }
    
    public static func retrieveLatestStoredData(completion: @escaping (WidgetAlertStateData?) -> ()) {
            guard let encodedData = UserDefaults(suiteName: Constants.appGroupName )?.object(forKey: Constants.latestAlertStateKey) as? Data else {
                print("💾 Unable to retrieve stored data for key \(Constants.latestAlertStateKey)")
                completion(nil)
                return
            }
                        
            if let data = try? JSONDecoder().decode(AlertStateData.self, from: encodedData) {
                let alertData = WidgetAlertStateData(state: data.state,
                                     text: (top: "\(data.rawData.testData.positiveTestsInLast7Days)%",
                                            middle: "\(data.rawData.mortalityData.deathsInTheLast7Days)",
                                            bottom: "\(data.rawData.hospitalData.percentageCovidICUInpatient)%"),
                                            lastUpdated: data.rawData.metaData.getLastUpdatedDateFormatted())
                completion(alertData)
            } else {
                print("💾 Unable to retrieve stored data for key \(Constants.latestAlertStateKey)")
                completion(nil)
            }
    }
}

