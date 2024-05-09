//
//  DetailViewController.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 9.05.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var cryptoPrice: UILabel!
    @IBOutlet private weak var cryptoChange: UILabel!
    @IBOutlet private weak var highPriceLabel: UILabel!
    @IBOutlet private weak var lowPriceLabel: UILabel!
    @IBOutlet private weak var currentPriceView: UIView!
    @IBOutlet private weak var highLowView: UIView!
    
    //MARK: - private Variables
    var cryptoModel: CryptoModel!
    var highestPrice: Float?
    var lowestPrice: Float?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels(with: cryptoModel)
        applyCornerRadius()
        findHighestLowestPrices()
    }
    
    //MARK: - Private Functions
    private func updateLabels(with cryptoModel: CryptoModel) {
        cryptoPrice.text = cryptoModel.price
        cryptoChange.text = cryptoModel.change
        
        guard let changeText = cryptoChange.text else { return }
        if changeText.hasPrefix("-") {
            cryptoChange.textColor = .systemRed
        } else {
            cryptoChange.textColor = .systemGreen
        }
    }
    
    private func applyCornerRadius() {
        currentPriceView.layer.cornerRadius = 20
        highLowView.layer.cornerRadius = 20
    }
    
    private func findHighestLowestPrices() {
        guard let sparkLines = cryptoModel.sparkLines else {
            print("SparkLines is nil")
            return
        }
        
        if sparkLines.isEmpty {
            print("SparkLines is empty")
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
            highPriceLabel.textColor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1) // systemGreen
            lowPriceLabel.text = "Low: \(lowestPrice ?? 0)"
            lowPriceLabel.textColor = UIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1) // systemRed
        } else {
            print("One of the labels is nil.")
        }
    }
    
    
    
    
    
    
}

