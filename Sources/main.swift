import Cocoa

/// Argument Parsing

func urlAt(_ position: Int, within collection: [String]) -> URL? {
    guard position < collection.count else {
        print("Error extracting URL from argument list")
        exit(EXIT_FAILURE)
    }
    
    if let url = URL(string: collection[position]) {
        print(url)
        if url.scheme == nil {
            return URL(fileURLWithPath: url.path)
        }
        return url
    } else {
        print("Expected valid URL for argument \(position)")
    }
    return nil
}

let args = Array(Process.arguments[1..<Process.arguments.count])

if args.count < 1 {
    exit(EXIT_FAILURE)
}

guard let sourceURL = urlAt(0, within: args), let destinationURL = urlAt(1, within: args) else {
    exit(EXIT_FAILURE)
}

let session = URLSession.shared

/// Download all resources in a manifest specified at the URL, recursively if a
/// resource is itself an m3u8 manifest.
func downloadHLSResource(_ downloadURL: URL) {
    session.downloadTask(with: downloadURL) { (url :URL?, response :URLResponse?, error :Error?) in
        guard let resourceURL = response?.url, let tempfileURL = url else {
            print("Download failed: \(downloadURL) -- \(error)")
            return
        }
        ingestHLSResource(resourceURL, temporaryFileURL: tempfileURL, downloader: downloadHLSResource, destinationURL: destinationURL)
        }.resume()
}

downloadHLSResource(sourceURL)

RunLoop.main.run()
