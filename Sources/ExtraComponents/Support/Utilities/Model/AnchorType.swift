//
//  Created by Mark Battistella
//	markbattistella.com
//

import Foundation

struct AnchorType {
	let type: Specifier
	let icon: SVGPaths

	enum Specifier: String {
		case download = ":file"
		case reference = ":ref"
	}
}
