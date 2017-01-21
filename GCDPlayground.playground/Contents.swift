

import UIKit
import PlaygroundSupport

//: Определяем бесконечное выполнение, чтобы предотвратить "выбрасывание" background tasks, когда "main" thread будет закончена.
PlaygroundPage.current.needsIndefiniteExecution = true

var view = QueuesView (frame: CGRect(x: 0, y: 0, width: 600, height: 500))
view.numberLines = 10
view.backgroundColor = UIColor.lightGray

view.labels_[0].text  =  "     СИНХРОННОСТЬ  global (qos: .userInitiated) к playground"
view.labels_[1].text  =  "     АСИНХРОННОСТЬ  global (qos: .userInitiated) к playground"
view.labels_[2].text  =  "     СИНХРОННОСТЬ   .serial  к playground"
view.labels_[3].text  =  "     АСИНХРОННОСТЬ  .serial  к playground"
view.labels_[4].text  =  "     .serial Q1 - .userInitiated "
view.labels_[5].text  =  "     .serial     Q1 - .userInitiated Q2 - .background"
view.labels_[6].text  =  "     .concurrent Q - .userInitiated"
view.labels_[7].text  =  "     .concurrent Q1 - .userInitiated  Q2 - .background"
view.labels_[8].text  =  "     .concurrent Q1 - .userInitiated Q2 - .background asyncAfter (0.0)"
view.labels_[9].text  =  "     .concurrent Q1 - .userInitiated Q2 - .background asyncAfter (0.1)"

PlaygroundPage.current.liveView = view

//: ## Использование Global Queues
let main = DispatchQueue.main // Глобальная последовательная (serial) main queue

let userQueue = DispatchQueue.global(qos: .userInitiated)  // Глобальная  concurrent.userInitiated dispatch queue
let utilityQueue = DispatchQueue.global(qos: .utility)  // Глобальная concurrent .utility dispatch queue
let background = DispatchQueue.global() // Глобальная concurrent .default dispatch queue


//: ## Некоторые задания:
var safeString = ThreadSafeString("")
var usualString = ""

func task(_ symbol: String) {
    for i in 1...10 {
        print("\(symbol) \(i) приоритет = \(qos_class_self().rawValue)");
        safeString.addString(string: symbol); usualString = usualString + symbol
    }
}

func taskHIGH(_ symbol: String) {
        print("\(symbol) HIGH приоритет = \(qos_class_self().rawValue)");
        safeString.addString(string: symbol); usualString = usualString + symbol
}
//: ## Синхронность и асинхронность
print("---------------------------------------------------")
print("   СИНХРОННОСТЬ  sync ")
print("         Q1 - Global .concurrent qos = .userInitiated")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let duration0 = duration {
    userQueue.sync {task("😀")}
    task("👿")
}
sleep(1)
view.labels[0].text = safeString.text + String(Float(duration0))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("         Q1 - Global .concurrent qos = .userInitiated")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let duration1 = duration {
    userQueue.async {task("😀")}
    task("👿")
}
sleep(1)
view.labels[1].text = safeString.text + String(Float(duration1))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

//: ## Private Serial Queue (последовательная очередь)
//: Единственной глобальной последовательной очередью является `DispatchQueue.main`, но вы можете создавать Private последовательные очереди. Заметьте, что `.serial` (последовательная) - это атрибут по умолчанию для Private Dispatch Queue, его не нужно указывать специально:

//: ###   Последовательная очередь  mySerialQueuP
print("---------------------------------------------------")
print("   СИНХРОННОСТЬ  sync ")
print("         Q1 - Private .serial нет qos ")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let mySerialQueue = DispatchQueue(label: "com.bestkora.mySerial")
let duration2 = duration {
    mySerialQueue.sync { task("😀")}
    task("👿")
}
sleep(1)
view.labels[2].text = safeString.text + String(Float(duration2))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("         Q1 - Private .serial нет qos ")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let duration3 = duration {
    mySerialQueue.async { task("😀")}
    task("👿")
}
sleep(1)
view.labels[3].text = safeString.text + String(Float(duration3))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

//: ###   Последовательная очередь c приоритетом
print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("        Private .serial Q1 - .userInitiated ")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let serialPriorityQueue = DispatchQueue(label: "com.bestkora.serialPriority", qos : .userInitiated)
let duration4 = duration {
    serialPriorityQueue.async { task("😀")}
    serialPriorityQueue.async {task("👿")}
}
sleep (1)
view.labels[4].text = safeString.text + String(Float(duration4))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

//: ###   Последовательные очереди c разными приоритетами
print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("       Private .serial Q1 - .userInitiated")
print("       Private .serial Q2 - .background")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let goodQueue = DispatchQueue(label: "com.bestkora.good", qos : .userInitiated)
let badQueue = DispatchQueue(label: "com.bestkora.bad", qos : .background)
let duration5 = duration {
    goodQueue.async {task("😀") }
    badQueue.async  {task("👿") }
}
sleep(1)
view.labels[5].text = safeString.text + String(Float(duration5))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")


