//
//  APIProvider.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation

protocol APIProvider {
    func request<T: APIHandler>(for endpoint: T) async throws -> T.ResponseDataType
}

class APIAsyncProvider: APIProvider {
    func request<T>(for endpoint: T) async throws -> T.ResponseDataType where T: RequestHandler & ResponseHandler {
        
        guard let request = try? endpoint.asUrlRequest() else {
            throw ApiError(errorCode: "ERROR-2", message: "Request invalid")
        }

        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try endpoint.parseResponse(data: data)
        return result
    }
}
