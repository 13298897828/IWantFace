//
//  Visage.swift
//  FaceDetection
//
//  Created by Julian Abentheuer on 21.12.14.
//  Copyright (c) 2014 Aaron Abentheuer. All rights reserved.
//

import UIKit
import CoreImage
import AVFoundation
import ImageIO
import AssetsLibrary
import Photos
typealias blockALpha = () -> ()
class Visage: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let idfv = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var timeString: String? = nil
    var exif = AnyObject!()
    var ImgData = NSData!()
    var timer: NSTimer = NSTimer()
    let cameraVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CameraViewController") as! CameraViewController
    var blockss: blockALpha?
    var blockno:blockALpha?
    enum DetectorAccuracy {
        case BatterySaving
        case HigherPerformance
    }
    
    enum CameraDevice {
        case ISightCamera
        case FaceTimeCamera
    }
    
    var onlyFireNotificatonOnStatusChange : Bool = true
    var visageCameraView : UIView = UIView(frame: CGRectMake(0, 0, 250, 250))
    var url: NSURL?
    // Grab the path, make sure to add it to your project!
    var nearSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("near", ofType: "wav")!)
    var duSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dudu", ofType: "wav")!)
    var farSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("far", ofType: "wav")!)
    var nearAudioPlayer = AVAudioPlayer()
    var duAudioPlayer = AVAudioPlayer()
    var farAudioPlayer = AVAudioPlayer()
    
    //Private properties of the detected face that can be accessed (read-only) by other classes.
    
    
    private(set) var faceDetected : Bool?
    private(set) var faceBounds : CGRect?
    private(set) var leftEyeClosed : Bool?
    private(set) var rightEyeClosed : Bool?
    
    //Notifications you can subscribe to for reacting to changes in the detected properties.
    private let visageNoFaceDetectedNotification = NSNotification(name: "visageNoFaceDetectedNotification", object: nil)
    private let visageFaceDetectedNotification = NSNotification(name: "visageFaceDetectedNotification", object: nil)
    private let visageTakenPictureNotification = NSNotification(name: "visageTakenPictureNotification", object: nil)
    
    //Private variables that cannot be accessed by other classes in any way.
    private var captureDevice : AVCaptureDevice!
    private var faceDetector : CIDetector?
    private var videoDataOutput : AVCaptureVideoDataOutput?
    private var videoDataOutputQueue : dispatch_queue_t?
    private var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    private var captureSession : AVCaptureSession = AVCaptureSession()
    private let notificationCenter : NSNotificationCenter = NSNotificationCenter.defaultCenter()
    private var currentOrientation : Int?
    private var closeEyeTimes = 0
    private let kExposureDurationPower = 5.0 // Higher numbers will give the slider more sensitivity at shorter durations
    private let kExposureMinimumDuration = 1.0/1000 // Limit exposure duration to a useful range
 
    
    private var stillImageOutput: AVCaptureStillImageOutput? = AVCaptureStillImageOutput()
    var beginToTakePicture = false
    var didTakePicture = false
    
    init(cameraPosition : CameraDevice, optimizeFor : DetectorAccuracy) {
        super.init()
        
        currentOrientation = convertOrientation(UIDevice.currentDevice().orientation)
        
        switch cameraPosition {
        case .FaceTimeCamera : self.captureSetup(AVCaptureDevicePosition.Front)
        case .ISightCamera : self.captureSetup(AVCaptureDevicePosition.Back)
        }
        
        var faceDetectorOptions : [String : NSString]?
        
        switch optimizeFor {
        case .BatterySaving : faceDetectorOptions = [CIDetectorAccuracy : CIDetectorAccuracyLow]
        case .HigherPerformance : faceDetectorOptions = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        }
        
        self.faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: faceDetectorOptions)
        //println(duSound)
        
        do {
            try self.nearAudioPlayer = AVAudioPlayer(contentsOfURL: self.nearSound)
            try self.duAudioPlayer = AVAudioPlayer(contentsOfURL: self.duSound)
            try self.farAudioPlayer = AVAudioPlayer(contentsOfURL: self.farSound)
        } catch {
            print(error)
        }
        
    }
    
    //MARK: SETUP OF VIDEOCAPTURE
    func beginFaceDetection() {
        self.captureSession.startRunning()
    }
    
    func endFaceDetection() {
        self.captureSession.stopRunning()
    }
    
    private func captureSetup (position : AVCaptureDevicePosition) {
        
        for testedDevice in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo){
            if (testedDevice.position == position) {
                captureDevice = testedDevice as! AVCaptureDevice
            }
        }
        if (captureDevice == nil) {
            captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        }

        let temperatureAndTint = AVCaptureWhiteBalanceTemperatureAndTintValues(
            temperature: 5700,
            tint: 0
        )
        let whiteBalanceGains = self.captureDevice!.deviceWhiteBalanceGainsForTemperatureAndTintValues(temperatureAndTint)
        
        if (captureDevice.hasFlash && captureDevice.hasTorch){
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.flashMode = AVCaptureFlashMode.On
                let normalizedGains = self.normalizedGains(whiteBalanceGains) // Conversion can yield out-of-bound values, cap to limits
                //self.captureDevice!.setWhiteBalanceModeLockedWithDeviceWhiteBalanceGains(normalizedGains, completionHandler: nil)
                
                captureDevice.unlockForConfiguration()
            } catch let error as NSError {
                NSLog("Could not lock device for configuration: %@", error)
            }
        }
        
        var deviceInput : AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.sessionPreset = AVCaptureSessionPresetPhoto
            
            if (captureSession.canAddInput(deviceInput)) {
                captureSession.addInput(deviceInput)
            }
            
            self.videoDataOutput = AVCaptureVideoDataOutput()
            self.videoDataOutput!.videoSettings = [kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA)]
            self.videoDataOutput!.alwaysDiscardsLateVideoFrames = true
            self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)
            self.videoDataOutput!.setSampleBufferDelegate(self, queue: self.videoDataOutputQueue!)
            
            if (captureSession.canAddOutput(self.videoDataOutput)) {
                captureSession.addOutput(self.videoDataOutput)
            }

            visageCameraView.frame = CGRectMake(0, 0, 250, 250)
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = CGRectMake(0, 0, 250, 250)
            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            visageCameraView.layer.addSublayer(previewLayer)
            
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
            
        } catch _ {
            deviceInput = AVCaptureDeviceInput()
        }
        
    }
    
    private func normalizedGains(gains: AVCaptureWhiteBalanceGains) -> AVCaptureWhiteBalanceGains {
        var g = gains
        
        g.redGain = max(1.0, g.redGain)
        g.greenGain = max(1.0, g.greenGain)
        g.blueGain = max(1.0, g.blueGain)
        
        g.redGain = min(self.captureDevice!.maxWhiteBalanceGain, g.redGain)
        g.greenGain = min(self.captureDevice!.maxWhiteBalanceGain, g.greenGain)
        g.blueGain = min(self.captureDevice!.maxWhiteBalanceGain, g.blueGain)
        
        return g
    }
    
    var options : [String : AnyObject]?
    
    //MARK: CAPTURE-OUTPUT/ANALYSIS OF FACIAL-FEATURES
    func captureOutput(_: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection _: AVCaptureConnection!) {
        
        do {
            try captureDevice.lockForConfiguration()
            //captureDevice.setExposureModeCustomWithDuration(newTime, ISO: AVCaptureISOCurrent, completionHandler: nil)
            
            captureDevice.unlockForConfiguration()
        } catch let error as NSError {
            NSLog("Could not lock device for configuration: %@", error)
        }
        
        if (!beginToTakePicture){
            let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            let sourceImage = CIImage(CVPixelBuffer: imageBuffer!)
            /* TODO::calulate the gray scale of preview image. if it's too dark, adjust to bright
            let context = CIContext(options: nil)
            
            let sourceGIImage = context.createCGImage(sourceImage, fromRect: sourceImage.extent)
          	let imageWidth = CGImageGetWidth(sourceGIImage)
            let imageHeight = CGImageGetHeight(sourceGIImage)
            // height 750, width 1000
			let cropCGIImage = CGImageCreateWithImageInRect(sourceGIImage, CGRect(x: imageWidth/2-50, y: imageHeight/2-50, width: 100, height: 100))
			let cropImage = UIImage(CGImage: cropCGIImage!)
            
            let color = cropImage.areaAverage()
            let components = CGColorGetComponents(color.CGColor)
            let grayScale = components[0]*0.33 + components[1]*0.33 + components[2]*0.33
            print("mean color \(grayScale)")
            */
            options = [CIDetectorSmile : false, CIDetectorEyeBlink: true, CIDetectorImageOrientation : 6]
            
            var features = self.faceDetector!.featuresInImage(sourceImage, options: options)
            
            do {
                try self.captureDevice.lockForConfiguration()
            } catch _ {
            }
            
            if (features.count != 0) {
                // Build a pixellated6     version of the image using the CIPixellate filter
                let feature = features[0] as! CIFaceFeature
                let faceOriginX = feature.bounds.origin.x
                let faceOriginY = feature.bounds.origin.y
                let faceWidth = feature.bounds.width
                let faceHeight = feature.bounds.height

                print("face origin x \(faceOriginX), face width \(faceWidth)")
                //for iphone6P, 600<facewidth<700. for iphone6, 500<facewidth<600
                if (faceWidth > 700 && faceWidth < 850 && UIScreen.mainScreen().bounds.size.width == 414) {
                    duAudioPlayer.prepareToPlay()
                    duAudioPlayer.play()
                    
                    self.blockss!()
                    
                    // MARK: - 闪光灯暂关
                    //                    do {
                    //                        try self.captureDevice.setTorchModeOnWithLevel(0.01)
                    //                    } catch _ {
                    //                    }
                    print("eye closed \(closeEyeTimes)")
                    
                    if (feature.leftEyeClosed || feature.rightEyeClosed ) {
                        closeEyeTimes += 1
                        
                        if (closeEyeTimes == 1 && !beginToTakePicture && !didTakePicture) {
                            print("eye closed \(closeEyeTimes)")
                            self.captureDevice.torchMode = AVCaptureTorchMode.Off
                            let focusPoint = CGPoint(x: (faceOriginX + faceWidth)/2, y: (faceOriginY + faceHeight)/2)
                            self.captureImage(focusPoint)
                            self.beginToTakePicture = true
                        }
                    } else {
                        closeEyeTimes = 0
                    }

 
                    print("too close!")
                    closeEyeTimes = 0
                    self.blockno!()
                    //captureDevice.torchMode = AVCaptureTorchMode.Off
                } else if (faceWidth > 450 && faceWidth < 550 ) {
                    duAudioPlayer.prepareToPlay()
                    duAudioPlayer.play()
 
                       self.blockss!()
 
                    // MARK: - 闪光灯暂关
//                    do {
//                        try self.captureDevice.setTorchModeOnWithLevel(0.01)
//                    } catch _ {
//                    }
                    print("eye closed \(closeEyeTimes)")
                    
                    if (feature.leftEyeClosed || feature.rightEyeClosed ) {
                        closeEyeTimes += 1
                        
                        if (closeEyeTimes == 2 && !beginToTakePicture && !didTakePicture) {
                            print("eye closed \(closeEyeTimes)")
                            self.captureDevice.torchMode = AVCaptureTorchMode.Off
                            let focusPoint = CGPoint(x: (faceOriginX + faceWidth)/2, y: (faceOriginY + faceHeight)/2)
                            self.captureImage(focusPoint)
                            self.beginToTakePicture = true
                        }
                    } else {
                        closeEyeTimes = 0
                    }
                    
                } else if (faceWidth < 400) {
                    //farAudioPlayer.prepareToPlay()
                    //farAudioPlayer.play()
                    print("too far!!!!!!")
                    self.blockno!()
                    closeEyeTimes = 0
                    //captureDevice.torchMode = AVCaptureTorchMode.Off
                    
                }
            }
            captureDevice.unlockForConfiguration()
        }
    }

