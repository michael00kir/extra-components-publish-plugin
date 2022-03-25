//
//  Created by Mark Battistella
//	markbattistella.com
//

import Foundation

struct BlockquoteAlert {
	let type: AlertTypes
	let icon: SVGPaths

	enum AlertTypes: String {
		case error = "!"
		case warning = "%"
		case success = "/"
		case information = "?"
	}
}
