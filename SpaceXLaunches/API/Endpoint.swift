//
//  Endpoint.swift
//  MoviesVIPER
//
//  Created by Muhammad Adam on 08/11/2021.
//

import Foundation

struct Endpoint{
    let baseUrl: String
    let path: String
    var queries: [EndpointQuery]?
    
    var url: URL?{
        guard let url = URL(string: baseUrl + path) else {return nil}
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {return nil}
        
        components.queryItems = queries?.map{
            URLQueryItem(name: $0.key.description, value: $0.value)
        }
        
        
        return components.url
    }
}

struct EndpointQuery {
    let key:QueryKey
    let value:String
}

protocol QueryKey: CustomStringConvertible { }
