//
//  Created by Mark Battistella
//	markbattistella.com
//

import Publish
import Ink

final class ComponentAlert {

	// -- the model for the alert
	struct AlertBuilder {
		let signifier: String
		let icon: SVGPaths
		let colour: String
		let width: Int

		var stroke: Int {
			return width < 0 ? 1 : width > 10 ? 10 : width
		}

		// -- build the svg icon
		func getIcon() -> String {
			return """
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
					<path fill="\(colour)" d="\(icon.rawValue)"></path>
				</svg>
			"""
		}
	}

	// -- create the alert
	func create(alert: AlertBuilder, html: String, markdown: Substring) -> String {

		let parser = MarkdownParser()

		// -- drop the `>`
		// -- trim the whitespace
		let markdown = markdown
			.dropFirst()
			.trimmingCharacters(in: .whitespaces)

		// -- only affect the items with the prefix
		guard markdown.hasPrefix(alert.signifier) else {
			return html
		}

		// -- get the alert title
		guard var title = markdown
			.dropFirst(alert.signifier.count)
			.trimmingCharacters(in: .whitespaces)
			.split(separator: "\n")
			.first else {
				return ""
			}

		// -- transform the title
		title = title.starts(with: ":") ? title.dropFirst() : ""
		let parsedTitle = parser.html(from: String(title))

		// -- get the body message
		let body = markdown
			.dropFirst(alert.signifier.count)
			.trimmingCharacters(in: .whitespaces)
			.dropFirst( title.isEmpty ? 0 : title.count + 2 )
		let parsedBody = parser.html(from: String(body))

		// -- what to return to dom
		return """
			<div class="component-alert-container"
				style="--component-alert-colour: \(alert.colour);--component-alert-width: \(alert.stroke);">
				<div class="component-alert-body">
					<div class="component-alert-icon" \(title.isEmpty ? "" : "style=\"margin-top: 0.2em;\"")>
						\(alert.getIcon())
					</div>
					<div class="component-alert-text">
						\(title.isEmpty ? "" : "<h5>\(parsedTitle)</h5>")
						\(parsedBody)
					</div>
				</div>
			</div>
		"""
	}
}
