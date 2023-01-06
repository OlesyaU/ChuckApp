//
//  ViewController.swift
//  ChuckFirst
//
//  Created by Олеся on 05.01.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var jokeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var actionItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionItem.isEnabled = false
    }
    
    @IBAction func actionItemPush(_ sender: Any) {
        let textJoke = (jokeLabel.text ?? errorLabel.text) as String?
        let activityVC = UIActivityViewController(activityItems: [textJoke ], applicationActivities: nil)
        present(activityVC, animated: true)
        
    }
    
    @IBAction func refreshItemPush(_ sender: Any) {
        Model().downloadJoke { [weak self] textJoke, errorText in
            //           всё что касается интерфейса отправляем на главный поток
            DispatchQueue.main.async {
                
                if let textJoke {
                    self?.jokeLabel.text = textJoke
                    self?.actionItem.isEnabled = true
                }
                
                if let errorText {
                    self?.errorLabel.text = errorText
                    self?.jokeLabel.text = ""
                } else {
                    self?.errorLabel.text = ""
                }
            }
        }
        
    }
}

