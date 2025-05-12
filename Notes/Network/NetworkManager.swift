//
//  NetworkManager.swift
//  PawerfurNoteApp
//
//  Created by Janus on 2025/2/1.
//  Enhanced with token authentication
//

import Foundation

// Custom error types to handle various scenarios
enum NetworkError: Error {
    case urlError
    case decodingError(String)
    case serverError(String)
    case authenticationError(String)
    case unknownError
}

// API Error
struct ApiError: Decodable, Error {
    let statusCode: Int?
    let message: String?
    let error: String?
}

class NetworkManager {
    // Instantiate singleton instance
    static var shared = NetworkManager()
    
    // Authentication token storage
    private var accessToken: String?
    
    // Set the access token after successful login
    func setAccessToken(_ token: String) {
        self.accessToken = token
        // Also store in UserDefaults for persistence across app launches
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    
    // Retrieve token from UserDefaults if available
    func retrieveTokenIfNeeded() {
        if accessToken == nil {
            accessToken = UserDefaults.standard.string(forKey: "accessToken")
        }
    }
    
    // Clear token on logout
    func clearToken() {
        accessToken = nil
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
    
    // MARK: - GET REQUEST HELPER WITH AUTHENTICATION
    func getRequest<T: Decodable>(url: String) async throws -> T {
        // Ensure we have the latest token
        retrieveTokenIfNeeded()
        
        // Convert url endpoint to URL object
        guard let urlObject = URL(string: "http://\(apiDomain):\(url)") else {
            throw NetworkError.urlError
        }
        
        print("DECODE Url: \(urlObject)")
        
        // Create request with authentication header if token exists
        var request = URLRequest(url: urlObject)
        
        // Add authentication header if token exists
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Adding auth token to request")
        } else {
            print("Warning: No auth token available for authenticated request")
        }
        
        // Use async/await pattern to fetch data
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Print response status code for debugging
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknownError
            }
            
            print("Response status code: \(httpResponse.statusCode)")
            
            // Handle different HTTP status codes
            switch httpResponse.statusCode {
            case 200..<300:
                // Success - proceed with decoding
                break
            case 401:
                // Unauthorized - token issues
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Auth error response: \(responseString)")
                }
                throw NetworkError.authenticationError("Authentication failed. Please log in again.")
            case 400..<500:
                // Client errors
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Client error response: \(responseString)")
                }
                throw NetworkError.serverError("Request error: \(httpResponse.statusCode)")
            case 500..<600:
                // Server errors
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Server error response: \(responseString)")
                }
                throw NetworkError.serverError("Server error: \(httpResponse.statusCode)")
            default:
                // Unexpected status code
                throw NetworkError.unknownError
            }
            
            // Debug: Log raw response data
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(responseString)")
            }
            
            // Debug: Print pretty JSON if possible
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Pretty JSON Structure:")
                print(prettyString)
            }
            
            // Attempt to decode the data
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                print("Successfully decoded data")
                return decodedData
            } catch {
                print("Decoding error: \(error)")
                
                // Enhanced error reporting for debugging
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found at path: \(context.codingPath)")
                    case .typeMismatch(let type, let context):
                        print("Type '\(type)' mismatch at path: \(context.codingPath)")
                    case .valueNotFound(let type, let context):
                        print("Value of type '\(type)' not found at path: \(context.codingPath)")
                    case .dataCorrupted(let context):
                        print("Data corrupted at path: \(context.codingPath)")
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
                
                throw NetworkError.decodingError(error.localizedDescription)
            }
        } catch {
            print("Network or general error: \(error)")
            throw error
        }
    }
    
    // MARK: - POST REQUEST HELPER WITH AUTHENTICATION
    func postRequest<T: Encodable, U: Decodable>(url: String, payload: T, requiresAuth: Bool = false) async throws -> U {
        // Retrieve token if needed and authentication is required
        if requiresAuth {
            retrieveTokenIfNeeded()
        }
        
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
        
        // Add authentication header if required and token exists
        if requiresAuth, let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Adding auth token to POST request")
        } else if requiresAuth {
            print("Warning: Auth required but no token available")
        }
        
        // Attempt to encode JSON
        do {
            let jsonData = try JSONEncoder().encode(payload)
            print("[postRequest helper] encoded jsonData: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
            request.httpBody = jsonData // Set body of request with json data
        } catch {
            print("DEBUG error when encoding: \(error)")
            throw error
        }
        
        // Make post request with async/await
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Debug: Log raw response data
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw API Response: \(responseString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknownError
            }
            
            print("Response status code: \(httpResponse.statusCode)")
            
            // Handle different HTTP status codes
            switch httpResponse.statusCode {
            case 200..<300:
                // Success - proceed with decoding
                
                // Special handling for login response
                if url.contains("signin") {
                    do {
                        if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let resultDict = jsonObject["result"] as? [String: Any],
                           let accessToken = resultDict["accessToken"] as? String {
                            // Store the token for future authenticated requests
                            setAccessToken(accessToken)
                            print("✅ Successfully stored access token")
                        }
                    } catch {
                        print("⚠️ Failed to extract access token: \(error)")
                    }
                }
                
                // Attempt to decode data
                do {
                    let responseData = try JSONDecoder().decode(U.self, from: data)
                    return responseData
                } catch {
                    print("Failed to decode successful response: \(error)")
                    
                    // Enhanced error reporting for debugging
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("Key '\(key)' not found at path: \(context.codingPath)")
                        case .typeMismatch(let type, let context):
                            print("Type '\(type)' mismatch at path: \(context.codingPath)")
                        case .valueNotFound(let type, let context):
                            print("Value of type '\(type)' not found at path: \(context.codingPath)")
                        case .dataCorrupted(let context):
                            print("Data corrupted at path: \(context.codingPath)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                    }
                    
                    throw NetworkError.decodingError("Error decoding successful response")
                }
            case 401:
                // Unauthorized - token issues
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Auth error response: \(responseString)")
                }
                throw NetworkError.authenticationError("Authentication failed. Please log in again.")
            default:
                do {
                    let errorData = try JSONDecoder().decode(ApiError.self, from: data)
                    throw NetworkError.serverError(errorData.message ?? "Unknown server error")
                } catch {
                    throw NetworkError.decodingError("Error decoding error response")
                }
            }
        } catch {
            print("Network or general error in POST: \(error)")
            throw error
        }
    }
    
    // MARK: DELETE REQUEST HELPER WITH AUTHENTICATION
    func deleteRequest(url: String) async throws -> Data {
        // Ensure we have the latest token
        retrieveTokenIfNeeded()
        
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
        
        // Add authentication header if token exists
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Adding auth token to DELETE request")
        } else {
            print("Warning: No auth token available for authenticated request")
        }
        
        // Make delete request with async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Debug: Log raw response data
        if let responseString = String(data: data, encoding: .utf8) {
            print("Raw DELETE Response: \(responseString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknownError
        }
        
        // Handle different HTTP status codes
        switch httpResponse.statusCode {
        case 200..<300:
            // Success
            return data
        case 401:
            // Unauthorized - token issues
            throw NetworkError.authenticationError("Authentication failed. Please log in again.")
        default:
            throw NetworkError.serverError("Delete request failed with status code: \(httpResponse.statusCode)")
        }
    }
}
