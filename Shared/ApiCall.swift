//
//  ApiCall.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//

import Foundation

public enum APIError: Error {
   case internalError
   case serverError
   case parsingError
}
enum Constants {}
extension Constants {
   // MARK: Constants
   // Get an API key from https://developers.giphy.com/dashboard/
   static let giphyApiKey = "XbMKr0q0vnZMyi1ljDgUZML8U6oCbO1N"
   //static let screenSize = UIScreen.main.bounds.size
   
   static let https = "https://api.giphy.com/v1/gifs/"
   static let trending = "trending"
   static let searchGif = "q"
   static let search = "search"
   static let limitNum = "7"
   static let limit = "limit"
   static let rating = "g"
   static let lang = "en"
}

private struct Domain {
   static let scheme = "https"
   static let host = "api.giphy.com"
   static let path = "/v1/gifs/"
}
class ApiLoader {
   
   private func createUrl(urlParams: [String:String], gifacces: String?) -> URLRequest {
      var queryItems = [URLQueryItem]()
      queryItems.append(URLQueryItem(name: "api_key", value: Constants.giphyApiKey))
      for (key,value) in urlParams {
         queryItems.append(URLQueryItem(name: key, value: value))
      }
      
      var components = URLComponents()
      components.scheme = Domain.scheme
      components.host = Domain.host
      components.path = Domain.path+gifacces!
      components.queryItems = queryItems.isEmpty ? nil : queryItems
      guard let url = components.url else { preconditionFailure("Bad URL") }
      debugPrint(url.absoluteString)
      
      let request = URLRequest(url: url)
      return request
   }
   
   func fetchAPI<T: Codable>(urlParams: [String:String], gifacces: String?) async throws -> T {
      let task = Task { () -> T in
         try await fetchAndDecode(url: createUrl(urlParams: urlParams, gifacces: gifacces).url!)
      }
      return try await task.value
   }
   func fetchAndDecode<T: Codable>(url: URL) async throws -> T {
      let data = try await URLSession.shared.data(with: url)
      let decodedData = try JSONDecoder().decode(T.self, from: data)
      return decodedData
   }
   
   deinit{
      debugPrint("ApiLoader deinit")
   }
}

extension URLSession {
   func data(with url: URL) async throws -> Data {
      try await withCheckedThrowingContinuation { continuation in
         dataTask(with: url) { data, _, error in
            if let error = error {
               continuation.resume(throwing: error)
            } else if let data = data {
               continuation.resume(returning: data)
            } else {
               continuation.resume(throwing: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Bad Response"]))
            }
         }
         .resume()
      }
   }
}
