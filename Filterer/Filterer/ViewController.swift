//  Copyright © 2019 Bhavya Shah. All rights reserved.

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var filterView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var mainImgView: UIImageView!
    @IBOutlet var imgPickerbtn: UIButton!
    @IBOutlet var filterbtn: UIButton!
    @IBOutlet var comparebtn: UIButton!
    @IBOutlet var sharebtn: UIButton!
    
    var originalImg : UIImage?
    var filteredImg : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        originalImg = mainImgView.image
        filterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        if (mainImgView.image == originalImg) {
            comparebtn.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func filterClick(_ sender: UIButton) {
        if(sender.isSelected){
            hideFilterVew()
            sender.isSelected = false
        } else {
            showFilterView()
            sender.isSelected = true
        }
    }
    
    func showFilterView() {
        view.addSubview(filterView)
        let leftConst = filterView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConst = filterView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let bottomConst = filterView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        let height = filterView.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([bottomConst, leftConst, rightConst, height])
        view.layoutIfNeeded()
    }

    func hideFilterVew() {
        filterView.removeFromSuperview()
    }
    
    @IBAction func redFilter(_ sender: UIButton) {
        
    }
    
    @IBAction func greenFilter(_ sender: Any) {
    
    }
    
    @IBAction func sepiaFilter(_ sender: UIButton) {
        filteredImg = sepiaFilter(image: originalImg!)
        mainImgView.image = filteredImg
        comparebtn.isEnabled = true
    }
    
    @IBAction func greyscaleFilter(_ sender: UIButton) {
        filteredImg = greyScale(image: originalImg!)
        mainImgView.image = filteredImg
        comparebtn.isEnabled = true
    }
    
    @IBAction func compare(_ sender: UIButton) {
        if(sender.isSelected){
            mainImgView.image = filteredImg
            sender.isSelected = false
        } else {
            mainImgView.image = originalImg
            sender.isSelected = true
        }
    }
    
    func redFilter(image : UIImage) {
        
    }
    
    func greenFilter(image : UIImage) {
        
    }
    
    func sepiaFilter(image : UIImage) -> UIImage {
        let rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let rVal = pixel.red
                let gVal = pixel.green
                let bVal = pixel.blue
                let newR = (Double(rVal) * 0.393) + (Double(gVal) * 0.769) + (Double(bVal) * 0.189)
                let newG = (Double(rVal) * 0.349) + (Double(gVal) * 0.686) + (Double(bVal) * 0.168)
                let newB = (Double(rVal) * 0.272) + (Double(gVal) * 0.534) + (Double(bVal) * 0.171)
                pixel.red = UInt8(max(min(255,newR),0))
                pixel.green = UInt8(max(min(255,newG),0))
                pixel.blue = UInt8(max(min(255,newB),0))
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    func greyScale(image : UIImage) -> UIImage {
        let rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let avgColor = Double(Int(pixel.red) + Int(pixel.green) + Int(pixel.blue)) / 3.0
                pixel.red = UInt8(avgColor)
                pixel.green = UInt8(avgColor)
                pixel.blue = UInt8(avgColor)
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
}
