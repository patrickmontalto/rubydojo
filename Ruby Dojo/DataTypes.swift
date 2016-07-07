//
//  DataTypes.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/6/16.
//  Copyright © 2016 swift. All rights reserved.
//

import UIKit

enum DataTypes:String {
    case String = "\"(.*?)\""
    case Int = "\\b(\\d+(\\.\\d+)?)"
    case InstanceVariable = "(\\@[a-z|_]+\\w+)"
    case ClassVariable = "(\\@\\@[a-z|_]+\\w+)"
    case Variable = "\\b(?<!@)(?<!\\$)[a-z]+\\w+"
    case GlobalVariable = "\\$\\w+"
    case Symbol = "(:\\w+[a-z]+\\w+)|(:'\\w+\\s+\\w+')"
    case Constant = "\\b[A-Z]\\w+"
    case Keyword = "\\b(do|end|def|if|else|elsif|yield|while|unless|for|return|class)\\b"
    case Boolean = "\\b(true|false|nil)\\b"
    
    var syntaxColor: UIColor {
        switch self {
        case .Int, .Boolean, .String, .Symbol:
            return Solarized.CyanColor
        case .InstanceVariable, .GlobalVariable, .ClassVariable:
            return Solarized.BlueColor
        case .Variable:
            return Solarized.Base02
        case .Constant:
            return Solarized.YellowColor
        case .Keyword:
            return Solarized.GreenColor
        }
    }
    var syntaxColorAttributes: [NSObject : AnyObject] {
        return [NSForegroundColorAttributeName: self.syntaxColor]
    }
}
