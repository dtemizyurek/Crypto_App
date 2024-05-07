//
//  ViewController.swift
//  Crypto_App
//
//  Created by Doğukan Temizyürek on 1.05.2024.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        nibRegister()
    }
    
    //MARK: - Private functions
    private func nibRegister() {
        collectionView.register(UINib(nibName: CryptoReusableView.identifier, bundle: nil), forCellWithReuseIdentifier: CryptoReusableView.identifier)
        collectionView.register(UINib(nibName: CryptoCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CryptoCollectionViewCell.identifier)
    }
    
}

//MARK: - CollectionView Extension
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

