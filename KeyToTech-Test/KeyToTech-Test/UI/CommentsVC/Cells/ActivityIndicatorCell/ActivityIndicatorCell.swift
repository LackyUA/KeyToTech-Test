//
//  ActivityIndicatorCell.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/14/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

/// Table view cell for displaying activity indicator.
class ActivityIndicatorCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            self.activityIndicator.startAnimating()
        }
    }
    
    // MARK: - Life cycle
    
    override func prepareForReuse() {
        activityIndicator.startAnimating()
    }
    
}
