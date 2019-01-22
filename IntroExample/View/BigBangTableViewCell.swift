//
//  BigBangTableViewCell.swift
//  IntroExample
//
//  Created by Brandon Askea on 1/21/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit

class BigBangTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.layer.cornerRadius = 6
    }

    func configureWith(_ episode: Episode) {
        seasonLabel.text = "Season \(episode.season)"
        episodeLabel.text = "Episode \(episode.number)"
        nameLabel.text = "\"\(episode.name)\""
        summaryLabel.text = episode.summary
        
        DispatchQueue.global().async {
            
            guard let url = URL(string: episode.imageURL) else { return }
            
            do {
                
                // Download Image
                let imageData = try Data(contentsOf: url)
                
                // Trampoline
                DispatchQueue.main.async {
                    self.cellImageView.image = UIImage(data: imageData)
                }
                
            } catch { return }
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
        seasonLabel.text = ""
        episodeLabel.text = ""
        nameLabel.text = ""
        summaryLabel.text = ""
    }

}
