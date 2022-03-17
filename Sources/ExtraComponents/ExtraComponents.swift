//
//  Created by Mark Battistella
//	@markbattistella
//

import Publish
import Plot
import Ink


// -- create the plugin
public extension Plugin {
	static func addExtraComponents(width: Int = 5) -> Self {
		Plugin(name: "ExtraComponents") { context in
			context.markdownParser.addModifier( .addAlertInfo(width: width))
			context.markdownParser.addModifier( .addAlertWarning(width: width))
			context.markdownParser.addModifier( .addAlertError(width: width))
			context.markdownParser.addModifier( .addAlertSuccess(width: width))
		}
	}
}


// -- create the modifiers
public extension Modifier {

	// -- alert: info
	static func addAlertInfo(width: Int) -> Self {
		return Modifier(target: .blockquotes) { html, markdown in
			ComponentAlert()
				.create(
					alert: ComponentAlert.AlertBuilder(
						signifier: "?", icon: .info, colour: "rgb(66 132 251)", width: width
					),
					html: html,
					markdown: markdown
				)
		}
	}

	// -- alert: warning
	static func addAlertWarning(width: Int) -> Self {
		return Modifier(target: .blockquotes) { html, markdown in
			ComponentAlert()
				.create(
					alert: ComponentAlert.AlertBuilder(
						signifier: "%", icon: .alert, colour: "rgb(237 171 38)", width: width
					),
					html: html,
					markdown: markdown
				)
		}
	}

	// -- alert: error
	static func addAlertError(width: Int) -> Self {
		return Modifier(target: .blockquotes) { html, markdown in
			ComponentAlert()
				.create(
					alert: ComponentAlert.AlertBuilder(
						signifier: "!", icon: .stop, colour: "rgb(229 62 62)", width: width
					),
					html: html,
					markdown: markdown
				)
		}
	}

	// -- alert: success
	static func addAlertSuccess(width: Int) -> Self {
		return Modifier(target: .blockquotes) { html, markdown in
			ComponentAlert()
				.create(
					alert: ComponentAlert.AlertBuilder(
						signifier: "/", icon: .checkCircle, colour: "rgb(54 173 153)", width: width
					),
					html: html,
					markdown: markdown
				)
		}
	}
}
