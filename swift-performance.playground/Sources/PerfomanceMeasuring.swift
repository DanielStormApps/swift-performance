import Foundation

public typealias MeasuredBlock = ()->Void

public func measureBlock(name:String, iterations:Int = 1, forBlock block:MeasuredBlock)->Dictionary<String,AnyObject> {
    precondition(iterations > 0, "Iterations must be greater than 0, but we default to 1 for you...")
    precondition(name.characters.count > 0, "A name must be set. If you want to see results.")
    
    var total:Double = 0.0
    var cases = [Double]()
    
    for _ in stride(from: 1, through: iterations, by: 1) {
        let start = NSDate.timeIntervalSinceReferenceDate()
        block()
        let took = Double(NSDate.timeIntervalSinceReferenceDate() - start)
        cases.append(took)
        total += took
    }
    
    let mean = total / Double(iterations)
    
    var deviation = 0.0
    
    for result in cases {
        let difference = result - mean
        deviation += difference*difference
    }
    
    let variance = deviation / Double(iterations)
    
    let average = mean.milliseconds()
    let stdDeviation = variance.milliseconds()
    
    let time = total / Double(iterations)
    let results = ["Name":name, "Time Taken":time, "Average":average, "Std Deviation": stdDeviation]
    return results as! Dictionary<String, AnyObject>
}

extension Double {
    func milliseconds()->String {
        return String(format: "%.2lf ms", (self * 1000))
    }
}