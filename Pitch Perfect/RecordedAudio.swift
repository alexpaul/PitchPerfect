//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Alex Paul on 6/6/15.
//  Copyright (c) 2015 Alex Paul. All rights reserved.
//

import Foundation


class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    // Custom Initializer
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}