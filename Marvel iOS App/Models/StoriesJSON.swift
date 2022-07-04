//
//  StoriesJSON.swift
//  Marvel iOS App
//
//  Created by Fernando Celestrino on 29/06/22.
//

import Foundation

struct StoriesStruct: Codable {
    let data: DataStoriesClass
}

struct DataStoriesClass: Codable {
    let results: [ResultStories]
}

struct ResultStories: Codable {
    let title: String
    let description: String
}
