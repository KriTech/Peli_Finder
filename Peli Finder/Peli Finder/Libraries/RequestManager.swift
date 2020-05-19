//
//  RequestManager.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 18/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import UIKit

typealias MovieRequestHandler = (Result<[Movie], Error>) -> Void

class RequestManager {
    private let endPointURL = "https://api.themoviedb.org/3"
    private let imagesEndPointURL = "https://image.tmdb.org/t/p"
    private let token = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwOWJmZTQwZGJmM2JkMjMzOGRmMjE1ZTU3MTNlZWI1MSIsInN1YiI6IjVlYmVkY2UzYmM4YWJjMDAyMWMzYTZmYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rv7oBfH6ZH6Zl6fYUdMi1trZdRZZlt0OhktKZvnFucI"
    private var currentSearchTask: URLSessionDataTask?
    static let shared = RequestManager()
    
    private init() {}
    
    
    func makeRequest(requestType: RequestType, query: String? = nil, completion: @escaping  MovieRequestHandler) {
        
        var urlString = endPointURL+requestType.rawValue
        if let query = query {
            urlString += "&query=" + query
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(RequestError.badURL))
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            self.currentSearchTask = nil
            guard let data = data else {
                completion(.failure(RequestError.connectionError))
                return
            }

            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let moviesContainer = try decoder.decode(MoviesContainer.self, from: data)
                completion(.success(moviesContainer.movies))
                return
            } catch {
                completion(.failure(RequestError.JSONParsing))
                return
            }
        }
        
        if let currentSearchTask = currentSearchTask {
            currentSearchTask.suspend()
            currentSearchTask.cancel()
            self.currentSearchTask = nil
        }
        
        if requestType == .movieSearch {
            currentSearchTask = dataTask
        }
        
        dataTask.resume()
    }
    
    
    func setOrDownloadImage(imageName: String?, in imageView: UIImageView) {
        guard let imageName = imageName else { return }
        let urlString = imagesEndPointURL + RequestType.thumbnailImage.rawValue + imageName
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { [weak imageView] (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView?.image = image
                }
            }
        }.resume()
    }
}

extension RequestManager {
    enum RequestType: String {
        case movieSearch = "/search/movie?language=es-MX"
        case feed = "/discover/movie?sort_by=popularity.desc&language=es-MX"
        case fullImage = "/original"
        case thumbnailImage = "/w342"
    }
    
    enum RequestError: Error {
        case connectionError
        case JSONParsing
        case badURL
    }
}
