//
//  ModelOfJSON.swift
//  Marvel iOS App
//
//  Created by Fernando Celestrino on 26/06/22.
//

import Foundation

struct ModalStruct: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let results: [Result]
}

struct Result: Codable {
    let name: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let path: String
    let `extension`: String
}
