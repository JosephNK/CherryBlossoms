//
//  ArrayExtensions.swift
//  JosephNK
//
//  Created by JosephNK on 04/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//
//  https://gist.github.com/sohayb/4ba350f7e45c636cb3c9
//

import UIKit

//
// Deep Copy
//

// Protocol that copyable class should conform
protocol Copying {
	init(original: Self)
}

// Concrete class extension
extension Copying {
	func copy() -> Self {
		return Self.init(original: self)
	}
}

// Array extension for elements conforms the Copying protocol
extension Array where Element: Copying {
	func clone() -> Array {
		var copiedArray = Array<Element>()
		for element in self {
			copiedArray.append(element.copy())
		}
		return copiedArray
	}
}
