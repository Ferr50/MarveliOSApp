//
//  Brain.swift
//  Marvel iOS App
//
//  Created by Fernando Celestrino on 30/06/22.
//

import Foundation
import UIKit
import CommonCrypto

struct Brain {
    
    func createURL(heroId: Int, type:String) -> String {
        
        let timeStamp = String(Date().timeIntervalSince1970)
        let hash = (timeStamp + authKeys.privateKey + authKeys.publicKey).md5
        let newURL = "https://gateway.marvel.com:443/v1/public/characters/\(heroId)/\(type)?ts=\(timeStamp)&apikey=\(authKeys.publicKey)&hash=\(hash)"
        
        return newURL
    }
    
    func createUrlAPI() -> String {
        
        let timeStamp = String(Date().timeIntervalSince1970)
        let hash = (timeStamp + authKeys.privateKey + authKeys.publicKey).md5
        let newURL = "https://gateway.marvel.com:443/v1/public/characters?ts=\(timeStamp)&apikey=\(authKeys.publicKey)&hash=\(hash)"
        
        return newURL
    }
    
    
    
    func changeImgName(path: String,type: String,ext: String) -> String {
        var newImgName = path+"/"+type+"."+ext
        newImgName.insert("s", at: newImgName.index(newImgName.startIndex, offsetBy: 4))
        return newImgName
    }
    
}



private struct authKeys {
    static let publicKey = "757a77fb3c2d113d4fdc48bee18b6320"
    static let privateKey = "e22430f7b4e105a99bf9eb1f49501d7a61de8d14"
}



extension UIImageView {
    func loadFrom(URLAddress: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: URLAddress) else {
                return
            }
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async { [weak self] in
                    if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                    }
                }
            }
        }
        
    }
}



extension Array {
    func object(at index: Int) -> Element? {
        guard index < count else {
            return nil
        }
        return self[index]
    }
}



extension String {
    var md5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let data = data(using: String.Encoding.utf8) {
            _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
