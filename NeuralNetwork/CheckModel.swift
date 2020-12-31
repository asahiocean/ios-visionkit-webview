import CoreML

class CheckModel {
    internal var model: MLModel!
    
    init() {
        if let model = self.checkModel(name: "PlayingCardDetector") {
            self.model = model
        } else {
            fatalError("Can`t find Model")
        }
    }
    
    fileprivate func checkModel(name: String) -> MLModel? {
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "mlmodelc") else { return nil }
        return try! MLModel(contentsOf: modelURL)
    }
}
