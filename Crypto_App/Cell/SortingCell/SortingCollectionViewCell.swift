//
//  SortingCollectionViewCell.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 9.05.2024.
//

import UIKit

final class SortingCollectionViewCell: UICollectionViewCell {
    //MARK: - IBOutlets
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var sortLabel: UILabel!
    //MARK: - Variables
    var cryptoModel: [StatusModel] = []
    static let identifier = "SortingCollectionViewCell"
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    private func customizeView() {
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 204/255, green: 102/255, blue: 0/255, alpha: 1).cgColor
    }
    
    public func configure(with stats: StatusModel) {
        self.sortLabel.text = stats.status.rawValue

    }
}

