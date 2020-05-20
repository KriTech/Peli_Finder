//
//  MovieDetailViewController.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 20/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    var movieViewModel: MovieViewModel? {
        didSet {
            RequestManager.shared.setOrDownloadImage(imageName: movieViewModel?.backdropImage, with: .fullImage, in: self.backdropImageView)
            RequestManager.shared.setOrDownloadImage(imageName: movieViewModel?.posterImage, with: .thumbnailImage, in: self.posterImageView)
            self.titleLabel.text = movieViewModel?.title
            self.releaseDateLabel.text = movieViewModel?.releaseDate
            self.descriptionLabel.text = movieViewModel?.description
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
        scrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        return scrollView
    }()
    private lazy var backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        self.scrollView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16).isActive = true
        
        
        return imageView
    }()
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.locations = [0.7,1]
        
        return gradientLayer
    }()
    private lazy var gradientContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.addSublayer(gradientLayer)
        
        self.scrollView.addSubview(view)
        view.topAnchor.constraint(equalTo: self.backdropImageView.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.backdropImageView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.backdropImageView.trailingAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: self.backdropImageView.heightAnchor, multiplier: 1).isActive = true
        self.scrollView.layoutSubviews()
        
        gradientLayer.frame = view.bounds
        
        return view
    }()
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        self.scrollView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.backdropImageView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2/3).isActive = true
        
        return imageView
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        
        self.scrollView.addSubview(label)
        label.topAnchor.constraint(equalTo: self.gradientContainerView.bottomAnchor, constant: 2).isActive = true
        label.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        
        return label
    }()
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        
        self.scrollView.addSubview(label)
        label.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.adjustsFontForContentSizeCategory = true
    
        
        self.scrollView.addSubview(label)
        label.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: 5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5).isActive = true
        label.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
    }
}
