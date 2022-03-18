//
//  DetailPresenter.swift
//  Fenix
//
//  Created by ayaz akbar on 18/03/2022.
//


import Foundation

protocol DetailViewProtocol: class {
    func setMovie(movie: ResultPart)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, movie: ResultPart, router: RouterProtocol)
    func setMovie()
    func undo()
}

class DetailPresenter: DetailViewPresenterProtocol {
  
    var router: RouterProtocol?
    weak var view: DetailViewProtocol?
    var movie: ResultPart?
    
    required init(view: DetailViewProtocol, movie: ResultPart, router: RouterProtocol) {
        self.view = view
        self.movie = movie
        self.router = router
    }
    
    func setMovie() {
        guard let result = movie else { return }
        self.view?.setMovie(movie: result)
    }
    
    func undo() {
        router?.popToRoot()
    }
      
}
