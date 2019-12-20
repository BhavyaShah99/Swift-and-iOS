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
    @IBOutlet var intensityView: UIView!
    @IBOutlet var editSlider: UISlider!
    
    var originalImg : UIImage?
    var filteredImg : UIImage?
    var currFilter : String?
    var filterSliderVal : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        originalImg = mainImgView.image
        filterView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        intensityView.backgroundColor = nil
        intensityView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        originalImg = mainImgView.image
    }
    
    func bringUpAlbum() {
        let camera = UIImagePickerController()
        camera.delegate = self
        camera.sourceType = .photoLibrary
        present(camera, animated: true, completion: nil)
        originalImg = mainImgView.image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let pickedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        mainImgView.image = pickedImg
        originalImg = mainImgView.image
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
    
    @IBAction func sepiaFilter(_ sender: UIButton) {
        editSlider.minimumValue = -0.5
        editSlider.maximumValue = 1
        editSlider.value = 0.3
        currFilter = "sepia"
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
        editSlider.minimumValue = 0
        editSlider.maximumValue = 40
        editSlider.value = 20
        currFilter = "grey"
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
        default:
            filterSliderVal = 0
        }
    }
}
