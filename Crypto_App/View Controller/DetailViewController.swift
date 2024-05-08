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
    @IBOutlet private weak var highPrice: UILabel!
    @IBOutlet private weak var lowPrice: UILabel!
//MARK: - Variables
    var cryptoModel: CryptoModel!
    var highestPrice: Float?
    var lowestPrice: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
