//
//  Created by Mark Battistella
//	@markbattistella
//

import Ink
import Plot
import Files
import Publish


// MARK: - create the plugin
public extension Plugin {
	static func addExtraComponents(addCss: Bool = true) -> Self {
		Plugin(name: "ExtraComponents") { context in

			// -- add all our modifiers here
			let modifiers: [Modifier] = [
				// -- alerts
				.addAlert(alert: .init(type: .error, icon: .xCircle)),
				.addAlert(alert: BlockquoteAlert(type: .warning, icon: .alert)),
				.addAlert(alert: BlockquoteAlert(type: .success, icon: .checkCircle)),
				.addAlert(alert: BlockquoteAlert(type: .information, icon: .info)),

				// -- full width items
				.addBlockItem(item: AnchorType(type: .download, icon: .download)),
				.addBlockItem(item: AnchorType(type: .reference, icon: .arrowRight))
			]

			// -- write the css file
			if( addCss ) {
				let cssFile = try context.createOutputFile(at: "assets/css/extra-components.css")
				try cssFile.write(extraComponentsCssFile())
			}

			// -- add them to the plugins
			for modifier in modifiers {
				context.markdownParser.addModifier(modifier)
			}
		}
	}
}


// MARK: - create the modifiers
public extension Modifier {

	internal static func addAlert(alert: BlockquoteAlert) -> Self {
		Modifier(target: .blockquotes) { html, markdown in
			return AdditionalComponents()
				.create(alert: alert, html: html, markdown: markdown)
		}
	}

	internal static func addBlockItem(item: AnchorType) -> Self {
		Modifier(target: .links) { html, markdown in
			return AdditionalComponents()
				.create(item: item, html: html, markdown: markdown)
		}
	}
}


// MARK: - custom CSS file
fileprivate func extraComponentsCssFile() -> String {
	return try! File(path: #filePath)
		.parent?
		.file(named: "Support/extra-components.css")
		.readAsString() as! String
}
