//
//  ViewController.swift
//  LiveText
//
//  Created by 五十嵐諒 on 2022/07/03.
//

import UIKit
import VisionKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageAnalysisInteractionDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    let analyzer = ImageAnalyzer()
    let interaction = ImageAnalysisInteraction()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.addInteraction(interaction)
        image = imageView.image
    }

    var image:UIImage? {
        didSet {
            print("ok")
            interaction.preferredInteractionTypes = []
            interaction.analysis = nil
            analyzeCurrentImage()
        }
    }
    
    func analyzeCurrentImage(){
        if let image = image{
            Task{
                let configuration = ImageAnalyzer.Configuration([.text,.machineReadableCode])
                do {
                    let analysis = try await analyzer.analyze(image, configuration: configuration)
                    if let analysis = analysis, image == self.image {
                        interaction.analysis = analysis;
                        interaction.preferredInteractionTypes = .automatic
                    }
                }catch{
                    print(error)
                }
            }
        }
    }
    
    @IBAction func choosePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            
            pickerView.sourceType = .photoLibrary
            
            pickerView.delegate = self
            
            self.present(pickerView, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let tempImage = info[.originalImage] as! UIImage
        imageView.image = tempImage
    
        self.dismiss(animated: true)
        image = imageView.image
    }
}

