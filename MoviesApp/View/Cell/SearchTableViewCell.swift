//
//  SearchTableViewCell.swift
//  MoviesApp
//
//  Created by Garima Saini on 2023-07-04.
//

import Foundation
import UIKit

//MARK: - SearchTableViewCell
class SearchTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.layer.cornerRadius = posterImage.frame.size.height * 0.08

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
