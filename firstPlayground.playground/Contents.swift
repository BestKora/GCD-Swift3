import UIKit
import PlaygroundSupport
//: Определяем бесконечное выполнение, чтобы предотвратить "выбрасывание" background tasks, когда работа на Playground будет закончена.
PlaygroundPage.current.needsIndefiniteExecution = true
//: ## Использование Global Queues
//: 1. Глобальная последовательная (serial) main queue
let mainQueue = DispatchQueue.main
//: 2. Глобальные  concurrent dispatch queues
let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userQueue = DispatchQueue.global(qos: .userInitiated)
let utilityQueue = DispatchQueue.global(qos:  .utility)
let backgroundQueue = DispatchQueue.global(qos:  .background)
//: ------Глобальная concurrent .default dispatch queue --------
let defaultQueue = DispatchQueue.global() // .default
//: ## Задания:
func task(_ symbol: String) { for i in 1...10 {
    print("\(symbol) \(i) приоритет = \(qos_class_self().rawValue)")
    }
}

func taskHIGH(_ symbol: String) {
    print("\(symbol) HIGH приоритет = \(qos_class_self().rawValue)")
}
//: ## Синхронность и асинхронность
print("---------------------------------------------------")
print("   СИНХРОННОСТЬ sync ")
print("   Global .concurrent Q1 - .userInitiated ")
print("---------------------------------------------------")
userQueue.sync {task("😀")}
task("👿")
sleep (2)

print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("   Global .concurrent Q1 - .userInitiated ")
print("---------------------------------------------------")
userQueue.async {task("😀")}
task("👿")
//: ## Private Serial Queue (последовательная очередь)
//: Единственной глобальной последовательной очередью является `DispatchQueue.main`, но вы можете создавать Private последовательные очереди. Заметьте, что атрибут `.serial` (последовательная) задается по умолчанию для Private Dispatch Queue, его не нужно указывать специально:
//: ###   Последовательная очередь  mySerialQueue
let mySerialQueue = DispatchQueue(label: "com.bestkora.mySerial")

print("---------------------------------------------------")
print("   СИНХРОННОСТЬ sync ")
print("   Private .serial Q1 - no ")
print("---------------------------------------------------")

mySerialQueue.sync { task("😀")}
task("👿")

print("---------------------------------------------------")
print("   АСИНХРОННОСТЬ async ")
print("   Private .serial Q1 - no ")
print("---------------------------------------------------")
mySerialQueue.async { task("😀")}
task("👿")

//: ###   Последовательная очередь c приоритетом
print("---------------------------------------------------")
print("   Private .serial Q1 - .userInitiated ")
print("---------------------------------------------------")
let serialPriorityQueue = DispatchQueue(label: "com.bestkora.serialPriority", qos : .userInitiated)
serialPriorityQueue.async { task("😀")}
serialPriorityQueue.async {task("👿")}
sleep (1)

//: ###   Последовательные очереди c разными приоритетами
print("---------------------------------------------------")
print("   Private .serial Q1 - .userInitiated")
print("                   Q2 - .background ")
print("---------------------------------------------------")

let serialPriorityQueue1 = DispatchQueue(label: "com.bestkora.serialPriority", qos : .userInitiated)
let serialPriorityQueue2 = DispatchQueue(label: "com.bestkora.serialPriority", qos : .background)
serialPriorityQueue2.async { task("😀")}
serialPriorityQueue1.async {task("👿")}
sleep (1)

//: ###   asyncAfter c изменением приоритета
print("---------------------------------------------------")
print("   asynAfter (.userInteractiv) на Q2")
print("   Private .serial Q1 - .utility")
print("                   Q2 - .background")
print("---------------------------------------------------")
let serialUtilityQueue = DispatchQueue(label: "com.bestkora.serialUtilityriority", qos : .utility)
let serialBackgroundQueue = DispatchQueue(label: "com.bestkora.serialBackgroundPriority", qos : .background)

serialBackgroundQueue.asyncAfter (deadline:  .now() + 0.1, qos: .userInteractive) {task("👿")}
serialUtilityQueue.async { task("😀")}
sleep (1)

//: ###  highPriorityItem = DispatchWorkItem
let highPriorityItem = DispatchWorkItem (qos: .userInteractive, flags:[.enforceQoS]){
    taskHIGH("🌺")
}

/*let highPriorityItem = DispatchWorkItem(qos: .userInteractive, flags:[.enforceQoS, .assignCurrentContext]) {
 taskHIGH("🌺")
 }*/

//: ## Private Concurrent Queue (параллельная очередь)
//: Для создания private __concurrent__ queue необходимо в качестве аргумента attributes задать `.concurrent`.
//: ###  Параллельная Private очередь c приоритетом
print("---------------------------------------------------")
print(" Private  .concurrent Q - .userInitiated ")
print("---------------------------------------------------")
let workerQueue = DispatchQueue(label: "com.bestkora.worker_concurrent", qos: .userInitiated, attributes: .concurrent)
workerQueue.async  {task("😀")}
workerQueue.async {task("👿")}
sleep (2)

