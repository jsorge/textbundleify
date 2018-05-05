import Foundation

/// Used to interact with the console in a CLI context
public struct Console {
    /// The type of output to print messages to the console
   public enum OutputType {
        /// Standard Output
        case standard
        /// Standard Error
        case error
    }

    /// Reads the input from Standard Input
    public static func getInput() -> String {
        return String(data: FileHandle.standardInput.availableData, encoding: String.Encoding.utf8)!
               .trimmingCharacters(in: CharacterSet.newlines)
    }

    /// Prints the message to the specified output
    ///
    /// - parameter message: The message to print
    /// - parameter output:  The output type to send the message to. It gets prepended with "Error: "
    public static func write(_ message: String, to output: OutputType = .standard) {
        switch output {
        case .standard:
            print(message)
        case .error:
            fputs("Error: \(message)\n", stderr)
        }
    }
}
