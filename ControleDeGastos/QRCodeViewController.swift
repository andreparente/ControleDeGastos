//
//  QRCodeViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
import AVFoundation
class QRCodeViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    var link:String!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text="No QR code is detected"
        let captureDevice=AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var input : AnyObject!
        
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch _ {
            print("hata")
        }
        captureSession = AVCaptureSession()
        captureSession?.addInput(input as! AVCaptureInput)
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
        view.bringSubviewToFront(messageLabel)
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
                link = metadataObj.stringValue
               // reconheceUrl(link)
            }
        }
    }
    
  /*   func reconheceUrl(link:String)->()
    {
        let characters=Array(link.characters)
        print(characters)
        let j=0
        var n=0
        var x=0
        let i=characters.count
        var valor:[Character]!
        var valorfinal:String!
        for  j in 0...i
        {
            if(characters[j] == "v" && characters[j+1] == "N")
            {
                n=j+4
                while(characters[n] != "&")
                {
                    valor.append(characters[n])
                    n += 1;x += 1;
                }
                break
            }
        }
        if valor != nil
        {
            
            for char in valor
            {
                valorfinal=String(char)
            }
        }
        print(Double(valorfinal))
    }
 
    */
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

