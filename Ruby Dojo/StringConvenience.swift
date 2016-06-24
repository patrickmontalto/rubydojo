//
//  StringConvenience.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 6/9/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

public extension String {
    
    func stringByReplacingFirstOccurrenceOfString(target: String, withString replaceString: String) -> String {
        if let range = self.rangeOfString(target) {
            return self.stringByReplacingCharactersInRange(range, withString: replaceString)
        }
        return self
    }
    
}