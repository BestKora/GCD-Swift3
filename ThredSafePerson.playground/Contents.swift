
import PlaygroundSupport
// https://videos.raywenderlich.com/courses/ios-concurrency-with-gcd-and-operations/lessons/11

//: Определяем бесконечное выполнение, чтобы предотвратить "выбрасывание" background tasks, когда работа на playground будет закончена.

PlaygroundPage.current.needsIndefiniteExecution = true


import Foundation

func randomDelay(maxDuration: Double) {
    let randomWait = arc4random_uniform(UInt32(maxDuration * Double(USEC_PER_SEC)))
    usleep(randomWait)
}

class Person {
    private var firstName: String
    private var lastName: String
    
    public init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    public func changeName(firstName: String, lastName: String) {
        randomDelay(maxDuration: 0.2)
        self.firstName = firstName
        randomDelay(maxDuration: 1)
        self.lastName = lastName
    }
    
    public var name: String {
        return "\(firstName) \(lastName)"
    }
}

class ThreadSafeName {
    private var firstName: String
    let isolationQueue = DispatchQueue(label:"com.raywenderlich.person.isolation",  attributes: .concurrent)
    
    public init(firstName: String) {
        self.firstName = firstName
    }
    
    public func addName(lastName: String) {
        isolationQueue.async(flags: .barrier) {
            self.firstName = self.firstName + lastName
        }
    }
    
   public var name: String {
        var result = ""
        isolationQueue.sync {
            result = self.firstName
        }
        return result
    }
}

let nameChangingPerson = Person(firstName: "Alison", lastName: "Anderson")

//: The `Person` class includes a method to change names:

nameChangingPerson.changeName(firstName: "Brian", lastName: "Biggles")
nameChangingPerson.name

let workerQueue = DispatchQueue (label: "com.bestkora.con", attributes: .concurrent)
let nameChangeGroup = DispatchGroup()

let nameList = [("Charlie", "Cheesecale"), ("Delia", "Dingle"), ("Eva", "Evershed"),("Freddie", "Frost"),("Gina", "Gregory")]

//for (idx, name) in nameList.enumerated() {
//    workerQueue.async(group: nameChangeGroup) {
//        usleep(UInt32(10_000 * idx))
//        nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
//        print ("Current Name: \(nameChangingPerson.name)")
//    }
//}
//
//nameChangeGroup.notify(queue: DispatchQueue.global()) {
//  print ("Final name: \(nameChangingPerson.name)")
//  PlaygroundPage.current.finishExecution()
//}
//nameChangeGroup.wait()

class ThreadSafePerson: Person {
    
    let isolationQueue = DispatchQueue(label:"com.raywenderlich.person.isolation",  attributes: .concurrent)
    
    override func changeName(firstName: String, lastName: String) {
        isolationQueue.async(flags: .barrier) {
            super.changeName(firstName: firstName, lastName: lastName)
        }
    }
    
    override var name: String {
        var result = ""
       isolationQueue.sync {
            result = super.name
        }
        return result
    }
}

let threadSafeNameGroup = DispatchGroup()

let threadSafePerson = ThreadSafePerson(firstName: "Anna", lastName: "Adams")
let safeName = ThreadSafeName(firstName: "👿")

for (idx, name) in nameList.enumerated() {
    workerQueue.async(group: threadSafeNameGroup) {
        usleep(UInt32(10_000 * idx))
        threadSafePerson.changeName(firstName: name.0, lastName: name.1)
        print ("Current Name: \( threadSafePerson.name)")
    }
}

threadSafeNameGroup.notify(queue: DispatchQueue.global()) {
    print ("Final name: \( threadSafePerson.name)")
    PlaygroundPage.current.finishExecution()
}

for i in 0..<5 {
    workerQueue.async{safeName.addName(lastName: "😀")
    }
    print ("new Name:  \(safeName.name)")
}


