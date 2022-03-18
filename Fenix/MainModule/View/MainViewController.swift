//
//  MainViewController.swift
//  Fenix
//
//  Created by ayaz akbar on 18/03/2022.
//


import UIKit


class MainViewController: UIViewController, UISearchBarDelegate {
    
    var presenter: MainViewPresenterProtocol!
    var cells: Movie?
    
    let menuBatton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "more"), for: .normal)
        button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        return button
    }()
    
    @objc func openMenu() {
        
    }
    
   
    
    
    let search : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .default
        searchBar.placeholder = "Search movie by title"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()
    
    
    
    
    let posterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .light)
        label.text = "Fenix Movies Poster"
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.scrollDirection = .vertical
       layout.minimumLineSpacing = Constants.galleryMinimumLineSpacing
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
       cv.translatesAutoresizingMaskIntoConstraints = false
       cv.showsHorizontalScrollIndicator = false
       cv.showsVerticalScrollIndicator = false
       cv.backgroundColor = .white
       cv.contentInset = UIEdgeInsets(top: 0, left: Constants.leftDistanceToView, bottom: 0, right: Constants.rightDistanceToView)
       cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseId)

       return cv
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.backgroundColor = UIColor.white
        setUpContraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        if textSearched.count > 2{
            presenter.getMovies( textSearched)
        }
            
        
    }
    
   
    
    func setUpContraints() {
        view.addSubview(search)
        view.addSubview(menuBatton)
        view.addSubview(posterLabel)
        view.addSubview(collectionView)
        search.delegate = self
        // SetUp Buttons
        
        menuBatton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBatton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        menuBatton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        menuBatton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true

    
        
        //SetUp Labels
        
        search.topAnchor.constraint(equalTo: menuBatton.bottomAnchor, constant: 15).isActive = true
        search.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        search.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        
        
        
        
        posterLabel.topAnchor.constraint(equalTo: search.bottomAnchor, constant: 10).isActive = true
        posterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        posterLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        
        
        //SetUP CollectionView
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: posterLabel.bottomAnchor, constant: 10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension MainViewController: MainViewProtocol {
    func success() {
        self.cells = presenter.movies
        collectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = presenter.movies?.results[indexPath.item]
        presenter.tapOnTheMovie(movie: movie)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.galleryItemWidth, height: view.frame.height / 2)
    }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.movies?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId, for: indexPath) as! MovieCollectionViewCell
        
        if cells?.results[indexPath.item].isFavouriteMovie == true {
            cell.likeImageView.image = UIImage(named: "likePressed")
        } else {
            cell.likeImageView.image = UIImage(named: "like")
        }
        
        cell.nameLabel.text = cells?.results[indexPath.item].title
        cell.smallDescriptionLabel.text = cells?.results[indexPath.item].overview
        cell.voteAverageLabel.text = String(cells?.results[indexPath.item].vote_average ?? 10.0)
        
        if let imageInfo = cells?.results[indexPath.item].poster_path {
            let url = "https://image.tmdb.org/t/p/w500/" + imageInfo
            if let unwrappedUrl = URL(string: url) {
                cell.mainImageView.downloaded(from: unwrappedUrl)
            }
        }
        
        return cell
    }
}








