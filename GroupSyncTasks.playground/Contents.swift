import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

var view = FourImages(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = UIColor.red

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
                 "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
                 "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png",
                 "http://www.picture-newsletter.com/arctic/arctic-12.jpg" ]

var images = [UIImage] ()

PlaygroundPage.current.liveView = view

//: ### Формируем группу синхронных операций
//: ### по загрузке 4-х изображений

let imageGroup = DispatchGroup()
for i in 0...1 {
    DispatchQueue.global().async(group: imageGroup) {
        if let url = URL(string:imageURLs[i]),
           let data = try? Data(contentsOf:url){
            images.append(UIImage(data:data)!)
             print ("----finished \(i) приоритет = \(qos_class_self().rawValue)")
        }
    }
}

for i in 2...3 {
   DispatchQueue.global(qos: .userInitiated).async(group: imageGroup) {
        if let url = URL(string:imageURLs[i]),
            let data = try? Data(contentsOf:url){
            images.append(UIImage(data:data)!)
            print ("----finished \(i) приоритет = \(qos_class_self().rawValue)")
        }
    }
}

//: ### Блок обратного вызова на всю группу
imageGroup.notify(queue: DispatchQueue.main) {
    for i in 0...3 {
    view.ivs[i].image = images[i]
    }
}

//PlaygroundPage.current.finishExecution()
// Остановите Playground вручную, но изображение исчезнет
