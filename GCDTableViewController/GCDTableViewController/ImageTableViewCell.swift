//
//  imageTableViewCell.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/6/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Public API
    var imageURL: URL? {
        didSet {
            tImage?.image = nil
            updateUI()
        }
    }
    
    private func updateUI() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.tImage?.image = UIImage(data: imageData)
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }

    /*
     print (" ---- start-----")
     print (" imageURL = \(self.lastPart(self.imageURL!))")
     print ("      url = \(self.lastPart(url))")
     
     print ("          ---- finish -----")
     print ("           imageURL = \(self.lastPart(self.imageURL!))")
     print ("                url = \(self.lastPart(url))")

     
     //            if url == self.imageURL {

    //          }
 
*/
    private func lastPart(_ url:URL) -> String {
        let part = "\(url)".components(separatedBy: "/").last?.substring(with: 0..<5)
        if let l = part {
            switch l
            {
            case "franc":
                return "Эйфелева башня"
            case "canal":
                return "Венеция"
            case "Scree":
                return "Шотландия"
            case "pia03":
                return "Кассини"
            case "arcti":
                return "Арктика"
                
            default:
                return l
            }
        }
        return "\(url)"
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
 
