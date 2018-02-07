//
//  NMColorField.swift
//  NoteMap
//
//  Created by Zach Eriksen on 1/4/18.
//  Copyright © 2018 oneleif. All rights reserved.
//

import UIKit

class NMColorField: UITextField {
	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		return false
	}
}
