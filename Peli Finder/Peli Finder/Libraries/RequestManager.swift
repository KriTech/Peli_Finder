//
//  RequestManager.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 18/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import Foundation

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
            urlString += "&query" + query
        }
        
        guard let url = URL(string: urlString) else { return }
        
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                completion(.failure(RequestError.connectionError))
                return
            }

            do {
                let moviesContainer = try JSONDecoder().decode(MoviesContainer.self, from: data)
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
    }
}
