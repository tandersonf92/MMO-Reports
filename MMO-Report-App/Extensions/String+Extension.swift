//
//  String+Extension.swift
//  MMO-Report-App
//
//  Created by Anderson Oliveira on 17/08/23.
//

import Foundation

extension String {
    func parseToNSAttributedString() -> NSAttributedString? {
        guard let htmlData = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: htmlData,
                                       options: [.documentType: NSAttributedString.DocumentType.html,
                                                 .characterEncoding: String.Encoding.utf8.rawValue],
                                       documentAttributes: nil)
    }
}
