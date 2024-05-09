//
//  DetailViewController.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 9.05.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var cryptoNameLabel: UILabel!
    @IBOutlet private weak var cryptoPrice: UILabel!
    @IBOutlet private weak var cryptoChange: UILabel!
    @IBOutlet private weak var highPriceLabel: UILabel!
    @IBOutlet private weak var lowPriceLabel: UILabel!
    @IBOutlet private weak var currentPriceView: UIView!
    @IBOutlet private weak var highLowView: UIView!
    @IBOutlet private weak var cryptoImage: UIImageView!
    @IBOutlet private weak var cryptoChangeImage: UIImageView!
    
    //MARK: - private Variables
    var cryptoModel: CryptoModel!
    private var highestPrice: Float?
    private var lowestPrice: Float?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels(with: cryptoModel)
        applyCornerRadius()
        findHighestLowestPrices()
    }
    
    //MARK: - Private Functions
    private func updateLabels(with cryptoModel: CryptoModel) {
        cryptoNameLabel.text = cryptoModel.name
        cryptoPrice.text = cryptoModel.price
        cryptoChange.text = cryptoModel.change
        
        if let imageData = cryptoModel.imageData {
            cryptoImage.image = UIImage(data: imageData)
        } else {
            print("Image data is nil")
        }
        
        guard let changeText = cryptoChange.text else { return }
        if changeText.hasPrefix("-") {
            cryptoChange.textColor = .systemRed
            cryptoChangeImage.image = UIImage(systemName: "arrow.down.circle.fill")
            cryptoChangeImage.tintColor = .systemRed
        } else {
            cryptoChange.textColor = .systemGreen
            cryptoChangeImage.image = UIImage(systemName: "arrow.up.circle.fill")
            cryptoChangeImage.tintColor = .systemGreen
        }
    }
    
    private func applyCornerRadius() {
        currentPriceView.layer.cornerRadius = 20
        highLowView.layer.cornerRadius = 20
    }
    
    private func findHighestLowestPrices() {
        guard let sparkLines = cryptoModel.sparkLines else {
            return
        }
        
        highestPrice = Float(sparkLines[0])
        lowestPrice = Float(sparkLines[0])
        
        for i in 1 ..< sparkLines.count {
            if let currentPrice = Float(sparkLines[i]) {
                if currentPrice > highestPrice! {
                    highestPrice = currentPrice
                }
                if currentPrice < lowestPrice! {
                    lowestPrice = currentPrice
                }
            }
        }
        if let highPriceLabel = highPriceLabel, let lowPriceLabel = lowPriceLabel {
            highPriceLabel.text = "High: \(highestPrice ?? 0)"
            highPriceLabel.textColor = .systemGreen
            lowPriceLabel.text = "Low: \(lowestPrice ?? 0)"
            lowPriceLabel.textColor = .systemRed
        } else {
            print("One of the labels is nil.")
        }
    }
}

