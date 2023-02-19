//
//  ViewController.swift
//  MyFileBrowser
//
//  Created by Rada Hristova on 15.02.23.
//

import UIKit
import EasyPeasy

enum Section: Hashable {
    case all
}

class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, URL>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, URL>
    typealias CellRegistration = UICollectionView.CellRegistration<FileCollectionViewCell, URL>

    private var collectionView: UICollectionView!
    private lazy var dataSource = configureDataSource()

    lazy var itemsURLs: [URL] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }

    private let fileManager: MyFileManager
    private let initialPath: URL

    init(initialPath: URL, filemanager: MyFileManager) {
        self.initialPath = initialPath
        self.fileManager = filemanager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        applyConstraints()
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        loadItemsURLs()
        applySnapshot(animatingDifferences: false)
    }

    private func configureCellRegistration() -> CellRegistration {
        return CellRegistration { (cell, indexpath, url ) in
            cell.folderNameLabel.text = url.lastPathComponent
            if url.hasDirectoryPath {
                cell.folderNameLabel.font = .boldSystemFont(ofSize: 17)
            } else {
                cell.folderNameLabel.font = .systemFont(ofSize: 17)
            }
        }
    }
    
    private func configureDataSource() -> DataSource {
        let cellRegistration = configureCellRegistration()
        let dataSource = DataSource(
           collectionView: collectionView,
           cellProvider: { (collectionView, indexPath, url) ->
             UICollectionViewCell? in
               let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: url)
               return cell
         })
        return dataSource
    }

    func applySnapshot(animatingDifferences: Bool = true) {
      var snapshot = Snapshot()
      snapshot.appendSections([.all])
      snapshot.appendItems(itemsURLs)
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func applyConstraints() {
        collectionView.easy.layout(
            Top(),
            Leading(),
            Trailing(),
            Bottom()
        )
    }

    private func loadItemsURLs() {
        switch fileManager.contentsOfDirectory(in: initialPath) {
        case .success(let urls):
            itemsURLs = urls
        case .failure(let error):
            print(error)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = ViewController(initialPath: item, filemanager: fileManager)
        vc.title = itemsURLs[indexPath.row].lastPathComponent
        navigationController?.pushViewController(vc, animated: true)
    }
}
