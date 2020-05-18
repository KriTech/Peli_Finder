//
//  MovieViewModel.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 18/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import Foundation


struct MovieViewModel {
    
    let id: Int
    let title: String
    let description: String
    let backdropImage: String?
    let posterImage: String?
    let adultContent: String
    
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.description = movie.movieDescription
        self.backdropImage = movie.backdropImage
        self.posterImage = movie.posterImage
        self.adultContent = movie.adultOnly ?? false ? "+18" : ""
    }
}
