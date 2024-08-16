//
//  RequestHandler.swift
//  FetchDemo1
//
//  Created by Sonny Truong on 8/15/24.
//

import Foundation

struct ApiError : Error {
    var statusCode: Int
    let errorCode: String
    var message: String
    
    init(statusCode: Int = 0, errorCode: String, message: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }

    var errorCodeNumber: String {
        let numberString = errorCode.components(separatedBy: CharacterSet.decimalDigits).first!
        return numberString
    }
    
    private enum CodingKeys: String, CodingKey {
        case errorCode
        case message
    }
}

enum RequestMethod : String {
    case GET = "GET"
    case POST = "POST"
}

protocol RequestHandler {
    var path: String { get }
    
    var method: RequestMethod {get}
    var body: [String: Any]? {get}
    var queryItems: [URLQueryItem]? {get}
}

extension RequestHandler {
    var scheme: String { "https" }
    var baseUrl: String { "themealdb.com" }
    
    var method: RequestMethod { .GET }
    var body: [String: Any]? { nil }
    var queryItems: [URLQueryItem]? { nil }

    
    func asUrlRequest() throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseUrl
        urlComponents.path = path
        if let querys = queryItems {
            urlComponents.queryItems = querys
        }
        guard let url = urlComponents.url else {
            throw ApiError(errorCode: "ERROR-0", message: "URL error")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw ApiError(errorCode: "ERROR-1", message: "Body error")
            }
        }
        return urlRequest
    }
}
