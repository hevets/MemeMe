//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Steve Henderson on 2016-08-16.
//  Copyright © 2016 Steve Henderson. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        memeImageView.contentMode = .ScaleAspectFit
        memeImageView.autoresizingMask = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        memeImageView.contentMode = .ScaleAspectFit
        memeImageView.autoresizingMask = .None
        
        self.invalidateIntrinsicContentSize()
        self.setNeedsUpdateConstraints()
    }

}
