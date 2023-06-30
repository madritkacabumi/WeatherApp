//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Foundation
import Combine
import Alamofire

protocol NetworkServiceType {
    func request<T: Decodable>(resource: APIResource, for type: T.Type) -> AnyPublisher<T, Error>
}

struct NetworkService: NetworkServiceType {
    
    // MARK: - Properties
    let session: Session
    
    // MARK: - Construct
    public init(session: Session = .default) {
        self.session = session
    }
    
    /// Performs REST Api Request
    /// - Parameters:
    ///   - resource: resource to request
    ///   - type: Decodable entity to parse the json
    /// - Returns: Will return a publisher with either the decoded response or an error.
    func request<T: Decodable>(resource: APIResource, for type: T.Type) -> AnyPublisher<T, Error> {
        
        return Just(resource)
            .map { resource -> DataRequest in
                return session
                    .request(APIRequest(resource: resource))
                    .validate()
            }
            .flatMap { dataRequest -> AnyPublisher<DataResponse<T, AFError>, Never> in
                return dataRequest.publishDecodable(type: T.self, queue: .global())
                    .eraseToAnyPublisher()
            }
            .tryMap { (dataResponse) -> T in
                switch dataResponse.result {
                    case .success(let value):
                        return value
                    case .failure(let error):
                        print(error)
                        throw error
                }
            }.eraseToAnyPublisher()
    }
}
