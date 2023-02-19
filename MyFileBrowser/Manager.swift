//
//  Manager.swift
//  MyFileBrowser
//
//  Created by Rada Hristova on 15.02.23.
//

import Foundation

protocol MyFileManager {
    func contentsOfDirectory(in url: URL) -> Result<[URL], Error>
}

extension FileManager: MyFileManager {
    func contentsOfDirectory(in url: URL) -> Result<[URL], Error> {
        do {
            let itemsURLs = try contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            return .success(itemsURLs)
        } catch {
            return .failure(error)
        }
    }
}
