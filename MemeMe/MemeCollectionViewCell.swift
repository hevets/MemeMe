//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Steve Henderson on 2016-08-16.
//  Copyright © 2016 Steve Henderson. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setText(topText:String, bottomText:String) {
        self.topLabel.tintColor = UIColor.blackColor()
        self.bottomLabel.tintColor = UIColor.blackColor()
        self.topLabel.text = topText
        self.bottomLabel.text = bottomText
    }
}
