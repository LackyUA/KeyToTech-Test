//
//  Comment.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/13/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import Foundation

struct Comment: Codable {
    
    // MARK: - Properties
    
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
    
}

// MARK: - Equatable protocol implementation

extension Comment: Equatable {
    
    static func ==(rhs: Comment, lhs: Comment) -> Bool {
        return rhs.id == lhs.id
    }
    
}
