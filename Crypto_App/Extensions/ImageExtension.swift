//
//  Image + Extension.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 8.05.2024.
//

import UIKit

extension UIImageView {
    func load(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                    completion?(image)
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = nil
                    completion?(nil)
                }
            }
        }
    }
}
