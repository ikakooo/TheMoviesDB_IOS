//
//  MovieFullScreenViewController.swift
//  Task_16_Movies
//
//  Created by MacBook Pro on 21.10.21.
//

import UIKit
import Kingfisher

class MovieFullScreenViewController: UIViewController {
    @IBOutlet weak var filmName: UILabel!
    @IBOutlet weak var reitingStars: UIButton!
    @IBOutlet weak var filmdescription: UILabel!
    @IBOutlet weak var moviePhoto: UIImageView!
    
    
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("movie")
        // Do any additional setup after loading the view.
        reitingStars.setAllStatesTitle("\(String(describing: movie?.voteAverage ?? 0))")
        filmName.text = movie?.title
        filmdescription.text = movie?.overview
        loadIMGFromInternet(ImgURL:MovieConstants.BASE_IMG_URL + (movie?.posterPath ?? ""))
    }
    

    func loadIMGFromInternet(ImgURL:String){
        let url = URL(string: ImgURL)
        let processor = DownsamplingImageProcessor(size: moviePhoto.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 0)
        moviePhoto.kf.indicatorType = .activity
        moviePhoto.kf.setImage(
            with: url,
            placeholder: UIImage(named: "movie"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }

}
