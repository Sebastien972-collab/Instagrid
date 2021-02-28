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
    @IBOutlet weak private var arrowLeft: UIImageView!
    @IBOutlet weak private var swipeLeftToShareLabel: UILabel!
    
    private var ImageView: UIButton!
    private var imageBackground: UIView!
    private var isShared = true
    private var savedImageRightTop : UIImage?
    private var savedImageRightBottom : UIImage?
    var clickUser = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareUserInterface()
    }
    //MARK:- Button Layout
    @IBAction private func buttonLayout1(_ sender: Any) {
        if !buttonLayout1.isSelected {
            selectedButton(button: buttonLayout1)
            savedImageRightTop = swapButton(button1: pickPhotoRightTop, button2: pickPhotoRightBottom)
            resetLayout()
            buttonDisappearanceAnimation(button: pickPhotoRightTop)
        }else{
            alertLayoutSelected()
        }
    }
    @IBAction private func buttonLayout2(_ sender: Any) {
        if !buttonLayout2.isSelected {
            selectedButton(button: buttonLayout2)
            savedImageRightBottom = swapButton(button1: pickPhotoRightBottom, button2: pickPhotoRightTop)
            resetLayout()
            buttonDisappearanceAnimation(button: pickPhotoRightBottom)
        }else{
            alertLayoutSelected()
        }
    }
    @IBAction private func buttonLayout3(_ sender: Any) {
        if !buttonLayout3.isSelected {
            selectedButton(button: buttonLayout3)
            resetLayout()
            if savedImageRightTop != nil {
                pickPhotoRightTop.setImage(savedImageRightTop, for: .normal)
            }
        }else{
            alertLayoutSelected()
        }
    }
    func alertLayoutSelected() {
        if clickUser >= 3 {
            let alertLayout = UIAlertController(title: nil, message: "This layout is already selected", preferredStyle: .alert)
            alertLayout.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alertLayout, animated: true) {
                self.clickUser = 0
            }
        }
        clickUser += 1
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
    //MARK:- Add Photo
    /// This function allows you to recover the user's photo
    private func addPhoto(button : UIButton) {
        ImageView = button
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose a picture ", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {(action ) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let photoLibraryAction = UIAlertAction(title: " Photo Library", style: .default) {(action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
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
    ///This function moves the field
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
        }
    }
    //MARK:- Swipe To Share Image
    ///This function allows you to select the movement according to the orientation
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
    ///This function transforms the field into an image and displays the share sheet
    private func shareImageField() {
        let renderer = UIGraphicsImageRenderer(size: imageField.bounds.size)
        let image = renderer.image { ctx in
            imageField.drawHierarchy(in: imageField.bounds, afterScreenUpdates: false)
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: nil )
        vc.popoverPresentationController?.sourceView = self.view
        vc.excludedActivityTypes = [.assignToContact]
        vc.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                let alertVc = UIAlertController(title: "Sharing is a success", message: "Your action has been completed", preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                    self.resetAllButton()
                    UIView.animate(withDuration: 3) {
                        self.imageField.transform = .identity
                    }
                }))
                self.present(alertVc, animated: true, completion: nil)
                return
            }else{
                let alertVc = UIAlertController(title: "Sharing was not successful", message: "Your action failed or was canceled", preferredStyle: .alert)
                alertVc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                    UIView.animate(withDuration: 3) {
                        self.imageField.transform = .identity
                    }
                }))
                self.present(alertVc, animated: true, completion: nil)
            }
        }
        present(vc, animated: true, completion: nil)
    }
    //MARK:- Reset Layout
    ///This function returns all buttons to their initial display.
    private func resetLayout() {
        UIView.animate(withDuration: 0.5) {
            self.pickPhotoRightTop.isHidden = false
            self.pickPhotoRightBottom.isHidden = false
            self.pickPhotoLeftBottom.isHidden = false
            self.pickPhotoLeftTop.isHidden = false
        }
    }
    //MARK:- Prepare label
    ///This function allows you to retrieve the fonts and assignments to labels
    private func prepareLabel() {
        guard let customFontDelmMedium = UIFont(name: "Delm-Medium", size: 22) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                """
            )
        }
        guard let customThirstySoftRegularFpnt = UIFont(name: "ThirstySoftRegular", size: 28) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                """
            )
        }
        instagridLabel.font = UIFontMetrics.default.scaledFont(for: customThirstySoftRegularFpnt)
        instagridLabel.font.withSize(100)
        swipeToShareLabel.font = UIFontMetrics.default.scaledFont(for: customFontDelmMedium)
        swipeToShareLabel.adjustsFontForContentSizeCategory = true
        instagridLabel.textColor = .white
        swipeToShareLabel.textColor = .white
        swipeLeftToShareLabel.textColor = .white
        swipeLeftToShareLabel.font = UIFontMetrics.default.scaledFont(for: customFontDelmMedium)
    }
    ///This function is used to display the start screen
    //MARK:- Prepare user interface
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
    private func swapButton(button1 : UIButton, button2 : UIButton) -> UIImage {
        button2.setImage(button1.currentImage, for: .normal)
        button1.setImage(#imageLiteral(resourceName: "Image"), for: .normal)
        return button2.currentImage!
    }
    private func resetButtonLayout() {
        buttonLayout1.isSelected = false
        buttonLayout2.isSelected = false
        buttonLayout3.isSelected = false
    }
    //MARK:- Selected Button
    private func selectedButton(button : UIButton) {
        resetButtonLayout()
        button.isSelected = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    //MARK:- Button disaspperance
    ///Displays the animation of the buttons that disappear
    private func buttonDisappearanceAnimation(button : UIButton) {
        UIView.animate(withDuration: 0.5) {
            button.isHidden = true
        }
    }
    //MARK:- Reset all button
    ///This function returns the images of the buttons to their defaults.
    private func resetAllButton() {
        pickPhotoRightTop.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoRightBottom.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoLeftBottom.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoLeftTop.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
    }
}
