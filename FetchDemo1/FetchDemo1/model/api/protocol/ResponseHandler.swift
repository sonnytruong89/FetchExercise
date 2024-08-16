//
//  ResponseHandler.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation

protocol ResponseHandler {
    associatedtype ResponseDataType
    func parseResponse(data : Data) throws -> ResponseDataType
}

extension ResponseHandler {
    func parseResponse<T: Response>(data: Data) throws -> T {
        if let json = try? JSONSerialization.jsonObject(with: data) {
            print(json)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

typealias APIHandler = RequestHandler & ResponseHandler
