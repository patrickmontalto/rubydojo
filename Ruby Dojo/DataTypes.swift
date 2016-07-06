//
//  DataTypes.swift
//  Ruby Dojo
//
//  Created by Patrick Montalto on 7/6/16.
//  Copyright © 2016 swift. All rights reserved.
//

import Foundation

enum DataTypes: String {
    case String, Int, InstanceVariable, Variable, GlobalVariable, ClassVariable, Symbol, Class, Keyword
}

// Need to check regex for valid submission of each type

// Need to associate each DataType with a color from Solarized