//
//  Created by Mark Battistella
//	markbattistella.com
//

import Foundation
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
		var iconSVG: String {
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
			<div class="component-container component-alert \(colourClass)">
				<div class="component-body" \(title.isEmpty ? "" : "margin-top: 0.2em;")>
					<div class="component-icon">\(iconSVG)</div>
					<div class="component-text">
						\(title.isEmpty ? "" : "<strong>" + parsedTitle + "</strong>")
						\(parsedBody)
					</div>
				</div>
			</div>
		"""
	}


	// MARK: - create the link (download)
	func create(specifier: Specifier, html: String, markdown: Substring) -> String {

		let specifier = "[" + specifier.rawValue

		// -- only affect the items with the prefix
		guard markdown.hasPrefix(specifier) else {
			return html
		}


		// -- get the text component
		guard let text = markdown.content(delimitedBy: .squareBrackets) else { return html }

		// -- get the link component
		guard let link = markdown.content(delimitedBy: .parentheses) else { return html }


		// -- get the title or default
		var title: String {
			let title = text.dropFirst(specifier.count)
			return String(title.isEmpty ? "Download" : title)
		}

		// -- get the attributes
		let parts = link
			.components(separatedBy: CharacterSet.whitespaces)

		// -- get the download link
		guard let file = parts.first,
			  let fileName = file.split(separator: "/").last else { return html }


		// -- get the arrtibutes
		let attributes = parts
			.dropFirst()
			.compactMap(Attribute.init)

		// -- get the icon
		var iconSVG: String {
			let icon = SVGPaths.from(string: attributes.first(
				where: { $0.key == "icon" })?
										.value.replacingOccurrences(of: "\"", with: "") ?? ""
			)
			return "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='\(icon?.rawValue ?? SVGPaths.download.rawValue)'></path></svg>"
		}

		// -- get the colour
		var colourClass: String {
			let colourAttribute = attributes.first(
				where: { $0.key == "colour" })?
				.value.replacingOccurrences(of: "\"", with: "") ?? ""
			return colourAttribute.isEmpty ? "" : "component-colour-\(colourAttribute)"
		}




		return """
   <div class="component-container component-download \(colourClass)">
	<a class="component-body" href="\(file)" download="\(fileName)" target="_blank" data-name="\(fileName)">
	 <div class="component-icon">\(iconSVG)</div>
	 <div class="component-text">\(parser.html(from: title))</div>
	</a>
   </div>
  """
	}





//	func create(specifier: Specifier, html: String, markdown: Substring) -> String {
//
//		let specifier = "[" + specifier.rawValue
//
//		// -- only affect the items with the prefix
//		guard markdown.hasPrefix(specifier) else {
//			return html
//		}
//
//
//		// -- get the text component
//		guard let text = markdown.content(delimitedBy: .squareBrackets) else { return html }
//
//		// -- get the link component
//		guard let link = markdown.content(delimitedBy: .parentheses) else { return html }
//
//
//		// -- get the title or default
//		var title: String {
//			let title = text.dropFirst(specifier.count)
//			return String(title.isEmpty ? "Download" : title)
//		}
//
//		// -- get the attributes
//		let parts = link
//			.components(separatedBy: CharacterSet.whitespaces)
//
//		// -- get the download link
//		guard let file = parts.first,
//			  let fileName = file.split(separator: "/").last else { return html }
//
//
//		// -- get the arrtibutes
//		let attributes = parts
//			.dropFirst()
//			.compactMap(Attribute.init)
//
//		// -- get the icon
//		var iconSVG: String {
//			let icon = SVGPaths.from(string: attributes.first(
//				where: { $0.key == "icon" })?
//				.value.replacingOccurrences(of: "\"", with: "") ?? ""
//			)
//			return "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='\(icon?.rawValue ?? SVGPaths.download.rawValue)'></path></svg>"
//		}
//
//		// -- get the colour
//		var colourClass: String {
//			let colourAttribute = attributes.first(
//				where: { $0.key == "colour" })?
//				.value.replacingOccurrences(of: "\"", with: "") ?? ""
//			return colourAttribute.isEmpty ? "" : "component-colour-\(colourAttribute)"
//		}
//
//
//
//
//		return """
//			<div class="component-container component-download \(colourClass)">
//				<a class="component-body" href="\(file)" download="\(fileName)" target="_blank" data-name="\(fileName)">
//					<div class="component-icon">\(iconSVG)</div>
//					<div class="component-text">\(parser.html(from: title))</div>
//				</a>
//			</div>
//		"""
//	}
}
