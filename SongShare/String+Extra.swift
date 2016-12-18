//
//  String+Extra.swift
//  SongShare
//
//  Created by Dylan Lewis on 17/12/2016.
//  Copyright © 2016 Dylan Lewis. All rights reserved.
//

import Foundation

extension String {
    func sanitized() -> String {
        // TODO: Consider removing common words
        let lowercaseString = self.lowercased()
        var sanitizedString = lowercaseString.replacingOccurrences(of: "(", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: ")", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "- ", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: ".", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "& ", with: "")
        sanitizedString = sanitizedString.replacingOccurrences(of: "feat ", with: "")
        return sanitizedString
    }
    
    func sanitizedWords() -> [String] {
        let sanitizedString = self.sanitized()
        return sanitizedString.components(separatedBy: " ")
    }
}
