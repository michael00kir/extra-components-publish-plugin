//
//  Created by Mark Battistella
//	markbattistella.com
//

import Publish
import Ink

final class AdditionalComponents {

	let parser = MarkdownParser()

	// MARK: - create the alert
	func create(alert: AlertBuilder, html: String, markdown: Substring) -> String {

		// -- alert: colour class
		var colourClass: String {
			switch alert.type {
				case .error:
					return "component-colour-red"
				case .warning:
					return "component-colour-orange"
				case .success:
					return "component-colour-green"
				case .information:
					return "component-colour-blue"
			}
		}

		// -- alert: icon svg
		var alertIcon: String {
			return "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='\(alert.icon.rawValue)'></path></svg>"
		}

		// -- drop the `>`
		// -- trim the whitespace
		let markdown = markdown
			.dropFirst()
			.trimmingCharacters(in: .whitespaces)

		// -- only affect the items with the prefix
		guard markdown.hasPrefix(alert.type.rawValue) else {
			return html
		}

		// -- get the alert title
		guard var title = markdown
			.dropFirst(alert.type.rawValue.count)
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
			.dropFirst(alert.type.rawValue.count)
			.trimmingCharacters(in: .whitespaces)
			.dropFirst( title.isEmpty ? 0 : title.count + 2 )
		let parsedBody = parser.html(from: String(body))


		// -- what to return to dom
		return """
			<div class="component-alert-container \(colourClass)">
				<div class="component-alert-body" \(title.isEmpty ? "" : "margin-top: 0.2em;")>
					<div class="component-alert-icon">\(alertIcon)</div>
					<div class="component-alert-text">
						\(title.isEmpty ? "" : parsedTitle)
						\(parsedBody)
					</div>
				</div>
			</div>
		"""
	}


	// MARK: - create the link (download)
	func create(html: String, markdown: Substring) -> String {

		// -- drop the `>`
		// -- trim the whitespace
		let markdown = markdown
			.dropFirst()
			.trimmingCharacters(in: .whitespaces)

		// -- only affect the items with the prefix
		guard markdown.hasPrefix("!file") else {
			return html
		}



		return String(markdown)
	}
}
