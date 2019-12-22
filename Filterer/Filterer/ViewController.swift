//  Copyright © 2019 Bhavya Shah. All rights reserved.

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var ogTxtView: UIView!
    @IBOutlet var filterView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var mainImgView: UIImageView!
    @IBOutlet var imgPickerbtn: UIButton!
    @IBOutlet var filterbtn: UIButton!
    @IBOutlet var comparebtn: UIButton!
    @IBOutlet var sharebtn: UIButton!
    @IBOutlet var intensityView: UIView!
    @IBOutlet var editSlider: UISlider!
    @IBOutlet var editOptionbtn: UIButton!
    
    var originalImg : UIImage?
    var filteredImg : UIImage?
    var currFilter : String?
    var filterSliderVal : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        originalImg = mainImgView.image
        comparebtn.isEnabled = false
        editOptionbtn.isEnabled = false
        filterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        intensityView.backgroundColor = nil
        intensityView.translatesAutoresizingMaskIntoConstraints = false
        ogTxtView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        ogTxtView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func share(_ sender: UIButton) {
        let shareWindow = UIActivityViewController(activityItems: [mainImgView.image!], applicationActivities: nil)
        present(shareWindow, animated: true, completion: nil)
    }
    
    func showOgTxt() {
        view.addSubview(ogTxtView)
        let leftConst = ogTxtView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let topConst = ogTxtView.topAnchor.constraint(equalTo: view.topAnchor)
        let heightConst = ogTxtView.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([leftConst, topConst, heightConst])
        view.layoutIfNeeded()
    }
    
    @IBAction func newPhoto(_ sender: UIButton) {
        let newPhotosAction = UIAlertController(title: "Select Photo", message: nil, preferredStyle: .actionSheet)
        newPhotosAction.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.bringUpCamera()
        }))
        newPhotosAction.addAction(UIAlertAction(title: "Photos", style: .default, handler: { action in
            self.bringUpAlbum()
        }))
        newPhotosAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        self.present(newPhotosAction, animated: true, completion: nil)
    }
    
    func bringUpCamera() {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = .camera
        present(camera, animated: true, completion: nil)
    }
    
    func bringUpAlbum() {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = .photoLibrary
        present(camera, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let pickedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        mainImgView.image = pickedImg
        originalImg = pickedImg
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func filterClick(_ sender: UIButton) {
        if(sender.isSelected){
            hideFilterVew()
            sender.isSelected = false
        } else {
            hideIntensityView()
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
    
    @IBAction func red(_ sender: UIButton) {
        //..............
    }
    
    func red(image: UIImage, intensity: Double) -> UIImage {
        //............
        return image
    }
    
    @IBAction func green(_ sender: UIButton) {
        editSlider.minimumValue = 1
        editSlider.maximumValue = 5
        editSlider.value = 2.5
        currFilter = "red"
        editOptionbtn.isEnabled = true
        UIView.animate(withDuration: 1, animations: {
            self.filteredImg = self.green(image: self.originalImg!, intensity: 2.5)
            self.mainImgView.image = self.filteredImg
            self.comparebtn.isEnabled = true
        })
    }
    
    func green(image: UIImage, intensity: Double) -> UIImage {
        let rgbaImage = RGBAImage(image: image)!
        var tred = 0
        var tblue = 0
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                let pixel = rgbaImage.pixels[index]
                tred += Int(pixel.red)
                tblue += Int(pixel.blue)
            }
        }
        let avgRed = tred / (rgbaImage.width * rgbaImage.height)
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let redDiff = Int(pixel.red) - avgRed
                pixel.red = UInt8( max (0, min (255, Double(redDiff)*intensity)))
                pixel.blue = UInt8( max (0, min (255, Double(redDiff)*intensity)))
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    @IBAction func contrast(_ sender: UIButton) {
        editSlider.minimumValue = -10
        editSlider.maximumValue = 1000
        editSlider.value = 400
        currFilter = "contrast"
        editOptionbtn.isEnabled = true
        UIView.animate(withDuration: 1, animations: {
            self.filteredImg = self.incContrast(image: self.originalImg!, intensity: 0)
            self.mainImgView.image = self.filteredImg
            self.comparebtn.isEnabled = true
        })
    }
    
    func incContrast(image: UIImage, intensity: Double) -> (UIImage) {
        let rgbaImage = RGBAImage(image: image)!
        var tRed = 0
        var tGreen = 0
        var tBlue = 0
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                let pixel = rgbaImage.pixels[index]
                tRed += Int(pixel.red)
                tGreen += Int(pixel.green)
                tBlue += Int(pixel.blue)
            }
        }
        let pCount = rgbaImage.width * rgbaImage.height
        let avgRed = tRed / pCount
        let avgGreen = tGreen / pCount
        let avgBlue = tBlue / pCount
        let sum = avgRed + avgGreen + avgBlue
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let rDelta = Double(pixel.red) - Double(avgRed)
                let gDelta = Double(pixel.green) - Double(avgGreen)
                let bDelta = Double(pixel.blue) - Double(avgBlue)
                //initialized with passed or default Contrast Value
                var modifier = intensity
                if(Int(pixel.red) + Int(pixel.green) + Int(pixel.blue) < sum ){
                    modifier = 1
                }
                pixel.red = UInt8(max(min(255,Double(avgRed) + modifier * rDelta),0))
                pixel.green = UInt8(max(min(255,Double(avgGreen) + modifier * gDelta),0))
                pixel.blue = UInt8(max(min(255,Double(avgBlue) + modifier * bDelta),0))
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    @IBAction func sepiaFilter(_ sender: UIButton) {
        editSlider.minimumValue = -0.5
        editSlider.maximumValue = 1
        editSlider.value = 0.3
        currFilter = "sepia"
        editOptionbtn.isEnabled = true
        UIView.animate(withDuration: 1, animations: {
            self.filteredImg = self.sepiaFilter(image: self.originalImg!, intensity: 0)
            self.mainImgView.image = self.filteredImg
            self.comparebtn.isEnabled = true
        })
    }
    
    
    func sepiaFilter(image : UIImage, intensity : Double) -> UIImage {
        let rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let rVal = pixel.red
                let gVal = pixel.green
                let bVal = pixel.blue
                let newR = (Double(rVal) * (0.393+intensity)) + (Double(gVal) * (0.769+intensity)) + (Double(bVal) * (0.189+intensity))
                let newG = (Double(rVal) * (0.349+intensity)) + (Double(gVal) * (0.686+intensity)) + (Double(bVal) * (0.168+intensity))
                let newB = (Double(rVal) * (0.272+intensity)) + (Double(gVal) * (0.534+intensity)) + (Double(bVal) * (0.171+intensity))
                pixel.red = UInt8(max(min(255,newR),0))
                pixel.green = UInt8(max(min(255,newG),0))
                pixel.blue = UInt8(max(min(255,newB),0))
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    @IBAction func greyscaleFilter(_ sender: UIButton) {
        editSlider.minimumValue = -5
        editSlider.maximumValue = 40
        editSlider.value = 15
        currFilter = "grey"
        editOptionbtn.isEnabled = true
        UIView.animate(withDuration: 1, animations: {
            self.filteredImg = self.greyScale(image: self.originalImg!, intensity: 3)
            self.mainImgView.image = self.filteredImg
            self.comparebtn.isEnabled = true
        })
    }
    
    func greyScale(image : UIImage, intensity : Double) -> UIImage {
        let rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                var pixel = rgbaImage.pixels[index]
                let avgColor = Double(Int(pixel.red) + Int(pixel.green) + Int(pixel.blue)) / intensity
                pixel.red = UInt8(avgColor)
                pixel.green = UInt8(avgColor)
                pixel.blue = UInt8(avgColor)
                rgbaImage.pixels[index] = pixel
            }
        }
        return rgbaImage.toUIImage()!
    }
    
    @IBAction func compare(_ sender: UIButton) {
        if(sender.isSelected){
            mainImgView.image = filteredImg
            sender.isSelected = false
        } else {
            editOptionbtn.isEnabled = false
            mainImgView.image = originalImg
            sender.isSelected = true
        }
    }
    
    @IBAction func filterIntensity(_ sender: UIButton) {
        if(sender.isSelected){
            hideIntensityView()
            sender.isSelected = false
        } else {
            hideFilterVew()
            showIntensityView()
            sender.isSelected = true
        }
    }
    
    func showIntensityView() {
        view.addSubview(intensityView)
        let leftConst = intensityView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConst = intensityView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let bottomConst = intensityView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        let height = intensityView.heightAnchor.constraint(equalToConstant: 44)
        NSLayoutConstraint.activate([bottomConst, leftConst, rightConst, height])
        view.layoutIfNeeded()
    }
    
    func hideIntensityView() {
        intensityView.removeFromSuperview()
    }
    
    @IBAction func filterSlider(_ sender: UISlider) {
        switch currFilter {
        case "sepia":
            mainImgView.image = sepiaFilter(image: originalImg!, intensity: Double(sender.value))
        case "grey":
            mainImgView.image = greyScale(image: originalImg!, intensity: Double(sender.value))
        case "contrast":
            mainImgView.image = incContrast(image: originalImg!, intensity: Double(sender.value))
        case "red":
            mainImgView.image = red(image: originalImg!, intensity: Double(sender.value))
        default:
            filterSliderVal = 0
        }
    }
}
