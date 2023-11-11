//
//  CacheImage.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import Foundation

final class CacheImage: NSObject {
    
    static let cache = CacheImage()
    let imageCache = NSCache<AnyObject, AnyObject>()
}
