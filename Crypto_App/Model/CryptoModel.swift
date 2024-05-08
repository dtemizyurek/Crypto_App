//
//  CryptoModel.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 8.05.2024.
//

import Foundation

struct CryptoModel {
    let symbol: String
    let name: String
    var iconURL: URL?
    var imageData: Data?
    let price: String
    let change: String
    var sparkLines: [String]?
}
