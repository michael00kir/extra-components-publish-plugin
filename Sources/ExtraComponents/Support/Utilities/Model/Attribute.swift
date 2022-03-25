//
//  Created by Mark Battistella
//	markbattistella.com
//

import Foundation

struct Attribute {
	var key: String
	var value: String

	init(key: String, value: String) {
		self.key = key
		self.value = value
	}

	init?(_ rawValue: String) {
		let pair = rawValue.split(separator: "=").map(String.init)
		guard pair.count == 2 else { return nil }
		key = pair[0]
		value = pair[1].replacingOccurrences(of: "\"", with: "")
	}
}
