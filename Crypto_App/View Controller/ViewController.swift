//
//  ViewController.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 1.05.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var listCollectionView: UICollectionView!
    @IBOutlet private weak var sortingCollectionView: UICollectionView!
    
    //MARK: - Variables
    private var cryptoModel = [CryptoModel]() {
        didSet {
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        }
    }
    
    private var statsModel = [StatusModel]()
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getAllData()
    }
    
    //MARK: - Private functions
    private func nibRegister() {
        listCollectionView.register(UINib(nibName: CryptoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CryptoCollectionViewCell.identifier)
        sortingCollectionView.register(UINib(nibName: SortingCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SortingCollectionViewCell.identifier)
    }
    
    private func getAllData() {
        CryptoRequest.shared.getAllData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cryptos):
                let cryptoModels = cryptos.compactMap { crypto -> CryptoModel? in
                    guard let iconURL = URL(string: crypto.iconURL.replacingOccurrences(of: "svg", with: "png")) else { return nil }
                    var cryptoModel = CryptoModel(symbol: crypto.symbol, name: crypto.name, iconURL: iconURL, price: "$\(crypto.price.components(separatedBy: ".")[0]).\(crypto.price.components(separatedBy: ".")[1][0..<3])", change: crypto.change + "%", sparkLines: crypto.sparkline)
                    
                    // Fetch image data
                    DispatchQueue.global().async {
                        if let data = try? Data(contentsOf: iconURL) {
                            DispatchQueue.main.async {
                                cryptoModel.imageData = data
                                self.listCollectionView.reloadData()
                            }
                        }
                    }
                    
                    return cryptoModel
                }
                self.cryptoModel = cryptoModels
            case .failure(let error):
                print(error) // TODO: Handle
            }
        }
    }
    
}
    //MARK: - CollectionView Extension
    extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch collectionView {
            case listCollectionView:
                return cryptoModel.count
            case sortingCollectionView:
                return statsModel.count
                
            default:
                return 0
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch collectionView {
            case listCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCollectionViewCell.identifier, for: indexPath) as? CryptoCollectionViewCell else { return .init() }
                cell.configure(with: cryptoModel[indexPath.row])
                return cell
                
            case sortingCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortingCollectionViewCell.identifier, for: indexPath) as? SortingCollectionViewCell else { return .init()}
                cell.isUserInteractionEnabled = true
                cell.configure(with: statsModel[indexPath.row])
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth: CGFloat = collectionView.frame.width
            let cellHeight: CGFloat = 125
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let detailVC = DetailViewController()
            detailVC.cryptoModel = cryptoModel[indexPath.item]
            if detailVC.cryptoModel.imageData == nil {
                CryptoRequest.shared.getImageData(from: detailVC.cryptoModel.iconURL!) { imageData in
                    detailVC.cryptoModel.imageData = imageData
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            } else {
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    

