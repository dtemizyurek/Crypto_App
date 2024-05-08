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
    @IBOutlet weak var cryptoShortName: UILabel!
    @IBOutlet weak var cryptoName: UILabel!
    @IBOutlet weak var cryptoPrice: UILabel!
    @IBOutlet weak var cryptoChange: UILabel!
    
    //MARK: - Variables
    static let identifier = "CryptoCollectionViewCell"
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    //MARK: - Private functions
    public func configure(with cryptoModel: CryptoModel) {
        cryptoShortName.text = cryptoModel.symbol
        cryptoName.text = cryptoModel.name
        cryptoPrice.text = cryptoModel.price
        cryptoChange.text = cryptoModel.change
        
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
        decideChangeColor(label: cryptoChange)
    }
    
    public func decideChangeColor (label: UILabel) {
        guard let change = label.text?.hasPrefix("-") else {
            return
        }
        if change {
            cryptoChange.textColor = .systemRed
        } else {
            cryptoChange.textColor = .systemGreen
        }
    }
    
    private func customizeView() {
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
    }
}
