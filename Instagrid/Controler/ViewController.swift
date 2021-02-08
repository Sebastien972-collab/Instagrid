//
//  ViewController.swift
//  Instagrid
//
//  Created by DAGUIN Sébastien on 13/01/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageField: UIView! 

    @IBOutlet weak var pickPhotoLayout1: UIButton!
    @IBOutlet weak var pickPhotoRightTop: UIButton!
    @IBOutlet weak var pickPhotoRigtBottom: UIButton!
    @IBOutlet weak var pickPhotoLefttTop: UIButton!
    @IBOutlet weak var pickPhotoLefttBottom: UIButton!
    @IBOutlet weak var pickPhotoLayout2: UIButton!
   
    
    @IBOutlet weak var imageViewLayout1: UIImageView!
    @IBOutlet weak var imageViewLayoutRightBottom: UIImageView!
    @IBOutlet weak var imageViewLayoutLeftBottom: UIImageView!
    @IBOutlet weak var imageViewRightTop: UIImageView!
    @IBOutlet weak var imageViewLeftTop: UIImageView!
    @IBOutlet weak var imageViewLayout2: UIImageView!
    var ImageView: UIImageView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetLayout()
        imageViewRightTop.isHidden = false
        imageViewLeftTop.isHidden = false
        imageViewLayout2.isHidden = false
        pickPhotoRightTop.isHidden = false
        pickPhotoLefttTop.isHidden = false
        pickPhotoLayout2.isHidden = false
        let panGestureRecogmizer = UIPanGestureRecognizer(target: self, action: #selector(swipeUpForPartage(_:)))
        imageField.addGestureRecognizer(panGestureRecogmizer)
        
        
    }

    @IBAction func pickPhotoImageViewLayout1(_ sender: Any) {
        addPhoto(Button: pickPhotoLayout1,ImageViewLayout: imageViewLayout1)
        
    }
    @IBAction func pickPhotoImageViewLayout1RightBottom(_ sender: Any) {
        addPhoto(Button: pickPhotoRigtBottom,ImageViewLayout: imageViewLayoutRightBottom)
    }
    
    @IBAction func pickPhotoImageViewLayout1LeftBottom(_ sender: Any) {
        addPhoto(Button: pickPhotoLefttBottom ,ImageViewLayout: imageViewLayoutLeftBottom)
    }
    
    
    @IBAction func buttonLayout1(_ sender: Any) {
        resetLayout()
        imageViewLayout1.isHidden = false
        imageViewLayoutRightBottom.isHidden = false
        imageViewLayoutLeftBottom.isHidden = false
        pickPhotoLayout1.isHidden = false
        pickPhotoRigtBottom.isHidden = false
        pickPhotoLefttBottom.isHidden = false
    }
    
    @IBAction func buttonLayout2(_ sender: Any) {
       resetLayout()
        imageViewRightTop.isHidden = false
        imageViewLeftTop.isHidden = false
        imageViewLayout2.isHidden = false
        imageViewRightTop.isHidden = false
        pickPhotoLayout2.isHidden = false
        pickPhotoRightTop.isHidden = false
        pickPhotoLefttTop.isHidden = false
       
      
        
    }
    @IBAction func buttonLayout3(_ sender: Any) {
        resetLayout()
        
        imageViewLayoutRightBottom.isHidden = false
        imageViewLayoutLeftBottom.isHidden = false
        imageViewRightTop.isHidden = false
        imageViewLeftTop.isHidden = false
        pickPhotoRightTop.isHidden = false
        pickPhotoRigtBottom.isHidden = false
        pickPhotoLefttTop.isHidden = false
        pickPhotoLefttBottom.isHidden = false
      
       
    }
    
    @IBAction func pickPhotoRightTop(_ sender: Any) {
        addPhoto(Button: pickPhotoRightTop, ImageViewLayout: imageViewRightTop)
       
    }
    
    @IBAction func pickPhotoLeftTop(_ sender: Any) {
        addPhoto(Button: pickPhotoLefttTop, ImageViewLayout: imageViewLeftTop)
    }
    
    @IBAction func pickPhotoLayout2(_ sender: Any) {
        addPhoto(Button: pickPhotoLayout2, ImageViewLayout: imageViewLayout2)
    }
    
    func resetLayout() {
        imageViewLayout1.isHidden = true
        imageViewLayoutRightBottom.isHidden = true
        imageViewLayoutLeftBottom.isHidden = true
        imageViewRightTop.isHidden = true
        imageViewLeftTop.isHidden = true
        imageViewLayout2.isHidden = true
        pickPhotoLayout1.isHidden = true
        pickPhotoRightTop.isHidden = true
        pickPhotoRigtBottom.isHidden = true
        pickPhotoLefttTop.isHidden = true
        pickPhotoLefttBottom.isHidden = true
        pickPhotoLayout2.isHidden = true
      
     
        
    }
    
    func addPhoto(Button : UIButton, ImageViewLayout : UIImageView) {
        ImageView = ImageViewLayout
        let photoSourceRequestController = UIAlertController(title: "", message: "Choisissez une photo ", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Appareil photo", style: .default) {(action ) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
                
                
                    Button.isHidden = true
                
            }
        }
        let photoLibraryAction = UIAlertAction(title: "Galerie Photo", style: .default) {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel)
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        photoSourceRequestController.addAction(cancelAction)
        present(photoSourceRequestController, animated: true, completion: nil)
      
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        ImageView.image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        ImageView.contentMode = .scaleAspectFill
        ImageView.clipsToBounds = true
            dismiss(animated: true, completion: nil)
            }
    @objc func swipeUpForPartage(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformImageField(sender)
        case .ended, .cancelled:
            shareImageFiels()
        default:
            break
            
        }
      
        
        
    }
    private func transformImageField(_ gesture : UIPanGestureRecognizer){
        let translation = gesture.translation(in: imageField)
        imageField.transform = CGAffineTransform.init(translationX: 0, y: translation.y)
        
    }
    func shareImageFiels() {
        let renderer = UIGraphicsImageRenderer(size: imageField.bounds.size)
        let image = renderer.image { ctx in
            imageField.drawHierarchy(in: imageField.bounds, afterScreenUpdates: false)
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil )
        imageField.isHidden = true
        present(vc, animated: true, completion: nil)
        imageField.isHidden = false
        imageField.transform = .identity
        
    }
}
    

