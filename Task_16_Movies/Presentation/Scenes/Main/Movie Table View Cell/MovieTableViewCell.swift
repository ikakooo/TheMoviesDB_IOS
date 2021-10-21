//
//  MovieTableViewCell.swift
//  Task_16_Movies
//
//  Created by MacBook Pro on 21.10.21.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var reitingStars: UIButton!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieIMG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with: Movie){
        
        
        print("iakaooooo")
        print(with)
        movieName.text = with.title
        reitingStars.setAllStatesTitle("\(String(describing: with.voteAverage ?? 0))")
        loadIMGFromInternet(ImgURL: MovieConstants.BASE_IMG_URL + (with.posterPath ?? ""))
    }
    
    
    func loadIMGFromInternet(ImgURL:String){
        let url = URL(string: ImgURL)
        let processor = DownsamplingImageProcessor(size: movieIMG.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        movieIMG.kf.indicatorType = .activity
        movieIMG.kf.setImage(
            with: url,
            placeholder: UIImage(named: "movie"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
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
