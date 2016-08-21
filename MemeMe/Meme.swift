//
//  Meme.swift
//  MemeMe
//
//  Created by Steve Henderson on 2016-05-17.
//  Copyright © 2016 Steve Henderson. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText:String
    let bottomText:String
    let image:UIImage
    let memedImage:UIImage

    func getDisplayText() -> String {
        return topText + "..." + bottomText
    }
}

