//
//  NetworkManager.swift
//  PawerfurNoteApp
//
//  Created by Janus on 2025/2/1.
//
//
//  NetworkManager.swift
//  PawerfurNoteApp
//
//  Created by Janus on 2025/2/1.
//  Refactored to use async/await pattern
//

import Foundation

// Custom error types to handle various scenarios
enum NetworkError: Error {
    case urlError
    case decodingError(String)
    case serverError(String)
    case unknownError
}

// API Error
struct ApiError: Decodable, Error {
    let statusCode: Int
    let message: String
    let error: String
}

class NetworkManager {
    // Instantiate singleton instance
    static var shared = NetworkManager()
    
    // MARK: - GET REQUEST HELPER
    func getRequest<T: Decodable>(url: String) async throws -> T {
        // Convert url endpoint to URL object
        guard let urlObject = URL(string: "http://\(apiDomain):\(url)") else {
            throw NetworkError.urlError
        }
        
        print("DECODE Url: \(urlObject)")
        
        // Use async/await pattern to fetch data
        do {
            let (data, _) = try await URLSession.shared.data(from: urlObject)
            
            // Attempt to decode the data
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            print("decodedDataJsonData: \(decodedData)")
            
            return decodedData
        } catch {
            print("DEBUG: Error occurred during GET request: \(error)")
            
            // If decoding fails, throw appropriate error
            if let decodingError = error as? DecodingError {
                throw NetworkError.decodingError(decodingError.localizedDescription)
            }
            
            throw error
        }
    }
    
    // MARK: - POST REQUEST HELPER
    func postRequest<T: Encodable, U: Decodable>(url: String, payload: T) async throws -> U {
        // Guard against any unaccepted url strings and create URL object
        guard let urlObj = URL(string: "http://\(apiDomain):\(url)") else {
            throw NetworkError.urlError
        }
        
        print("DECODE Url: \(urlObj)")
        
        // Create a URLRequest object
        var request = URLRequest(url: urlObj)
        
        // Set http method to POST
        request.httpMethod = "POST"
        
        // Set Content-Type headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Attempt to encode JSON
        do {
            let jsonData = try JSONEncoder().encode(payload)
            print("[postRequest helper] encoded jsonData: \(jsonData)")
            request.httpBody = jsonData // Set body of request with json data
        } catch {
            print("DEBUG error when encoding: \(error)")
            throw error
        }
        
        // Make post request with async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        // Use the http status code to determine whether or not completion was a success
        switch httpResponse.statusCode {
        case 200, 201:
            // Attempt to decode data
            do {
                let responseData = try JSONDecoder().decode(U.self, from: data)
                return responseData
            } catch {
                throw NetworkError.decodingError("Error decoding successful response")
            }
        default:
            do {
                let errorData = try JSONDecoder().decode(ApiError.self, from: data)
                throw NetworkError.serverError(errorData.message)
            } catch {
                if let networkError = error as? NetworkError {
                    throw networkError
                }
                throw NetworkError.decodingError("Error decoding error response")
            }
        }
    }
    
    // MARK: - DELETE REQUEST HELPER
    func deleteRequest(url: String) async throws -> Data {
        print("Delete request with: \(url)")
        
        // Guard against any unaccepted url strings and create URL object
        guard let url = URL(string: "http://\(apiDomain):3000\(url)") else {
            throw NetworkError.urlError
        }
        
        // Create a URLRequest object
        var request = URLRequest(url: url)
        
        // Set http method to DELETE
        request.httpMethod = "DELETE"
        
        // Set Content-Type headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make delete request with async/await
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
