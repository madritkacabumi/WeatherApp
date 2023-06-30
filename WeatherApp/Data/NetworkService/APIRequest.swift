//
//  APIRequest.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Alamofire
import Foundation

struct APIRequest: URLRequestConvertible {
    
    let resource: APIResource
    
    func asURLRequest() throws -> URLRequest {
        
        let requestURL = try resource.requestURLString.asURL()
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = resource.httpMethod.rawValue
        
        resource.headers?.forEach { (field, value) in
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }
        
        if let parameters = resource.parameters {
            if resource.httpMethod == .post {
                urlRequest = try JSONEncoding().encode(urlRequest, with: parameters)
            } else {
                urlRequest = try URLEncoding().encode(urlRequest, with: parameters)
            }
        }
        
        return urlRequest
    }
}
