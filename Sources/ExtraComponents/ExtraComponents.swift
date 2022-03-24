//
//  Created by Mark Battistella
//	@markbattistella
//

import Publish
import Plot
import Ink
import Files


// MARK: - create the plugin
public extension Plugin {
	static func addExtraComponents(addCss: Bool = true) -> Self {
		Plugin(name: "ExtraComponents") { context in

			// -- add all our modifiers here
			let modifiers: [Modifier] = [
				.addAlert(alert: .init(type: .error, icon: .xCircle)),
				.addAlert(alert: AlertBuilder(type: .warning, icon: .alert)),
				.addAlert(alert: AlertBuilder(type: .success, icon: .checkCircle)),
				.addAlert(alert: AlertBuilder(type: .information, icon: .info)),
				.addDownload()
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

	internal static func addAlert(alert: AlertBuilder) -> Self {
		Modifier(target: .blockquotes) { html, markdown in
			return AdditionalComponents()
				.create(alert: alert, html: html, markdown: markdown)
		}
	}

	static func addDownload() -> Self {
		Modifier(target: .links) { html, markdown in
			return AdditionalComponents()
				.create(specifier: .download, html: html, markdown: markdown)
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
