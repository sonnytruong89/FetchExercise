//
//  APIDesserts.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation

extension FetchAPIs.GetDesserts : APIHandler {
    // Request Handler
    var path: String {
        "/api/json/v1/1/filter.php"
    }
    
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "c", value: "Dessert")]
    }
    
    //Response
    typealias ResponseDataType = MealResponse
}
