//
//  Created by Mark Battistella
//	markbattistella.com
//

import Foundation

extension CaseIterable {

	static func from(string: String) -> Self? {
		return Self.allCases.first { string == "\($0)" }
	}
	
}
