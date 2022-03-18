//
//  DetailViewController.swift
//  Fenix
//
//  Created by ayaz akbar on 18/03/2022.
//


import UIKit

protocol DetailViewDelegate {
    func favStateChanged(movie: ResultPart)
}

class DetailViewController: UIViewController {
    
    var delegate: DetailViewDelegate?
    
    var movie = ResultPart(isFavouriteMovie: false, title: "", vote_average: 0.0, id: 0, overview: "", release_date: "", poster_path: "")
    
    public var isFavorite = false {
        didSet {
            buttonPressed(isFavoriteMoovie: isFavorite)
        }
    }
    
    var presenter: DetailViewPresenterProtocol?
    
    lazy var movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "ЧП")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var selectFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like"), for: .normal)
        button.addTarget(self, action: #selector(changeFavorite), for: .touchUpInside)
        return button
    }()
    
    
    @objc private func changeFavorite() {
        isFavorite.toggle()
        
        movie.isFavouriteMovie = isFavorite
        delegate?.favStateChanged(movie: movie)
    }
    
    func buttonPressed(isFavoriteMoovie: Bool) {
           
           if isFavoriteMoovie {
               selectFavoriteButton.setImage(UIImage(named:"likePressed"), for: .normal)
           } else {
               selectFavoriteButton.setImage(UIImage(named:"like"), for: .normal)
           }
       }

    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Moovie"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.backgroundColor = .white
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.backgroundColor = .white
        
        return label
    }()
    
    let rateView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let likeView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let buttonBack: UIView = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25
        button.setImage(UIImage(named: "back"), for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(backButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func backButton() {
        presenter?.undo()
    }
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textColor = .black
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Moovie"
        self.navigationItem.largeTitleDisplayMode = .always
        self.view.backgroundColor = UIColor(named: "Background")
        presenter?.setMovie()
        setupViews()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          navigationController?.setNavigationBarHidden(true, animated: true)
      }

    
    func setupViews() {
        nameLabel.text = movie.title
        rateLabel.text = String(movie.vote_average ?? 10.0)
        infoLabel.text = movie.overview
        
        DispatchQueue.main.async {
            if let imageInfo = self.movie.poster_path {
                let url = "https://image.tmdb.org/t/p/w500/" + imageInfo
                if let unwrappedUrl = URL(string: url) {
                    self.movieImage.downloaded(from: unwrappedUrl)
                }
            }
            
        }
    }
    
    func setupConstraints() {
        
        view.addSubview(infoLabel)
        view.addSubview(movieImage)
        view.addSubview(buttonBack)
        view.addSubview(nameLabel)
        view.addSubview(likeView)
        likeView.addSubview(selectFavoriteButton)
        view.addSubview(rateView)
        rateView.addSubview(rateLabel)
        view.addSubview(buttonBack)
        
        
        movieImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        movieImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        movieImage.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        movieImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/2).isActive = true
        
        
        likeView.centerYAnchor.constraint(equalTo: buttonBack.centerYAnchor).isActive = true
        likeView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        likeView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        likeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        selectFavoriteButton.centerYAnchor.constraint(equalTo: likeView.centerYAnchor).isActive = true
        selectFavoriteButton.centerXAnchor.constraint(equalTo: likeView.centerXAnchor).isActive = true
        selectFavoriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        selectFavoriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        nameLabel.leftAnchor.constraint(equalTo: self.movieImage.leftAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.movieImage.bottomAnchor, constant: -40).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.movieImage.widthAnchor, multiplier: 1/2).isActive = true
        
        buttonBack.centerXAnchor.constraint(equalTo: rateView.centerXAnchor).isActive = true
        buttonBack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        buttonBack.widthAnchor.constraint(equalToConstant: 60).isActive = true
        buttonBack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        rateView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        rateView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        rateView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        rateView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        rateLabel.centerXAnchor.constraint(equalTo: rateView.centerXAnchor).isActive = true
        rateLabel.centerYAnchor.constraint(equalTo: rateView.centerYAnchor).isActive = true
        
        
        infoLabel.topAnchor.constraint(equalTo: self.movieImage.bottomAnchor, constant: 12).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: +20)
            .isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
    }
    
    
    
    
}

extension DetailViewController: DetailViewProtocol {
    func setMovie(movie: ResultPart) {
        self.movie = movie
    }
    
}
