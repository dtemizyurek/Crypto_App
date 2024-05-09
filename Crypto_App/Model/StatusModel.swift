//
//  StatusModel.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 9.05.2024.
//

import Foundation

struct StatusModel {
    let status: Status
}

enum Status: String {
    case price = "Price"
    case marketCap = "Market Cap"
    case volume24h = "24h Volume"
    case change = "Change"
    case listedAt = "Listed At"
}
