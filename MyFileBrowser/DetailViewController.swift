//
//  DetailViewController.swift
//  MyFileBrowser
//
//  Created by Rada Hristova on 16.02.23.
//

import UIKit
import EasyPeasy

class DetailViewController: UIViewController {
    private var collectionView: UICollectionView!
    lazy var itemsURLs: [URL] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    var fileManager: MyFileManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        applyConstraints()

        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: FileCollectionViewCell.identifier)
    }

    private func applyConstraints() {
        collectionView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Bottom()
        )
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FileCollectionViewCell.identifier, for: indexPath) as! FileCollectionViewCell
        cell.folderNameLabel.text = itemsURLs[indexPath.row].lastPathComponent
        return cell
    }
}
