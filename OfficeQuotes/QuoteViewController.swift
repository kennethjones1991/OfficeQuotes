//
//  QuoteViewController.swift
//  OfficeQuotes
//
//  Created by Kenneth Jones on 3/13/21.
//

import UIKit

class QuoteViewController: UIViewController {
    
    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var getQuoteButton: UIButton!
    
    var quoteController = QuoteController()
    var quote: Quote?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getQuoteButton.backgroundColor = UIColor(hue: 180/360, saturation: 56/100, brightness: 53/100, alpha: 1.0)
        getQuoteButton.tintColor = .white
        getQuoteButton.layer.cornerRadius = 8.0
        
        quoteTextView.text = ""
        characterLabel.text = ""
        
        quoteTextView.isHidden = true
    }

    @IBAction func getRandomQuote(_ sender: Any) {
        quoteController.fetchQuote() { (result) in
            DispatchQueue.main.async {
                do {
                    self.quote = try result.get()
                    self.updateViews()
                } catch {
                    let alertController = UIAlertController(title: "No Data", message: "No quotes available at this time.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Well darn it", style: .default, handler: nil)
                    
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    private func updateViews() {
        guard let quote = quote else { return }
        
        quoteTextView.isHidden = false
        quoteTextView.text = "\"\(quote.quote)\""
        characterLabel.text = "-\(quote.firstName) \(quote.lastName)"
        characterImageView.image = UIImage(named: quote.firstName.lowercased())
    }
}
