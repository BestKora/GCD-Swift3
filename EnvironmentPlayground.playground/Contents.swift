import UIKit
import PlaygroundSupport
//: Определяем бесконечное выполнение, чтобы предотвратить "выбрасывание" background tasks, когда работа на Playground будет закончена.
PlaygroundPage.current.needsIndefiniteExecution = true

var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
var image = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
image.backgroundColor = UIColor.yellow
image.contentMode = .scaleAspectFit
view.addSubview(image)
//: "Живой" UI
PlaygroundPage.current.liveView = view
func fetchImage() {
    
    let imageURL: URL = URL(string: "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
    let queue = DispatchQueue.global(qos: .utility)
    queue.async{
        if let data = try? Data(contentsOf: imageURL){
            DispatchQueue.main.async {
                image.image = UIImage(data: data)
                 print("Show image data")
            }
            print("Did download  image data")
        }
    }
}
fetchImage()
//: Замечание: Необходимо закомментировать предложение finishExecution чтобы посмотреть результат на main queue в отладочной области и включить Ассистента Редактора, если вы хотите увидеть UI
//PlaygroundPage.current.finishExecution()
//: Остановите Playground вручную, если вы комментируете finishExecution()
