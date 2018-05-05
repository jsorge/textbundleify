import Foundation
import PathKit

private let infoJSON = """
{
    "version":              2,
    "type":                 "net.daringfireball.markdown",
    "transient":            true,
    "creatorURL":           "file:///Applications/MyApp",
    "creatorIdentifier":    "com.example.myapp",
    "sourceURL":            "file:///Users/johndoe/Documents/mytext.markdown",
    "com.example.myapp":    {
                                "version":    9,
                                "customKey":  "aCustomValue"
                            }
}
"""

public struct TextBundleify {
    public static func start(in path: Path, pathToAssets assetsPath: Path?) throws {
        let files = try path.children()
        
        for file in files {
            // get the name of the file
            let filename = file.lastComponent
            
            // make a new directory with that same name .textbundle
            let bundlePath = path + Path("\(filename).textbundle")
            try bundlePath.mkdir()
            
            // grab the contents of the file
            let fileData = try file.read()
            
            // write the contents to the textbundle/text.md file
            let textFilePath = bundlePath + Path("text.md")
            try textFilePath.write(fileData)
            
            // write the info.json file
            let jsonPath = bundlePath + Path("info.json")
            try jsonPath.write(infoJSON)
            
            // make the assets directory
            let assetsPath = bundlePath + Path("assets")
            try assetsPath.mkdir()
            
            // <later> find the assets in the file
            
                // if there are assets, find them in the assets path
                // move them to the assets directory in the textbundle
            
            // delete the original file from the path
            try file.delete()
        }
    }
}
