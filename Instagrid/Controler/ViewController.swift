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
    @IBOutlet weak private var swipeToShareLabel: UILabel!
    @IBOutlet weak private var arrowUpLabel: UIImageView!
    @IBOutlet weak private var instagridLabel: UILabel!
    @IBOutlet weak var swipeLeftToShareLabel: UILabel!
    
    private var ImageView: UIButton!
    private var imageBackground: UIView!
    private var isShared = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareUserInterface()
    }
    
    //MARK:- Button Layout
    @IBAction private func buttonLayout1(_ sender: Any) {
        selectedButton(button: buttonLayout1)
        swapButton(button1: pickPhotoLeftTop, button2: pickPhotoLeftBottom)
        resetLayout()
        pickPhotoLeftTop.isHidden = true
    }
    
    @IBAction private func buttonLayout2(_ sender: Any) {
        selectedButton(button: buttonLayout2)
        swapButton(button1: pickPhotoLeftBottom, button2: pickPhotoLeftTop)
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
    
    private func swapButton(button1 : UIButton, button2 : UIButton) {
        
        button2.setImage(button1.currentImage, for: .normal)
        button1.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
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
    private func transformImageField(landScape : Bool){
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        switch landScape {
        case false:
            UIView.animate(withDuration: 1.5, animations: {
                self.imageField.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
                self.swipeToShareLabel.shake()
                self.shareImageField()
            })

        case true:
            UIView.animate(withDuration: 1.5, animations: {
                self.imageField.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
                self.swipeToShareLabel.shake()
                self.swipeLeftToShareLabel.shake()
                self.shareImageField()
            })
            
            //shareImageField()
            
        }
    }
    
    //MARK:- Swipe To Share Image
    @objc  private func swipe(sender : UISwipeGestureRecognizer) {
        let orientation = UIDevice.current.orientation
        switch sender.direction {
        case .left:
            print(" Ici la direction landscape est \(orientation.isLandscape)")
            if orientation.isLandscape {
                transformImageField(landScape: true)
            }
        default:
            let screenHeight = UIScreen.main.bounds.height
            let screenWidth = UIScreen.main.bounds.width
            
            if screenHeight > screenWidth {
                transformImageField(landScape: false)
            }
        }
        
    }
    //MARK:- Share Image
    private func shareImageField() {
        let renderer = UIGraphicsImageRenderer(size: imageField.bounds.size)
        let image = renderer.image { ctx in
            imageField.drawHierarchy(in: imageField.bounds, afterScreenUpdates: false)
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil )
        vc.popoverPresentationController?.sourceView = self.view
        vc.excludedActivityTypes = [.assignToContact]
        vc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                print("isshared Change ici 1")
                UIView.animate(withDuration: 3) {
                    self.imageField.transform = .identity
                }
                return
            }
            print("isshared Change ici 2")
            self.isShared = false
        }

        present(vc, animated: true, completion: nil)
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
        
        instagridLabel.font = UIFontMetrics.default.scaledFont(for: customFontDelmMedium)
        instagridLabel.adjustsFontForContentSizeCategory = true
        swipeToShareLabel.font = UIFontMetrics.default.scaledFont(for: customThirstySoftRegularFpnt)
        swipeToShareLabel.adjustsFontForContentSizeCategory = true
        instagridLabel.textColor = .white
        swipeToShareLabel.textColor = .white
        swipeLeftToShareLabel.textColor = .white
        swipeLeftToShareLabel.font = UIFontMetrics.default.scaledFont(for: customThirstySoftRegularFpnt)
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
