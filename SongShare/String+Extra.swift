//
//  String+Extra.swift
//  SongShare
//
//  Created by Dylan Lewis on 17/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

extension String {
    func sanitizedWords() -> [String] {
        // TODO: Consider removing common words
        var sanitizedString = self.replacingOccurrences(of: "(", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: ")", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "- ", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: ".", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "& ", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "feat ", with: "")
        return sanitizedString.components(separatedBy: " ")
    }
}
