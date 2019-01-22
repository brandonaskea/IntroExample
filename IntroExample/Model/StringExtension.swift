//
//  StringExtension.swift
//  IntroExample
//
//  Created by Brandon Askea on 1/21/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import Foundation

extension String {
    func removeHTMLTags() -> String {
        return replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "").replacingOccurrences(of: "\\", with: "")
    }
}
