//
//  NetworkService.swift
//  Fenix
//
//  Created by ayaz akbar on 18/03/2022.
//
import Foundation

protocol NetworkServiceProtocol {
    func downloadMovies(completionHandler: @escaping ((Result<Movie, Error>) -> Void))
    func downloadMoviesBySearch(search: String,completionHandler: @escaping((Result<Movie, Error>) -> Void))

}

class NetworkService: NetworkServiceProtocol {
    func downloadMovies(completionHandler: @escaping ((Result<Movie, Error>) -> Void)) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=ae304e3f4d3830d95075ae6914b55ddf") else { return }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                guard let data = data else { return }
                let moovieData = try JSONDecoder().decode(Movie.self, from: data)
                print(moovieData)
                completionHandler(.success(moovieData))
            }
                
            catch let jsonError {
                print(jsonError)
                completionHandler(.failure(jsonError))
            }
        }
        
        task.resume()
        
        
    }
    
   
    func downloadMoviesBySearch(search : String, completionHandler: @escaping ((Result<Movie, Error>) -> Void)) {
        
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=ae304e3f4d3830d95075ae6914b55ddf&query=\(search)") else { return }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                guard let data = data else { return }
                let moovieData = try JSONDecoder().decode(Movie.self, from: data)
                print(moovieData)
                completionHandler(.success(moovieData))
            }
                
            catch let jsonError {
                print(jsonError)
                completionHandler(.failure(jsonError))
            }
        }
        
        task.resume()
        
        
    }
    
    
    
    
}