//: ###   Параллельная очередь c отложенным выполнением
print("---------------------------------------------------")
print(" Параллельная очередь c отложенным выполнением")
print(" Private  .concurrent Q - .userInitiated, .initiallyInactive")
print("---------------------------------------------------")

let workerDelayQueue = DispatchQueue(label: "com.bestkora.worker_concurrent", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
workerDelayQueue.async  {task("😀")}
workerDelayQueue.async {task("👿")}
sleep (1)

//: ### Параллельные очереди c разными приоритетами
print("---------------------------------------------------")
print("    .concurrent Q1 - .userInitiated ")
print("                Q2 - .background ")
print("---------------------------------------------------")

let workerQueue1 = DispatchQueue(label: "com.bestkora.worker_concurrent1",  qos: .userInitiated, attributes: .concurrent)
let workerQueue2 = DispatchQueue(label: "com.bestkora.worker_concurrent1",  qos: .background, attributes: .concurrent)

workerQueue2.async  {task("😀")}
workerQueue1.async {task("👿")}
//workerQueue1.async(execute: highPriorityItem)
//workerQueue2.async(execute: highPriorityItem)
sleep (1)

print("---------------------------------------------------")
print(" Выполнение заданий на параллельной очереди")
print(" с отложенным выполнением")
print("---------------------------------------------------")
workerDelayQueue.activate()
sleep (1)

//: ###   asyncAfter c изменением приоритета
print("---------------------------------------------------")
print("   asynAfter (.userInteractive) на Q2")
print("   Private .concurrent Q1 - .userInitiated")
print("                       Q2 - .background")
print("---------------------------------------------------")

workerQueue2.asyncAfter (deadline:  .now() + 0.1, qos: .userInteractive) {task("👿")}
workerQueue1.async { task("😀")}
workerQueue2.async(execute: highPriorityItem)
workerQueue1.async(execute: highPriorityItem)
sleep (1)

//: ##  СИНХРОННОЕ переключение между очередями
//: Нужно быть очень внимательным с методом `sync` для очередей, потому что "текущий поток" вынужден ждать окончания выполнения задания на другой очереди. **НИКОГДА НЕ** вызывайте метод `sync` на  **main queue,** потому что это приведет к deadlock вашего приложения!
//:
//: Но `sync` очень полезный метод для того, чтобы избежать race conditions — если очередь - serial queue, то единственный способ, каким можно получить гарантированно правильное значение - это использовать метод sync как  _mutual exclusion lock_ (взаимоисключающая блокировка).
//:
//: Мы можем воспроизвести простейший случай race condition, если будем изменять переменную `value` асинхронно на private очереди, а показывать `value` на текущем потоке:
print("--- Имитация race condition ---")

var value = "😇"
func changeValue(variant: Int) {
    sleep(1)
    value = value + "🐔"; print ("\(value) - \(variant)");
}
//: Запускаем `changeValue()` АСИНХРОННО и показываем `value` на текущем потоке
mySerialQueue.async {
    changeValue(variant: 1)
}
value
//: Теперь переустановим `value`, а затем выполним `changeValue()` __СИНХРОННО__, блокируя текущий поток до тех пор, пока задание `changeValue` не закончится, убирая таким образом race condition:
value = "🦊"
mySerialQueue.sync {
    changeValue(variant:2)
}
value
sleep(3)

//: Запускаем `changeValue()` СИНХРОННО и показываем `value` на текущем потоке
print("--- Убираем race condition с помощью sync---")
value = "😇"
mySerialQueue.sync {
    changeValue(variant: 1)
}
value
//: Теперь переустановим `value`, а затем выполним `changeValue()` __СИНХРОННО__, блокируя текущий поток до тех пор, пока задание `changeValue` не закончится, убирая таким образом race condition:

value = "🦊"
mySerialQueue.sync {
    changeValue(variant:2)
}
value
sleep(2)
//: ## Playground и Приложение
//: Замечание: Необходимо закомментировать предложение finishExecution чтобы посмотреть результат на main queue в отладочной области и включить Ассистента Редактора, если вы хотите увидеть UI
//: #### Запускаем простейшее задание на main queue
mainQueue.async {
    let a = 0
    print("main queue: a = \(a)")
}
print("Running on default queue")
//: #### Запускаем то же самое задание на default queue
defaultQueue.async {
    let a = 42
    print("default queue: a = \(a)")
}
//: ####  Даем некоторое время для завершения заданий перед завершения работы  playground:
sleep(2)
//PlaygroundPage.current.finishExecution()
//: ####  Остановите Playground вручную, если вы комментируете finishExecution()
