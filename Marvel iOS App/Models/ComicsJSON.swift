//
//  CharacterJSON.swift
//  Marvel iOS App
//
//  Created by Fernando Celestrino on 29/06/22.
//

import Foundation

struct ComicStruct: Codable {
    let data: DataComicClass
}

struct DataComicClass: Codable {
    let results: [ResultComics]
}

struct ResultComics: Codable {
    let title: String?
    let description: String?
}
