//
//  EpisodeViewController.swift
//  OfficeQuotes
//
//  Created by Kenneth Jones on 3/13/21.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var getEpisodeButton: UIButton!
    
    var episodeController = EpisodeController()
    var episode: Episode?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    let datePrinter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getEpisodeButton.backgroundColor = UIColor(hue: 180/360, saturation: 56/100, brightness: 53/100, alpha: 1.0)
        getEpisodeButton.tintColor = .white
        getEpisodeButton.layer.cornerRadius = 8.0
        
        descriptionTextView.text = ""
        titleLabel.text = ""
        dateLabel.text = ""
        
        descriptionTextView.isHidden = true
    }
    
    @IBAction func getRandomEpisode(_ sender: Any) {
        episodeController.fetchEpisode() { (result) in
            DispatchQueue.main.async {
                do {
                    self.episode = try result.get()
                    self.updateViews()
                } catch {
                    let alertController = UIAlertController(title: "No Data", message: "No episodes available at this time.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Well darn it", style: .default, handler: nil)
                    
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    private func updateViews() {
        guard let episode = episode else { return }
        
        descriptionTextView.isHidden = false
        descriptionTextView.text = episode.description
        titleLabel.text = episode.title
        
        if let airDate = dateFormatter.date(from: episode.airDate) {
            dateLabel.text = "Date aired: \(datePrinter.string(from: airDate))"
        }
    }
}
