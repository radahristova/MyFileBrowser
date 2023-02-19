//
//  FileCollectionViewCell.swift
//  MyFileBrowser
//
//  Created by Rada Hristova on 15.02.23.
//

import UIKit
import EasyPeasy

class FileCollectionViewCell: UICollectionViewCell {
    static let identifier = "FileCollectionViewCell"

    let folderNameLabel = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        folderNameLabel.textAlignment = .left
        folderNameLabel.textColor = .black
        folderNameLabel.numberOfLines = 0
        contentView.addSubview(folderNameLabel)
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func applyConstraints() {
        contentView.easy.layout(
        Top(),
        Leading().to(layoutMarginsGuide, .leading),
        Trailing().to(layoutMarginsGuide,.trailing),
        Bottom()
        )

        folderNameLabel.easy.layout(
        Leading(8),
        Trailing(8),
        CenterY()
        )
    }
}


//extension URL {
//    var isDirectory: Bool {
//       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
//    }
//}
