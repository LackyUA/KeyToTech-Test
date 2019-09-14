//
//  CommentCell.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/13/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

/// Table view cell for displaying comment.
final class CommentCell: UITableViewCell {

    // MAKR: - IBOutlets
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    
    // MARK: - Configuration
    
    /// Initial UI configuration
    func configure(with data: Comment) {
        nameLabel.text = data.name
        emailLabel.text = data.email
        commentLabel.text = data.body
    }
    
}
