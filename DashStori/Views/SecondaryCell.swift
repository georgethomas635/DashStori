//
//  SecondaryCell.swift
//  DashStori
//
//  Created by George on 06/04/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit

class SecondaryCell: UITableViewCell {

    @IBOutlet weak var storyStatus: UILabel!
    @IBOutlet weak var documentCount: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    @IBOutlet weak var imageCount: UILabel!
    @IBOutlet weak var storiTitle: UILabel!
    @IBOutlet weak var publishedOn: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var storiDescription: UILabel!
    @IBOutlet weak var storiName: UILabel!
    @IBOutlet weak var coverPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
