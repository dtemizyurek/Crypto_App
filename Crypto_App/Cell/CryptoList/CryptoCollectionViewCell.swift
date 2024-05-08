//
//  CryptoCollectionViewCell.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 7.05.2024.
//

import UIKit

final class CryptoCollectionViewCell: UICollectionViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    //MARK: - Variables
    static let identifier = "CryptoCollectionViewCell"
    
    //MARK: - Awake From Nib
    override func awakeFromNib() {
    super.awakeFromNib()
        customizeView()
    }
    
    //MARK: - Private functions
    public func configure(with cryptoModel: CryptoModel) {
        shortNameLabel.text = cryptoModel.symbol
        nameLabel.text = cryptoModel.name
        priceLabel.text = cryptoModel.price
        changeLabel.text = cryptoModel.change
        
        if let data = cryptoModel.imageData {
            cryptoImage.image = UIImage(data: data)
        }
        else if let url = cryptoModel.iconURL {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.cryptoImage.image = UIImage(data: data)
                }
            }.resume()
        }
        decideChangeColor(label: changeLabel)
    }
    
    public func decideChangeColor (label: UILabel) {
        guard let change = label.text?.hasPrefix("-") else {
            return
        }
        
        if change {
            changeLabel.textColor = .systemRed
        } else {
            changeLabel.textColor = .systemGreen
        }
    }
    
    private func customizeView() {
        
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
}
