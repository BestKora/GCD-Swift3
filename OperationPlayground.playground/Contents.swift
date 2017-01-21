//: Дожидаемся загрузки всех 4-х изображений и только потом выводим их все на экран

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

func downloadImageWithURL(_ url:String) -> UIImage! {
    
    let data = try? Data(contentsOf: URL(string: url)!)
    return UIImage(data: data!)
}

func duration(_ block: () -> ()) -> TimeInterval {
    let startTime = Date()
    block()
    return Date().timeIntervalSince(startTime)
}


var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
view.backgroundColor = UIColor.red

var image1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
image1.backgroundColor = UIColor.yellow
view.addSubview(image1)

var image2 = UIImageView(frame: CGRect(x: 100, y: 0, width: 100, height: 100))
image2.backgroundColor = UIColor.blue
view.addSubview(image2)

var image3 = UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
image3.backgroundColor = UIColor.green
view.addSubview(image3)

var image4 = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
image4.backgroundColor = UIColor.brown
view.addSubview(image4)

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png", "http://www.picture-newsletter.com/arctic/arctic-12.jpg" ]

/*var img1I : UIImage?
var img2I : UIImage?
var img3I : UIImage?
var img4I : UIImage?*/
var im = [UIImage] ()

PlaygroundPage.current.liveView = view

let queue = OperationQueue()
queue.maxConcurrentOperationCount = 5

let operation1 = BlockOperation(block: {
  im.append (downloadImageWithURL(imageURLs[0]))
  /*  OperationQueue.main.addOperation({
        image1.image = im[0]
    })*/

})
operation1.qualityOfService = .userInitiated
let operation2 = BlockOperation(block: {
    im.append (downloadImageWithURL(imageURLs[1]))
   /* OperationQueue.main.addOperation({
        image2.image = im[1]
    })*/
})
let operation3 = BlockOperation(block: {
    im.append ( downloadImageWithURL(imageURLs[2]))
  /*  OperationQueue.main.addOperation({
        image3.image = im[2]
    })*/
})

let operation4 = BlockOperation(block: {
    im.append ( downloadImageWithURL(imageURLs[3]))
 /*    OperationQueue.main.addOperation({
        image4.image = im[3]
    })*/
})
let operation5 = BlockOperation(block: {
        OperationQueue.main.addOperation({
            image1.image = im[0]
            image2.image = im[1]
            image3.image = im[2]
            image4.image = im[3]
    })
})


operation1.completionBlock = {
    print("Operation 1 completed, cancelled:\(operation1.isCancelled)")
}
operation2.completionBlock = {
    print("Operation 2 completed, cancelled:\(operation2.isCancelled)")
}
operation3.completionBlock = {
    print("Operation 3 completed, cancelled:\(operation3.isCancelled)")
}
operation4.completionBlock = {
    print("Operation 4 completed, cancelled:\(operation4.isCancelled)")
}
operation5.completionBlock = {
    print("Operation 5 completed, cancelled:\(operation5.isCancelled)")
}

operation5.addDependency(operation1)
operation5.addDependency(operation2)
operation5.addDependency(operation3)
operation5.addDependency(operation4)

duration {
queue.addOperation(operation1)
queue.addOperation(operation2)
queue.addOperation(operation3)
queue.addOperation(operation4)
queue.addOperation(operation5)
}
//queue.waitUntilAllOperationsAreFinished()
 
//PlaygroundPage.current.finishExecution()
// Остановите Playground вручную, но изображение исчезнет

