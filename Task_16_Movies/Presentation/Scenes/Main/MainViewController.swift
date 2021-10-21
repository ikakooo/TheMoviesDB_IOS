//
//  ViewController.swift
//  Task_16_Movies
//
//  Created by MacBook Pro on 21.10.21.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var movieTableView: UITableView!
    
    private var networkManager: NetworkManagerProtocol!
    private var movieManager: MoviesDataManager!
    
    private var movies:[Movie] = []
    private var page = 1
    fileprivate var cellIndexPathRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        
        print("ikakooo")
        networkManager = NetworkManager()
        // DI - Dependenc injection
        movieManager = MoviesDataManager(networkManager: networkManager)
        
        movieManager.getMovies(page: 1 ) { movies in
            self.movies = movies.results ?? []
            // print(movies)
            
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
            
        }
    }
    
    
    
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        
        if (indexPath.row == movies.count-1 && 500 > indexPath.row){
            movieManager.getMovies(page: page ) { movies in
                self.movies.append(contentsOf:movies.results ?? [])
                // print(movies)
                
                DispatchQueue.main.async {
                    self.movieTableView.reloadData()
                }
                self.page+=1
            }
        }
        return cell
    }
}

extension MainViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellIndexPathRow = indexPath.row
        performSegue(withIdentifier: "MovieFullScreenViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewControler =   segue.destination as? MovieFullScreenViewController
        viewControler?.movie = movies[cellIndexPathRow]
        print("taskkkkkkkk \(cellIndexPathRow)")
    }
    
}
