//
//  ViewController.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 1.05.2024.
//

import UIKit

final class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    var cryptos = [CryptoModel]() {
        didSet {
            DispatchQueue.main.async {
                print(self.cryptos.count)
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getAllData()
    }
    
    //MARK: - Private functions
    private func nibRegister() {
        collectionView.register(UINib(nibName: CryptoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CryptoCollectionViewCell.identifier)
    }
    
    private func getAllData () {
        CryptoRequest.shared.getAllData { result in
            switch result {
            case .success(let cryptoss):
                self.cryptos = cryptoss.compactMap({
                    CryptoModel(symbol: $0.symbol, name: $0.name, iconURL: URL(string: $0.iconURL.replacingOccurrences(of: "svg", with: "png")), price: "$\($0.price.components(separatedBy: ".")[0]).\($0.price.components(separatedBy: ".")[1][0..<3])", change: $0.change + "%", sparkLines: $0.sparkline)
                })
            break
            case .failure(let error):
                print(error)
            break
            }
        }
    }
}

//MARK: - CollectionView Extension
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cryptos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCollectionViewCell.identifier, for: indexPath) as? CryptoCollectionViewCell else { return .init() }
        
        cell.configure(with: cryptos[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.frame.width
        let cellHeight: CGFloat = 125
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

