//
//  APIResource.swift
//  WeatherApp
//
//  Created by Madrit Kacabumi on 29.06.23.
//

import Alamofire

protocol APIResource {
    var httpMethod: HTTPMethod { get }
    var requestURLString: String { get }
    var parameters: Parameters? { get }
    var headers: [String: String]? { get }
    
}
