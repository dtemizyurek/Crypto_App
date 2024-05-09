//
//  CryptoRequest.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 7.05.2024.
//

import Foundation

struct CryptoRequest {
    
    static let shared = CryptoRequest()
    
    public func getAllData(completion: @escaping (Result<[Coin], Error>) -> Void) {
        guard let url = Constants.topHeadLinesURL else {
            completion(.failure(NSError(domain: "CryptoRequest", code: 0, userInfo: [NSLocalizedDescriptionKey: "Geçersiz URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "CryptoRequest", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sunucu hatası"])))
                return
            }
            
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(Crypto.self, from: data)
                    completion(.success(result.data.coins))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func getImageData(from url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to fetch image data:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}

