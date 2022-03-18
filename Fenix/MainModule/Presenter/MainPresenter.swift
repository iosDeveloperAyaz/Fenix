//
//  MainPresenter.swift
//  Fenix
//
//  Created by ayaz akbar on 18/03/2022.
//

import Foundation

protocol MainViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getMovies(_ search: String?)
    var movies: Movie? { get set }
    func tapOnTheMovie(movie: ResultPart?)
}

class MainPresenter: MainViewPresenterProtocol {
    
    var router: RouterProtocol?
    var movies: Movie?
    var networkService: NetworkServiceProtocol!
    weak var view: MainViewProtocol?
    
   
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getMovies("")
    }
    
    func tapOnTheMovie(movie: ResultPart?) {
        router?.showDetail(movie: movie, delegate: self)
     }
         
    func getMovies(_ search : String?) {
        
        if search == ""{
            networkService.downloadMovies { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        self.movies = movies
                        self.view?.success()
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            }
        }else{
            
            networkService.downloadMoviesBySearch(search: search!) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        self.movies = movies
                        print("hahahah")
                        self.view?.success()
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            }
        }
        
    }

    
  
    
   
    
    
    
    
}

extension MainPresenter: DetailViewDelegate {
    func favStateChanged(movie: ResultPart) {
        
        print("Movie \"\(movie.title!)\" fav state changed: \(movie.isFavouriteMovie)")
        
        guard let count = movies?.results.count else { return }
        
        for i in 0..<count {
            if movie.id == movies?.results[i].id {
                movies?.results[i] = movie
            }
        }
        
    }
}
