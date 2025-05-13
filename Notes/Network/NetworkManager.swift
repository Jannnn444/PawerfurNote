//
//  NetworkManager.swift
//  PawerfurNoteApp
//
//  Created by Janus on 2025/2/1.
//  Updated with async/await pattern
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
    // instantiate singleton instance
    static var shared = NetworkManager()
    
    // Base domain property (assuming it was defined elsewhere in original code)
    private let apiDomain = "206.189.40.30" // Replace with your actual domain if different
    
    // MARK: - GET REQUEST HELPER
    func fetchData<T: Decodable>(from endpoint: String) async throws -> T {
        // Convert url endpoint to URL object
        guard let urlObject = URL(string: "http://\(apiDomain):\(endpoint)") else {
            throw NetworkError.urlError
        }
        
        print("DECODE Url: \(urlObject)")
        
        // Use the newer async/await API for data tasks
        let (data, response) = try await URLSession.shared.data(from: urlObject)
        
        // Check HTTP response status
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            // Try to decode error response if possible
            do {
                let errorData = try JSONDecoder().decode(ApiError.self, from: data)
                throw NetworkError.serverError(errorData.message)
            } catch {
                throw NetworkError.serverError("Server returned an error")
            }
        }
        
        // Attempt to decode the data
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            print("decodedData: \(decodedData)")
            return decodedData
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
    
    // MARK: - POST REQUEST HELPER
    func postData<T: Encodable, U: Decodable>(to endpoint: String, payload: T) async throws -> U {
        // Guard against any unaccepted url strings and create URL object
        guard let urlObj = URL(string: "http://\(apiDomain):\(endpoint)") else {
            throw NetworkError.urlError
        }
        
        print("DECODE Url: \(urlObj)")
        
        // Create a URLRequest object
        var request = URLRequest(url: urlObj)
        
        // Set HTTP method to POST
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
        
        // Make the request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        // Use the HTTP status code to determine whether or not the completion was a success
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
                throw NetworkError.decodingError("Error decoding error response")
            }
        }
    }
    
    // MARK: DELETE REQUEST HELPER
    func deleteData(at endpoint: String) async throws -> Data {
        print("Delete request with: \(endpoint)")
        
        // Guard against any unaccepted url strings and create URL object
        guard let url = URL(string: "http://\(apiDomain):3000\(endpoint)") else {
            throw NetworkError.urlError
        }
        
        // Create a URLRequest object
        var request = URLRequest(url: url)
        
        // Set HTTP method to DELETE
        request.httpMethod = "DELETE"
        
        // Set Content-Type headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check HTTP response status
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            // Try to decode error response if possible
            do {
                let errorData = try JSONDecoder().decode(ApiError.self, from: data)
                throw NetworkError.serverError(errorData.message)
            } catch {
                throw NetworkError.serverError("Server returned an error")
            }
        }
        
        return data
    }
}
