import Foundation

extension URL {
    /// https://" + string
    static func fixHttps(_ string: String) -> URL? {
        let urlString: String
        
        if (string.starts(with: "https://")) {
            urlString = string
        } else {
            urlString = "https://" + string
        }
        return URL(string: urlString)
    }
}
