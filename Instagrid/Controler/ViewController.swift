//
//  ViewController.swift
//  Instagrid
//
//  Created by DAGUIN Sébastien on 13/01/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlet
    @IBOutlet weak private var imageField: UIView!
    @IBOutlet weak private var pickPhotoRightTop: UIButton!
    @IBOutlet weak private var pickPhotoRightBottom: UIButton!
    @IBOutlet weak private var pickPhotoLeftBottom: UIButton!
    @IBOutlet weak private var pickPhotoLeftTop: UIButton!
    
    @IBOutlet weak private var buttonLayout1: UIButton!
    @IBOutlet weak private var buttonLayout2: UIButton!
    @IBOutlet weak private var buttonLayout3: UIButton!
    private var ImageView: UIButton!
    private var imageBackground: UIView!
    private var isShared = false
    @IBOutlet weak private var swipeToShareLabel: UILabel!
    @IBOutlet weak private var arrowUpLabel: UIImageView!
    @IBOutlet weak private var instagridLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareUserInterface()
    }
    
    //MARK:-Button Layout
    @IBAction private func buttonLayout1(_ sender: Any) {
        selectedButton(button: buttonLayout1)
        
        resetLayout()
        pickPhotoLeftTop.isHidden = true
    }
    
    @IBAction private func buttonLayout2(_ sender: Any) {
        selectedButton(button: buttonLayout2)
        
        resetLayout()
        pickPhotoLeftBottom.isHidden = true
    }
    @IBAction private func buttonLayout3(_ sender: Any) {
        
        selectedButton(button: buttonLayout3)
        resetLayout()
        
        
    }
    //MARK:- Button Photo
    @IBAction private func addPhotoRightTop(_ sender: Any) {
        addPhoto(button: pickPhotoRightTop)
    }
    @IBAction private func addPhotoLeftTop(_ sender: Any) {
        addPhoto(button: pickPhotoLeftTop)
    }
    @IBAction private func addPhotoLeftBottom(_ sender: Any) {
        addPhoto(button: pickPhotoLeftBottom)
    }
    @IBAction private func addPhotoRightBottom(_ sender: Any) {
        addPhoto(button: pickPhotoRightBottom)
    }
    
    private func resetButtonLayout() {
        buttonLayout1.setImage(nil, for: .normal)
        buttonLayout2.setImage(nil, for: .normal)
        buttonLayout3.setImage(nil, for: .normal)
    }
    //MARK:- Selected Button
    private func selectedButton(button : UIButton) {
        resetButtonLayout()
        let image = #imageLiteral(resourceName: "Selected")
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    //MARK:- Add Photo
   private func addPhoto(button : UIButton) {
        ImageView = button
        let photoSourceRequestController = UIAlertController(title: "", message: "Choisissez une photo ", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Appareil photo", style: .default) {(action ) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
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
        if let imagePick = (info[UIImagePickerController.InfoKey.editedImage] as? UIImage){
        ImageView.setImage(imagePick, for: .normal)
        ImageView.contentMode = .scaleAspectFill
        ImageView.clipsToBounds = false
        dismiss(animated: true, completion: nil)
        }
    }
    //MARK:- Transform Image
    private func transformImageField(portrait : Bool){
        
        let screenHeight = UIScreen.main.bounds.height
        switch portrait {
        case true:
            UIView.animate(withDuration: 3, animations: {
                self.swipeToShareLabel.shake()
                self.imageField.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            }, completion: { (nil) in
            })
            shareImageFiels()
        case false:
            UIView.animate(withDuration: 3, animations: {
                self.imageField.transform = CGAffineTransform(translationX: screenHeight, y: 0)
            }, completion: { (isShared ) in
           })

            shareImageFiels()
            
        }
    }
    //MARK:-Swipe To Share Image
    @objc  private func swipe(sender : UISwipeGestureRecognizer) {
        let orientation = UIDevice.current.orientation
        switch sender.direction {
        case .left:
            if orientation.isLandscape && orientation.isFlat {
                transformImageField(portrait: false)
            }
        case.up:
            if orientation.isPortrait{
                transformImageField(portrait: true)
            }
        default:
            
            break
        }
        
    }
    //MARK:- Share Image
    private func shareImageFiels() {
        let renderer = UIGraphicsImageRenderer(size: imageField.bounds.size)
        let image = renderer.image { ctx in
            imageField.drawHierarchy(in: imageField.bounds, afterScreenUpdates: false)
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil )
        present(vc, animated: true, completion: nil)
        imageField.transform = .identity
        
    }
    //MARK:- Reset Layout
    private func resetLayout() {
        pickPhotoRightTop.isHidden = false
        pickPhotoRightBottom.isHidden = false
        pickPhotoLeftBottom.isHidden = false
        pickPhotoLeftTop.isHidden = false
    }
    private func prepareLabel() {
        guard let customFontDelmMedium = UIFont(name: "Delm-Medium", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        guard let customThirstySoftRegularFpnt = UIFont(name: "ThirstySoftRegular", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        swipeToShareLabel.font = UIFontMetrics.default.scaledFont(for: customFontDelmMedium)
        swipeToShareLabel.adjustsFontForContentSizeCategory = true
        instagridLabel.font = UIFontMetrics.default.scaledFont(for: customThirstySoftRegularFpnt)
        instagridLabel.adjustsFontForContentSizeCategory = true
        instagridLabel.textColor = .white
    }
    private func prepareUserInterface() {
        resetLayout()
        pickPhotoLeftBottom.isHidden = true
        selectedButton(button: buttonLayout2)
        let swipeUp = UISwipeGestureRecognizer()
        swipeUp.direction = .up
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.direction = .left
        imageField.addGestureRecognizer(swipeUp)
        imageField.addGestureRecognizer(swipeLeft)
        swipeUp.addTarget(self, action: #selector(swipe))
        swipeLeft.addTarget(self, action: #selector(swipe))
        prepareLabel()
    }
   
}


