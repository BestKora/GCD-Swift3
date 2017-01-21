import UIKit

public class ThreadSafeString {
    private var internalString = ""
    let isolationQueue = DispatchQueue(label:"com.bestkora.isolation",
                                       attributes: .concurrent)
    
    public func addString(string: String) {
        isolationQueue.async(flags: .barrier) {
            self.internalString = self.internalString + string
        }
    }
    public func setString(string: String) {
        isolationQueue.async(flags: .barrier) {
            self.internalString = string
        }
    }
    
    public init (_ string: String){
        isolationQueue.async(flags: .barrier) {
            self.internalString = string
        }
    }
    
    public var text: String {
        var result = ""
        isolationQueue.sync {
            result = self.internalString
        }
        return result
    }
}


public func duration(_ block: () -> ()) -> TimeInterval {
    let startTime = Date()
    block()
    return Date().timeIntervalSince(startTime)
}

public class QueuesView: UIView {
    public var labels: [UILabel] = [UILabel] ()
    public var labels_: [UILabel] = [UILabel] ()
    public var numberLines = 0 {didSet{updateUI()}}
    public var step = 30
    
    func updateUI(){
        print (numberLines)
        for i in 0..<numberLines {
            let label = UILabel (frame: CGRect(x: 10, y: 20 + 50 * i, width: Int(self.bounds.size.width), height: 20))
            label.text = ""
            labels.append (label)
            self.addSubview(label)
            
            let label_ = UILabel (frame: CGRect(x: 0, y: 50 * i, width: Int(self.bounds.size.width), height: 20))
            label_.text = ""
            label_.textColor = UIColor.blue
            labels_.append (label_)
            self.addSubview(label_)
        }
    }
    
    public override init (frame: CGRect) {
        super.init (frame: frame)
        updateUI()
    }
    
   public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
