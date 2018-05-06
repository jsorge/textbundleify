import Foundation
import PathKit
import TextBundleify

var arguments = CommandLine.arguments.dropFirst()

let path = Path.current

do {
    var assetsPath: Path?
    if let input = arguments.last {
        assetsPath = Path(input)
    }

    try TextBundleify.start(in: path, pathToAssets: assetsPath)
} catch {
    Console.write(error.localizedDescription, to: .error)
}
