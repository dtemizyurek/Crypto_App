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
    @IBOutlet private weak var filterButton: UIButton!
    
    //MARK: - Variables
    private var cryptoModel = [CryptoModel]() {
        didSet {
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        }
    }
    

    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
        getAllData()
        setupFilterMenu()
        navigationController?.navigationBar.tintColor = UIColor(red: 208/255, green: 144/255 , blue: 51/255, alpha: 1)
    }
    
    //MARK: - Private functions
    private func nibRegister() {
        listCollectionView.register(UINib(nibName: CryptoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CryptoCollectionViewCell.identifier)
    }
    
    private func getAllData() {
        CryptoRequest.shared.getAllData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cryptos):
                let cryptoModels = cryptos.compactMap { crypto -> CryptoModel? in
                    guard let iconURL = URL(string: crypto.iconURL.replacingOccurrences(of: "svg", with: "png")) else { return nil }
                    var cryptoModel = CryptoModel(
                        symbol: crypto.symbol,
                        name: crypto.name,
                        iconURL: iconURL,
                        imageData: nil,
                        price: "$\(crypto.price.components(separatedBy: ".")[0]).\(crypto.price.components(separatedBy: ".")[1][0..<3])",
                        change: crypto.change + "%",
                        marketCap: crypto.marketCap,
                        the24HVolume: crypto.the24HVolume,
                        listedAt: Date(),
                        sparkLines: crypto.sparkline
                    )
                    
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
                print(error)
            }
        }
    }

    
    private func setupFilterMenu() {
        filterButton.showsMenuAsPrimaryAction = true

        let priceAction = UIAction(title: "Price") { [weak self] _ in
            self?.sortCryptoModel(by: \.price)
        }
        
        let marketCapAction = UIAction(title: "MarketCap") { [weak self] _ in
            self?.sortCryptoModel(by: \.marketCap)
        }
        
        let volumeAction = UIAction(title: "24h Volume") { [weak self] _ in
            self?.sortCryptoModel(by: \.the24HVolume)
        }
        
        let changeAction = UIAction(title: "Change") { [weak self] _ in
            self?.sortCryptoModel(by: \.change)
        }
        
        let listedAtAction = UIAction(title: "ListedAt") { [weak self] _ in
            self?.sortCryptoModel(by: \.listedAt)
        }
        
        filterButton.menu = UIMenu(title: "Filter", children: [priceAction, marketCapAction, volumeAction, changeAction, listedAtAction])
    }

    private func sortCryptoModel<T: Comparable>(by keyPath: KeyPath<CryptoModel, T>) {
        cryptoModel.sort { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
        listCollectionView.reloadData()
    }
    @IBAction func filterMenuAction(_ sender: Any) {
        self.cryptoModel.sort { $0.price < $1.price }
        listCollectionView.reloadData()
    }
}
            
            //MARK: - CollectionView Extension
            extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
                
                func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                    return cryptoModel.count
                }
                
                func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCollectionViewCell.identifier, for: indexPath) as? CryptoCollectionViewCell else { return .init() }
                    cell.configure(with: cryptoModel[indexPath.row])
                    return cell
                    
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
            
            
