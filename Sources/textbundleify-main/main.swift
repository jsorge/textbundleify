import Foundation
import PathKit
import TextBundleify

var arguments = CommandLine.arguments.dropFirst()

let path = Path.current

do {
    try TextBundleify.start(in: path, pathToAssets: nil)
} catch {
    Console.write(error.localizedDescription)
}
