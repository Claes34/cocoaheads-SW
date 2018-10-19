//
//  MovieTableViewCell.swift
//  Star Wars Movies
//
//  Created by Nicolas Fontaine on 15/10/2018.
//  Copyright © 2018 Nicolas Fontaine. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let customSelectedBGView = UIView()
        customSelectedBGView.backgroundColor = #colorLiteral(red: 1, green: 0.7486202346, blue: 0.1792230156, alpha: 1)
        selectedBackgroundView = customSelectedBGView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