//    func funcFlash() {
//        
//        UIView.animateWithDuration(2, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
//            self.visageCameraView.backgroundColor = UIColor.greenColor()
//            
//            }, completion: { (Bool) -> Void in
//                
//                UIView.animateWithDuration(2, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
//                    self.visageCameraView.backgroundColor = UIColor.blackColor()
//                    }, completion: { (Bool) -> Void in
//                        
//                })
//        })
//        
//
//    }
    func captureImage(focusPoint: CGPoint){
        duAudioPlayer.stop()
        print("try to capture image, focus on \(focusPoint)")
        
        let exposureValue = 0.520362
        let p = pow(Double(exposureValue), kExposureDurationPower) // Apply power function to expand slider's low-end range
        let minDurationSeconds = max(CMTimeGetSeconds(self.captureDevice!.activeFormat.minExposureDuration), kExposureMinimumDuration)
        let maxDurationSeconds = CMTimeGetSeconds(self.captureDevice!.activeFormat.maxExposureDuration)
        // newDurationSeconds is about 1/50 second
        let newDurationSeconds = p * ( maxDurationSeconds - minDurationSeconds ) + minDurationSeconds;
        //NSLog("actual exposure duration \(newDurationSeconds)")
        
        do {
            try self.captureDevice!.lockForConfiguration()
            //self.captureDevice!.setExposureModeCustomWithDuration(CMTimeMakeWithSeconds(newDurationSeconds, 1000*1000*1000), ISO: 100, completionHandler: nil)
            //self.captureDevice!.setExposureTargetBias(10.0, completionHandler: nil)
            /*
            make it focus on face didn't help. because once it is determined, the lens won't adjust focus length to face.
            In a test, it makes half of the pitures blur. The same as exposure.
            if captureDevice.focusPointOfInterestSupported {
                captureDevice.focusPointOfInterest = focusPoint
                captureDevice.focusMode = AVCaptureFocusMode.AutoFocus
            }
            if captureDevice.exposurePointOfInterestSupported {
                captureDevice.exposurePointOfInterest = focusPoint
                captureDevice.exposureMode = AVCaptureExposureMode.AutoExpose
            }
			*/
            
            self.captureDevice!.unlockForConfiguration()
        } catch let error as NSError {
            NSLog("Could not lock device for configuration: %@", error)
        }
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            
        stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    self.endFaceDetection()
                    
                    self.exif = CMGetAttachment(sampleBuffer, kCGImagePropertyExifDictionary, nil)
    
//                   CMSetAttachment(sampleBuffer, "kCGImagePropertyOrientation", 6, CMAttachmentMode(1))
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    self.saveToFileSystem(imageData)
//                    print(self.exif)
//                    print(CMGetAttachment(sampleBuffer, kCGImagePropertyExifDictionary, nil))
//                    let image = UIImage(data: imageData)
//                    
//                    print(image)
//                    let  metaDict = CMCopyDictionaryOfAttachments(nil, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
//                    
//                    let dict = ["kCGImagePropertyOrientation":"6"]
//                    
//                    CMSetAttachment(sampleBuffer, kCGImagePropertyOrientation, dict,kCMAttachmentMode_ShouldPropagate)
//                    let newMetaData = CMCopyDictionaryOfAttachments(nil, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
//                    
//                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
//                    let image = UIImage(data: imageData)
//                    let library = ALAssetsLibrary()
//                    let newDict = newMetaData
//                    
//                    let source = CGImageSourceCreateWithData(imageData, nil)
//                    let CFData = NSMutableData()
//                    let uti = CGImageSourceGetType(source!)
//                    let destination = CGImageDestinationCreateWithData(CFData, uti!, 0, nil)
//                    
////                 CGImageDestinationAddImageAndMetadata(destination!, (image?.CGImage)!, <#T##metadata: CGImageMetadata?##CGImageMetadata?#>, metaDict)
//                  let imageNew =  CGImageDestinationAddImage(destination!, (image?.CGImage)!, metaDict!)
//             
//                    print(imageNew)
                    
            
                     
                    self.didTakePicture = true
                    do {
                        try self.captureDevice.lockForConfiguration()
                    } catch _ {
                    }
                    self.captureDevice.torchMode = AVCaptureTorchMode.Off
                    self.captureDevice.unlockForConfiguration()
                    self.notificationCenter.postNotification(self.visageTakenPictureNotification)
                    
                }
            })
        }
    }
    
    
    func saveToFileSystem(imageData: NSData) {
        
        let dataProvider = CGDataProviderCreateWithCFData(imageData)
        let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
       
        
        let takenImage = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Up)
        let rotatedImage = takenImage.imageRotatedByDegrees(90, flip: false)
        let date = NSDate()
        

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        timeString = formatter.stringFromDate(date)
        print("now time is \(timeString!)")
        
        if let imageData = UIImageJPEGRepresentation(rotatedImage, 0.2){
           
            let fileManager = NSFileManager()
            if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                let url = docsDir.URLByAppendingPathComponent("IMG_\(idfv)_\(timeString!).jpg")
                if imageData.writeToURL(url, atomically: true) {
//                    print("image saved to \(url)")
                    self.url = url
                }
            }
        }
    }
    
    func saveToPhotoLibrary(imageData: NSData){
        
        
        PHPhotoLibrary.requestAuthorization {status in
            if status == PHAuthorizationStatus.Authorized {
                if #available(iOS 9.0, *) {
                    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                        PHAssetCreationRequest.creationRequestForAsset().addResourceWithType(PHAssetResourceType.Photo, data: imageData, options: nil)
                        }, completionHandler: {success, error in
                            if !success {
                                NSLog("Error occured while saving image to photo library: %@", error!)
                            }
                    })
                }
            }
        }

    }

    func saveImageWithExif(data:NSData,dic:NSDictionary) -> NSData{
        
        let dict = NSMutableDictionary.init(dictionary: dic)
        dict["\(CGImagePropertyOrientation.self)"] = 3
        let imageRef = CGImageSourceCreateWithData(data, nil)
        let uti = CGImageSourceGetType(imageRef!)
        let dateNew = NSMutableData()
        let destination = CGImageDestinationCreateWithData(dateNew, uti!, 1, nil)
//        if (destination == nil) {
//            print("error,no exif")
            return dateNew
//        }
//        CGImageDestinationAddImageFromSource(destination!, imageRef!, 0, dict)
//      
//        let check = CGImageDestinationFinalize(destination!)
//        if (check == false) {
//            print("error")
//            return dateNew
//        }
//        
//        return dateNew
        
    }
    
    //TODO: 🚧 HELPER TO CONVERT BETWEEN UIDEVICEORIENTATION AND CIDETECTORORIENTATION 🚧
    private func convertOrientation(deviceOrientation: UIDeviceOrientation) -> Int {
        var orientation: Int = 0
        switch deviceOrientation {
        case .Portrait:
            orientation = 6
        case .PortraitUpsideDown:
            orientation = 2
        case .LandscapeLeft:
            orientation = 3
        case .LandscapeRight:
            orientation = 4
        default : orientation = 1
        }
        return orientation
    }
}

private extension UIImage {
    func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
 
//        CGContextDrawImage(bitmap, CGRectMake(-size.width / 1.7, -size.height / 2, size.width * 1.25, size.height), CGImage)
          CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func areaAverage() -> UIColor {
        var bitmap = [UInt8](count: 4, repeatedValue: 0)
        
        if #available(iOS 9.0, *) {
            // Get average color.
            let context = CIContext()
            let inputImage = CIImage ?? CoreImage.CIImage(CGImage: CGImage!)
            let extent = inputImage.extent
            let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
            let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
            let outputImage = filter.outputImage!
            let outputExtent = outputImage.extent
            assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
            
            // Render to bitmap.
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        } else {
            // Create 1x1 context that interpolates pixels when drawing to it.
            let context = CGBitmapContextCreate(&bitmap, 1, 1, 8, 4, CGColorSpaceCreateDeviceRGB(), CGBitmapInfo.ByteOrderDefault.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue)!
            let inputImage = CGImage ?? CIContext().createCGImage(CIImage!, fromRect: CIImage!.extent)
            
            // Render to bitmap.
            CGContextDrawImage(context, CGRect(x: 0, y: 0, width: 1, height: 1), inputImage)
        }
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }

}