print("---------------------------------------------------")
print("   asynAfter (.userInteractiv) на Q2")
print("   Private .serial    Q1 - .utility")
print("                      Q2 - .background")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let serialUtilityQueue = DispatchQueue(label: "com.bestkora.serialUtilityriority", qos : .utility)
let serialBackgroundQueue = DispatchQueue(label: "com.bestkora.serialBackgroundPriority", qos : .background)

    serialBackgroundQueue.asyncAfter (deadline:  .now() + 0.1, qos: .userInteractive) {task("👿")}
    serialUtilityQueue.async { task("😀")}

sleep(1)
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")
//: ###  highPriorityItem = DispatchWorkItem
let highPriorityItem = DispatchWorkItem (qos: .userInteractive, flags:[.enforceQoS]){
    taskHIGH("🌺")
}
/*let highPriorityItem = DispatchWorkItem(qos: .userInteractive, flags:[.enforceQoS, .assignCurrentContext]) {
 taskHIGH("🌺")
 }*/
//: ## Private Concurrent Queue
//: Для создания private __concurrent__ queue, определяем атрибут `.concurrent`.
//: ###  Параллельная Private очередь c приоритетом
print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("        Private  .concurrent Q - .userInitiated ")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let workerQueue = DispatchQueue(label: "com.bestkora.worker_concurrent", qos: .userInitiated, attributes: .concurrent)
let duration6 = duration {
workerQueue.async  {task("😀")}
workerQueue.async {task("👿")}
}
sleep (1)
view.labels[6].text = safeString.text + String(Float(duration6))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

//: ###   Параллельная очередь c отложенным выполнением
print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print(" Параллельная очередь c отложенным выполнением")
print(" Private  .concurrent Q - .userInitiated, .initiallyInactive")
print("---------------------------------------------------")

let workerDelayQueue = DispatchQueue(label: "com.bestkora.worker_concurrent", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
workerDelayQueue.async  {task("😀")}
workerDelayQueue.async {task("👿")}
sleep (1)

//: ###  Параллельные Private очереди c разными приоритетами
print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("        .concurrent Q1 - .userInitiated ")
print("                    Q2 - .background ")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let workerQueue1 = DispatchQueue(label: "com.bestkora.worker_concurrent1",  qos: .userInitiated, attributes: .concurrent)
let workerQueue2 = DispatchQueue(label: "com.bestkora.worker_concurrent2",  qos: .background, attributes: .concurrent)

let duration7 = duration {
    workerQueue1.async  {task("😀")}
    workerQueue2.async {task("👿")}
    workerQueue1.async(execute: highPriorityItem)
    workerQueue2.async(execute: highPriorityItem)
}
sleep(1)
view.labels[7].text = safeString.text + String(Float(duration7))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

print("---------------------------------------------------")
print(" Выполнение заданий на параллельной очереди с отложенным выполнением")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

workerDelayQueue.activate()
sleep (1)
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

//: ###   asyncAfter c изменением приоритета
print("---------------------------------------------------")
print("   asynAfter (0.0 .userInteractive) на Q2")
print("   Private .concurrent Q1 - .userInitiated")
print("                       Q2 - .background")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""


let duration8 = duration {
workerQueue2.asyncAfter (deadline:  .now() + 0.0, qos: .userInteractive) {task("👿")}
//     workerQueue2.async (qos: .userInteractive) { task("👿")}
    workerQueue1.async { task("😀")}
    workerQueue2.async(execute: highPriorityItem)
    workerQueue1.async(execute: highPriorityItem)
}
sleep(1)
view.labels[8].text = safeString.text + String(Float(duration8))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")

print("---------------------------------------------------")
print("   asynAfter (0.1 .userInteractive) на Q2")
print("   Private .concurrent Q1 - .userInitiated")
print("                       Q2 - .background")
print("---------------------------------------------------")
safeString.setString(string: "")
usualString = ""

let duration9 = duration {
    workerQueue2.asyncAfter (deadline:  .now() + 0.1, qos: .userInteractive) {task("👿")}
    //     workerQueue2.async (qos: .userInteractive) { task("👿")}
    workerQueue1.async { task("😀")}
    workerQueue2.async(execute: highPriorityItem)
    workerQueue1.async(execute: highPriorityItem)
}
sleep(1)
view.labels[9].text = safeString.text + String(Float(duration9))
print ("    threadSafe \(safeString.text)")
print ("not threadSafe \(usualString)")
//----------------------------------------------
//PlaygroundPage.current.finishExecution()
// Остановите Playground вручную, но изображение исчезнет
