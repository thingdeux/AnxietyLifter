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
    private static let url: String = "https://services5.arcgis.com/qWZ7BaZXaP5isnfT/arcgis/rest/services/Community_Profile_Report_Counties/FeatureServer/0/query?f=json&geometry=%7B%22spatialReference%22%3A%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D%2C%22x%22%3A-13066018.365149321%2C%22y%22%3A4026346.3903181115%7D&outFields=*&spatialRel=esriSpatialRelIntersects&where=County%20NOT%20LIKE%20%27%25unallocated%25%27&geometryType=esriGeometryPoint&inSR=102100&outSR=102100&returnGeometry=false"
    
    private static let requestUri: URL = URL(string: url)!
    private var cancellable: Cancellable?
    private init() {}
    
    
    public static let shared: HHSApiService = HHSApiService()
    
    public enum Constants {
        public static let appGroupName = "land.josh.anxietyLifter.storedContainer"
    }
    
    
    public func acquireLatestData() -> Future<CommunityResponse, Error> {
        cancellable?.cancel()
        
        return Future<CommunityResponse, Error> { [weak self] promise in
            guard let self = self else { return }
            let request = URLRequest(url: HHSApiService.requestUri)
            self.cancellable =
                URLSession.DataTaskPublisher(request: request, session: .shared)
                    .tryMap() { element -> Data in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                            httpResponse.statusCode == 200 else {
                                throw URLError(.badServerResponse)
                            }
                        return element.data
                        }
                    .decode(type: HHSResponse.self, decoder: JSONDecoder())
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
                        print ("🌎 Received community data: \(data.allCommunityData).")
                        promise(.success(data.allCommunityData))
                    })
        }
    }
    
    func storeLatestData() {
        
    }
    
    public func retrieveLatestStoredData() -> Future <AlertStateData, Error> {
        return Future<AlertStateData, Error> { [weak self] promise in
            
        }
    }
}

