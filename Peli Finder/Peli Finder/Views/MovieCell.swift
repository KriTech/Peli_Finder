//
//  MovieCell.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 14/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    static let identifier = "MovieCell"
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        self.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2/3).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        
        self.addSubview(label)
        label.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        
        self.addSubview(label)
        label.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        
        return label
    }()
    
    private lazy var adultContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        self.addSubview(label)
        label.centerYAnchor.constraint(equalTo: self.releaseDateLabel.centerYAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor).isActive = true
        
        return label
    }()
        
    var movieViewModel: MovieViewModel? {
        didSet {
            RequestManager.shared.setOrDownloadImage(imageName: movieViewModel?.posterImage, with: .thumbnailImage, in: self.posterImageView)
            self.titleLabel.text = movieViewModel?.title
            self.releaseDateLabel.text = movieViewModel?.releaseDate
            self.adultContentLabel.text = movieViewModel?.adultContent
            self.clipsToBounds = true
        }
    }

    override func prepareForReuse() {
        self.posterImageView.image = nil
        self.titleLabel.text = nil
        self.adultContentLabel.text = nil
        self.releaseDateLabel.text = nil
    }

}
