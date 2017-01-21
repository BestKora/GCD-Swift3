import UIKit
import PlaygroundSupport


//: Определяем бесконечное выполнение, чтобы предотвратить "выбрасывание" background tasks, когда выполнение кода  будет закончено.

PlaygroundPage.current.needsIndefiniteExecution = true


var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
var eiffelImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
eiffelImage.backgroundColor = UIColor.yellow
eiffelImage.contentMode = .scaleAspectFit
view.addSubview(eiffelImage)

PlaygroundPage.current.liveView = view

let imageURL = URL(string: "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!

//: ### Загрузка классическим способом
func fetchImage() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async{
        if let data = try? Data(contentsOf: imageURL){
            DispatchQueue.main.async {
                eiffelImage.image = UIImage(data: data)
            }
        }
    }
}
//: ### Загрузка с помощью асинхронной функции URLSession
func fetchImage1() {
    let task = URLSession.shared.dataTask(with: imageURL){ (data, response, error) in
        if let imageData = data {
            DispatchQueue.main.async {
                print("Show image data")
                eiffelImage.image = UIImage(data: imageData)
            }
            print("Did download  image data")
        }
    }
    task.resume()
}

//: ### Загрузка изображения с помощью DispatchWorkItem
func fetchImage2() {
    var data:Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem (qos:.userInteractive ) {data = try? Data(contentsOf: imageURL)}
//:  Если cancel используется перед async, то workItem не размещается в очереди.
//:  Использование cancel перед async не имеет никакого эффекта
  //  workItem.cancel()
    queue.async(execute: workItem)
    
    workItem.notify(queue: DispatchQueue.main) {
        if let imageData = data {
            eiffelImage.image = UIImage(data: imageData)}
    }
}

//: ### асинхронная обертка синхронной операции - загрузки изображение
func asyncLoadImage(imageURL: URL,
                    runQueue: DispatchQueue,
                    completionQueue: DispatchQueue,
                    completion: @escaping (UIImage?, Error?) -> ()) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async { completion(UIImage(data: data), nil)}
        } catch let error {
            completionQueue.async { completion(nil, error)}
        }
    }
}

//: ### Загрузка изображения с помощью асинхронной обертки синхронной операции
func fetchImage3() {
    asyncLoadImage(imageURL: imageURL,
                   runQueue: DispatchQueue.global(),
                   completionQueue: DispatchQueue.main)
    { result, error in
        guard let image = result else {return}
        eiffelImage.image = image
    }
}

fetchImage2()
//fetchImage1()
//fetchImage2()

//PlaygroundPage.current.finishExecution()
// Остановите Playground вручную, но изображение исчезнет
