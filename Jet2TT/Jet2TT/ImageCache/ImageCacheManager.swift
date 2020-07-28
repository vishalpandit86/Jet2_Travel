//
//  ImageCacheManager.swift
//  Jet2TT
//
//  Created by Vishal Pandit on 27/07/20.
//  Copyright © 2020 Vishal. All rights reserved.
//

import Foundation
import UIKit

final class ImageCacheManager {

    static let imageCache = NSCache<NSString, UIImage>()

    static let imageQueue = DispatchQueue(label: "imageQueue", qos: .background)

    class func loadImage(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let image = Self.imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                completion(image)
            }
        }  else {
            Self.imageQueue.async {
                let url = URL(string: urlString)
                URLSession.shared.dataTask(with: url! as URL, completionHandler: { (data, response, error) -> Void in

                    if error != nil {
                        print(error ?? "error")
                        completion(nil)
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        if let image = UIImage(data: data!) {
                            Self.imageCache.setObject(image, forKey: urlString as NSString)
                            DispatchQueue.main.async {
                                completion(image)
                            }
                        }
                    })
                }).resume()
            }
        }
    }
}
