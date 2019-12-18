// Applying differnt filters to images by playing around with pixels

import UIKit

let image = UIImage(named: "sample")!

class Filters {
    var img : UIImage
    var filtName : String?
    var modVal: Int
    
    init(img refImg: UIImage, filtName fName : String = "sepia", modVal modifierVal : Int = 10) {
        img = refImg
        filtName = fName
        modVal = modifierVal
    }
    
    
    func applyFilters() -> (UIImage) {
        var retImg: UIImage = UIImage()
        if(filtName=="sepia") {
            retImg = sepiaEffect(image:img)
        }
        else if (filtName=="contrast") {
            retImg = incContrast(image:img)
        }
        else if(filtName=="greyscale") {
            retImg = greyScale(image:img)
        }
        return retImg
    }
    
    func sepiaEffect(image: UIImage) -> (UIImage) {
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
    
    func incContrast(image: UIImage) -> (UIImage) {
        
        
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
                let rDelta = Int(pixel.red) - avgRed
                let gDelta = Int(pixel.green) - avgGreen
                let bDelta = Int(pixel.blue) - avgBlue
                //initialized with passed or default Contrast Value
                var modifier = modVal
                if(Int(pixel.red) + Int(pixel.green) + Int(pixel.blue) < sum )
                {
                    modifier = 1
                }
                pixel.red = UInt8(max(min(255,avgRed + modifier * rDelta),0))
                pixel.green = UInt8(max(min(255,avgGreen + modifier * gDelta),0))
                pixel.blue = UInt8(max(min(255,avgBlue + modifier * bDelta),0))
                rgbaImage.pixels[index] = pixel
            }
        }
        
        return rgbaImage.toUIImage()!
    }
    

    
    func greyScale(image: UIImage) -> (UIImage) {
        
        
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

var a : Filters = Filters(img: image, filtName: "sepia", modVal: 60)
var filteredImg = a.applyFilters()

filteredImg = Filters(img: image, filtName: "contrast", modVal: 40).applyFilters()
filteredImg = Filters(img: image, filtName: "greyscale").applyFilters()

