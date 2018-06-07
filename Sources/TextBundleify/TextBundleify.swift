import Foundation
import PathKit

private let infoJSON = """
{
    "version":              2,
    "type":                 "net.daringfireball.markdown",
    "transient":            true,
}
"""

public struct TextBundleify {
    public static func start(in path: Path, pathToAssets externalAssetsPath: Path?) throws {
        let files = try path.children()
        
        for file in files {
            let bundlePath = path + Path("\(file.lastComponentWithoutExtension).textbundle")
            guard bundlePath.exists == false else { continue }
            try bundlePath.mkdir()
            
            let assetsPath = bundlePath + Path("assets")
            try assetsPath.mkdir()
            
            var fileData = try file.read()
            
            if let externalAssetsPath = externalAssetsPath,
                var fileText = String(data: fileData, encoding: .utf8)
            {
                for imagePath in self.imagePathsInFile(fileData) {
                    let imageName = imagePath.lastComponent
                    guard
                        let foundImagePath = self.filepathForFile(named: imageName, in: externalAssetsPath),
                        foundImagePath.string.isEmpty == false
                        else { continue }
                    
                    let newPath = assetsPath + Path("\(imageName)")
                    try foundImagePath.copy(newPath)
                    fileText = fileText.replacingOccurrences(of: imagePath.string, with: "assets/\(imageName)", options: [], range: nil)
                }
                
                fileData = fileText.data(using: .utf8)!
            }
            
            let textFilePath = bundlePath + Path("text.md")
            try textFilePath.write(fileData)
            
            let jsonPath = bundlePath + Path("info.json")
            try jsonPath.write(infoJSON)
            
            try file.delete()
        }
    }
    
    private static func imagePathsInFile(_ fileData: Data) -> [Path] {
        // The \ characters have to be escaped, so the pattern is actually:
        // !\[[^\]]*\]\((?<filename>.*?)(?=\"|\))(?<optionalpart>\".*\")?\)
        let pattern = """
        !\\[[^\\]]*\\]\\((?<filename>.*?)(?=\\"|\\))(?<optionalpart>\\".*\\")?\\)
        """
        
        var imagePaths = [Path]()
        guard let fileAsString = String(data: fileData, encoding: .utf8) else { return imagePaths }
        
        do {
            let regex = try NSRegularExpression.init(pattern: pattern, options: [])
            let matches = regex.matches(in: fileAsString, options: [], range: NSRange(location: 0, length: fileAsString.count))
            
            for match in matches {
                let range = match.range
                let fullImageMarkdown = NSString(string: fileAsString).substring(with: range)
                // Formatted like ![](/path/to/image.jpg)
                guard let filepath = fullImageMarkdown.split(separator: "(")
                    .last?
                    .replacingOccurrences(of: ")", with: ""),
                    filepath.contains("http") == false
                    else { continue }
                imagePaths.append(Path(filepath))
            }
        } catch {
            return imagePaths
        }

        return imagePaths
    }
    
    private static func filepathForFile(named filename: String, in path: Path) -> Path? {
        // adapted from https://gist.github.com/Seasons7/836d3676884a40c8c98a
        let task = Process()
        let pipe = Pipe()
        
        // find <search path> -name '<filename>'
        task.launchPath = "/usr/bin/find"
        task.arguments = ["\(path.absolute().string)", "-name", "\(filename)"]
        print("Arguments: \(task.arguments!)")
        task.standardOutput = pipe
        task.launch()
        
        let handle = pipe.fileHandleForReading
        let data = handle.readDataToEndOfFile()
        guard
            let pathStr = String (data: data, encoding: String.Encoding.utf8)?
                .replacingOccurrences(of: "\n", with: "")
            else { return nil }
        
        return Path(pathStr)
    }
}
