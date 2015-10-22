//
//  ViewController.swift
//  PhotoCompare
//
//  Created by Oleh Makodym on 21/10/15.
//  Copyright © 2015 Cell Phone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var gpuImageView: GPUImageView!
    @IBOutlet var overlayImageView: UIImageView!
    @IBOutlet var animationImageView: UIImageView!
    @IBOutlet var capturedPictureImageView: UIImageView!
    @IBOutlet var subtrackedImageView: UIImageView!
    @IBOutlet var rightThumbnailView: UIImageView!
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var acceptanceSlider: UISlider!
    
    @IBOutlet var infoLabel1: UILabel!
    @IBOutlet var infoLabel2: UILabel!
    @IBOutlet var infoLabel3: UILabel!
    @IBOutlet var infoLabel4: UILabel!
    
    var acceptanceDifference : Double = 6 //In percent
    let maxAnimationFrames = 30
    var animationVisible = false
    var takenPicture : UIImage?
    
    var images : [UIImage] = []
    var camera : GPUImageStillCamera
    var filter : GPUImageCropFilter
    
    lazy var timer : NSTimer = {return NSTimer(timeInterval: 0.1, target: self, selector: Selector.init("timerCallback"), userInfo: nil, repeats: true)}()
    
    required init?(coder: NSCoder) {
        self.camera = GPUImageStillCamera()
        
        filter = GPUImageCropFilter()
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.camera.outputImageOrientation = UIInterfaceOrientation.Portrait
        setupFilters()
        runTimer()
    }
    
    func setupFilters() {
        let width :CGFloat = 1.0
        
        //Default aspect ration for iPhones camera is 4:3 (8:6), so for aspect ratio 1:1 calculated below:
        let height : CGFloat = (1 / 0.8) * 0.6
        let rect = CGRectMake(0, 0, width, height)
        filter.cropRegion = rect;
        
        filter.addTarget(gpuImageView)
        camera.addTarget(filter)
        camera.startCameraCapture()
    }
    
    func runTimer(){
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func timerCallback() {
        filter.useNextFrameForImageCapture()
        let image = filter.imageFromCurrentFramebuffer()
        
        
        if images.count == maxAnimationFrames && !animationVisible {
            startAnimation()
        } else if let compareImage = compareImages(takenPicture, simage: image) {
            
            subtrackedImageView.image = compareImage.diffImage;
            
            infoLabel1.text = String(format: "%.2f %%", compareImage.percentage)
            infoLabel2.text = String(format: "Calc time: %.2f s", compareImage.time)
            infoLabel3.text = String(format: "Acceptance min: %.2f %%", acceptanceDifference)
            infoLabel4.text = "Images in array: \(images.count)"
            
            if !animationVisible && compareImage.percentage < acceptanceDifference {
                images.append(image)
                takenPicture = image;
            }
        }
        
        //        UIImage *testImage = [dummyFilter imageFromCurrentFramebuffer]; // always nil
        //        [stillCamera capturePhotoAsImageProcessedUpToFilter:dummyFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        //         }];
    }
    
    func startAnimation() {
        animationVisible = true
        animationImageView.animationImages = images
        animationImageView.animationDuration = Double(images.count) / 24.0
        animationImageView.startAnimating()
    }
    
    @IBAction func takePictureButtonPressed(sender: UIButton) {
        animationVisible = false
        images.removeAll()
        
        camera.capturePhotoAsJPEGProcessedUpToFilter(filter) { (processedJPEG, error) -> Void in
            let image = UIImage.init(data: processedJPEG)
            self.takenPicture = image
            self.overlayImageView.alpha = CGFloat(self.slider.value);
            self.overlayImageView.image = image;
            self.capturedPictureImageView.image = image;
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        self.overlayImageView.alpha = CGFloat(sender.value)
    }
    
    @IBAction func acceptanceSliderChanged(sender: UISlider) {
        acceptanceDifference = Double(sender.value);
    }
    
}
