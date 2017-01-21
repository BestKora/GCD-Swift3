//
//  ImageTableViewController.swift
//  GCDTableViewController
//
//  Created by Tatiana Kornilova on 1/20/17.
//  Copyright © 2017 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ImageTableViewController: UITableViewController {
    var imageURLs: [String] =
        ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
         "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
         "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png",
         "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg",
         "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
         "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
         "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png",
         "http://www.picture-newsletter.com/arctic/arctic-12.jpg"]

      // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return imageURLs.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageGCD", for: indexPath)

        if let tweetCell = cell as? ImageTableViewCell {
            tweetCell.imageURL =  URL(string: imageURLs [indexPath.row])
        }
        return cell
    }
}
