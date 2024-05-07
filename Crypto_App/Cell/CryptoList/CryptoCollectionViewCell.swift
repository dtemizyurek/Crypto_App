//
//  CryptoCollectionViewCell.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 7.05.2024.
//

import UIKit

class CryptoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    private func configure(with cryptoModel: Crypto) {
        shortNameLabel.text = cryptoModel.data.coins[0].symbol
        nameLabel.text = cryptoModel.data.coins[0].name
        priceLabel.text = cryptoModel.data.coins[0].price
        changeLabel.text = cryptoModel.data.coins[0].change
        
        if let iconURL = URL(string: cryptoModel.data.coins[0].iconURL) {
            cryptoImage.load(from: iconURL)
        } else {
            cryptoImage.image = UIImage(systemName: "person.fill")
        }
    }

}
