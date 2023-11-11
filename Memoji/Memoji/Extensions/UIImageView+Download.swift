//
//  UIImageView+Download.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 07/11/23.
//

import UIKit

extension UIImageView {
    
    func download(from url: URL) {
        
        if let cachedImage = CacheImage.cache.imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        contentMode = .scaleAspectFit
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse,
                  httpURLResponse.statusCode == 200,
                  let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async() {
                self.image = image
                CacheImage.cache.imageCache.setObject(image, forKey: url as AnyObject)
            }
        }.resume()
    }
}
