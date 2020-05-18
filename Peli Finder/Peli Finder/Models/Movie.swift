//
//  Movie.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 18/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import Foundation

struct MoviesContainer: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
    
    let movies: [Movie]
}

struct Movie: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id, title
        case movieDescription = "overview"
        case backdropImage = "backdrop_path"
        case posterImage = "poster_path"
        case adultOnly = "adult"
    }
    
    let id: Int
    let title: String
    let movieDescription: String
    let adultOnly: Bool?
    let backdropImage: String?
    let posterImage: String?
}
