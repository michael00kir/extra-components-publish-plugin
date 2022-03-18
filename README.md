# Extra Components for Publish

A collection of additional components which can be used throughout a Publish site in the markdown.

## Installation

To install it into your Publish package, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    dependencies: [
        .package(name: "ExtraComponents", url: "https://github.com/markbattistella/extra-components-publish-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            dependencies: [
                "ExtraComponents"
            ]
        )
    ]
)
```

Then import `ExtraComponents` wherever you’d like to use it:

```swift
import ExtraComponents
```

For more information on how to use the Swift Package Manager, check out [its official documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).

## Usage

The plugin can then be used within any publishing pipeline like this:

```swift
import ExtraComponents

try DeliciousRecipes().publish(using: [
    .installPlugin(.addExtraComponents())
])
```
