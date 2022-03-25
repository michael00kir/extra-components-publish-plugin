//
//  Created by Mark Battistella
//	markbattistella.com
//

import Foundation
import Publish
import Ink

final class AdditionalComponents {

	let parser = MarkdownParser()

	private func getSvgIcon(icon name: String) -> String {
		return "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'><path d='\(name)'></path></svg>"
	}

	private func doesNotBeginsWithSpecifier(specifier: String, markdown: Substring) -> Bool {
		return !markdown.hasPrefix(specifier)
	}


	// MARK: - create the alert
	func create(alert: BlockquoteAlert, html: String, markdown: Substring) -> String {

		// -- check it begins with what we need
		if( doesNotBeginsWithSpecifier(specifier: "> \(alert.type.rawValue)", markdown: markdown)) { return html }

		// -- get the alert title
		guard var title = markdown
			.dropFirst(alert.type.rawValue.count + 2) // +2 for > and whitspace
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
			.dropFirst(alert.type.rawValue.count + 2)
			.trimmingCharacters(in: .whitespaces)
			.dropFirst( title.isEmpty ? 0 : title.count + 2 )
		let parsedBody = parser.html(from: String(body))


		// -- colour class
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

		// -- icon svg
		let iconSVG = getSvgIcon(icon: alert.icon.rawValue)




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


	// MARK: - create the link types
	func create(item: AnchorType, html: String, markdown: Substring) -> String {

		// -- check it begins with what we need
		if( doesNotBeginsWithSpecifier(specifier: "[\(item.type.rawValue)", markdown: markdown)) { return html }

		// -- get the text component
		guard let text = markdown.content(delimitedBy: .squareBrackets) else { return html }

		// -- get the link component
		guard let link = markdown.content(delimitedBy: .parentheses) else { return html }

		// -- get the attributes
		let parts: [String] = text
			.components(separatedBy: CharacterSet(charactersIn: ":"))

		// -- get the attributes
		let attributes = parts
			.dropFirst()
			.compactMap(Attribute.init)
			.sorted(by: { $0.key < $1.key })

		// -- format the link
		var fileName: String {
			let sections = link.split(separator: "/", omittingEmptySubsequences: true)
			switch item.type {
				case .download:
					return String(sections.last ?? "/")
				case .reference:
					let link = link
						.replacingOccurrences(of: "../", with: "/")
						.replacingOccurrences(of: "./",  with: "/")
					return link.hasSuffix("/") ? String(link.dropLast()) : link
			}
		}

		// -- get the title
		var title: String {
			guard let title = attributes.first(where: { $0.key == "title" })?.value else {
				switch item.type {
					case .download:
						return "Download"
					case .reference:
						return "Reference"
				}
			}
			return title
		}

		// -- get the theme
		var theme: String {
			guard let theme = attributes.first(where: { $0.key == "theme" })?.value else { return "" }
			return theme.isEmpty ? "" : "component-colour-\(theme)"
		}

		// -- get the svg icon
		var iconSVG: String {
			guard let icon = SVGPaths.from(string: attributes.first(where: { $0.key == "icon" })?.value ?? "\(item.icon)" )?.rawValue else { return item.icon.rawValue }
			return getSvgIcon(icon: icon)
		}

		// -- anchor target
		var target: String {
			guard let target = attributes.first(where: { $0.key == "target" })?.value else { return "_self" }
			switch item.type {
				case .download:
					return "_blank"
				case .reference:
					return target
			}
		}

		// -- add the attributes here
		var linkAttributes: String {
			var attributes: [String] = []

			// -- for all items
			attributes.append("target=\"\(target)\"")
			attributes.append("data-name=\"\(fileName.isEmpty ? "/" : fileName)\"")

			// -- downloads
			if item.type == .download {
				attributes.append("download=\"\(fileName)\"")
			}
			return attributes.joined(separator: " ")
		}

		// output
		return """
			<div class="component-container component-banner \(theme)">
				<a class="component-body" href="\(link)" \(linkAttributes)>
					<div class="component-icon">\(iconSVG)</div>
					<div class="component-text">\(parser.html(from: title))</div>
				</a>
			</div>
		"""
	}
}
