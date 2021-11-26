//
//  ViewController.swift
//  Task_16_Movies
//
//  Created by MacBook Pro on 21.10.21.
//

import UIKit
import SkeletonView

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
        movieTableView.rowHeight = UITableView.automaticDimension
        movieTableView.estimatedRowHeight = UIScreen.main.bounds.height / 3
        
        
        movieTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
        movieTableView.dataSource = self
        movieTableView.delegate = self
        
        
        print("ikakooo")
        
        
        networkManager = NetworkManager()
        // DI - Dependenc injection
        movieManager = MoviesDataManager(networkManager: networkManager)
        
        movieManager.getMovies(page: 1 ) { movies in
            self.movies = movies.results ?? []
            // print(movies)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
//                self.movieTableView.isSkeletonable = true
//                self.movieTableView.showAnimatedGradientSkeleton()
//                self.movieTableView.stopSkeletonAnimation()
//                self.movieTableView.hideSkeleton()
                self.movieTableView.stopSkeletonAnimation()
                self.movieTableView.hideSkeleton()
                self.movieTableView.reloadData()
            })
            
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
//            self.movieTableView.stopSkeletonAnimation()
//            self.movieTableView.hideSkeleton()
//            self.movieTableView.reloadData()
//        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        movieTableView.isSkeletonable = true
        movieTableView.mySkeletonAnimation()
        movieTableView.reloadData()
    }
    
    
}

extension MainViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        MovieTableViewCell.identifier
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
//        cell.mySkeletonAnimation()
//        cell.movieName.mySkeletonAnimation()
        cell.movieName.isHidden = indexPath.row == 0
        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {
        let cell = cell as? MovieTableViewCell
        cell?.movieName.mySkeletonAnimation()
        //cell?.movieName.isHidden = indexPath.row == 0
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

extension UIView {
    func mySkeletonAnimation(){
        self.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .gray, secondaryColor: .white), animation: nil, transition: .crossDissolve(0.25))
    }
}
