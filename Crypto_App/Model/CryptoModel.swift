//
//  CryptoModel.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 8.05.2024.
//

import Foundation

struct CryptoModel {
    var symbol: String
    var name: String
    var iconURL: URL?
    var imageData: Data?
    var price: String
    var change: String
    var sparkLines: [String]?
}
