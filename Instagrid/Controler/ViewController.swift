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
    @IBOutlet weak private var pickPhotoRightTopButton: UIButton!
    @IBOutlet weak private var pickPhotoRightBottomButton: UIButton!
    @IBOutlet weak private var pickPhotoLeftBottomButton: UIButton!
    @IBOutlet weak private var pickPhotoLeftTopButton: UIButton!
    @IBOutlet weak private var buttonLayout1: UIButton!
    @IBOutlet weak private var buttonLayout2: UIButton!
    @IBOutlet weak private var buttonLayout3: UIButton!
    @IBOutlet weak private var swipeToShareLabel: UILabel!
    @IBOutlet weak private var arrowUpView: UIImageView!
    @IBOutlet weak private var instagridLabel: UILabel!
    @IBOutlet weak private var arrowLeftView: UIImageView!
    @IBOutlet weak private var swipeLeftToShareLabel: UILabel!
    
    private var imageViewButton: UIButton!
    private var savedImageRightTop : UIImage?
    private var savedImageRightBottom : UIImage?
    private var newSwape : SwapButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUserInterface()
    }
    //MARK:- Button Layout
    @IBAction private func buttonLayout1(_ sender: UIButton) {
        tappedLayout(sender: sender, layout: .layout1)
    }
    
    @IBAction private func buttonLayout2(_ sender: UIButton) {
        tappedLayout(sender: sender, layout: .layout2)
    }
    @IBAction private func buttonLayout3(_ sender: UIButton) {
        tappedLayout(sender: sender, layout: .layout3)
    }
    //MARK:- Buttons Photo
    @IBAction func tappedAddPhoto(_ sender: UIButton) {
        addPhoto(button: sender)
    }
    //MARK:- Transform Image
    ///This function moves the field
    private func transformImageField(landScape : Bool){
        let transform = landScape ? CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0) : CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
        let labelToShake : UILabel = landScape ? swipeLeftToShareLabel : swipeToShareLabel
        UIView.animate(withDuration: 1.5, animations: {
            self.imageField.transform = transform
            self.swipeToShareLabel.shake()
            labelToShake.shake()
            self.shareImageField()
        })
    }
    //MARK:- Swipe To Share Image
    ///This function allows you to select the movement according to the orientation
    @objc private func swipe(sender : UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            if UIDevice.current.orientation.isLandscape {
                transformImageField(landScape: true)
            }
        default:
            let positionPortrait : Bool = UIScreen.main.bounds.height > UIScreen.main.bounds.width
            if positionPortrait {
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
            let alertUser = completed ? self.alertUser(title: "Sharing is a success", message: "Your action has been completed") : self.alertUser(title: "Sharing was not successful", message: "Your action failed or was canceled")
            self.present(alertUser, animated: true, completion: nil)
        }
        present(vc, animated: true, completion: nil)
    }
    private func alertUser(title : String ,message : String)-> UIAlertController  {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            UIView.animate(withDuration: 3) {
                self.imageField.transform = .identity
            }
        }))
        return alertVc
    }
    //MARK:- Function and user interface preparation
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
    //MARK:- Prepare user interface
    ///This function is used to display the start screen
    private func prepareUserInterface() {
        tappedLayout(sender: buttonLayout2, layout: .layout2)
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
    //MARK:- Reset all button
    ///This function returns the images of the buttons to their defaults.
    private func resetAllButton() {
        pickPhotoRightTopButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoRightBottomButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoLeftBottomButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoLeftTopButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
    }
    //MARK:- Add Photo
    /// This function allows you to recover the user's photo
    private func addPhoto(button : UIButton) {
        imageViewButton = button
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose a picture ", preferredStyle: .actionSheet)
        let cameraAlertAction = choiceSourceType(messageAlert: "Camera", sourceType: .camera)
        let photoLibraryAlertAction = choiceSourceType(messageAlert: "Photo Library", sourceType: .photoLibrary)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        photoSourceRequestController.addAction(cameraAlertAction)
        photoSourceRequestController.addAction(photoLibraryAlertAction)
        photoSourceRequestController.addAction(cancelAction)
        present(photoSourceRequestController, animated: true, completion: nil)
    }
    private func choiceSourceType(messageAlert : String, sourceType : UIImagePickerController.SourceType ) -> UIAlertAction{
        let alertAction = UIAlertAction(title: messageAlert , style: .default) {(action ) in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
        return alertAction
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePick = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage){
            imageViewButton.setImage(imagePick, for: .normal)
            imageViewButton.contentMode = .scaleAspectFill
            imageViewButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageViewButton.clipsToBounds = false
            dismiss(animated: true, completion: nil)
        }
    }
    private func resetButtonLayout() {
        buttonLayout1.isSelected = false
        buttonLayout2.isSelected = false
        buttonLayout3.isSelected = false
    }
    private func prepareSwap(sender : UIButton, layout : Layout) -> SwapButton {
        let newSwap = SwapButton(sender: sender, buttonLeftTop: pickPhotoLeftTopButton, buttonLeftBottom: pickPhotoLeftBottomButton, buttonRightTop: pickPhotoRightTopButton, buttonRightBottom: pickPhotoRightBottomButton, layout: layout)
        return newSwap
    }
    private func tappedLayout(sender : UIButton, layout : Layout) {
        guard !sender.isSelected else {
            present( alertUser(title: "Layout selected", message: "This layout already selected"), animated: true, completion: nil)
            return
        }
        resetButtonLayout()
        guard newSwape != nil else {
            newSwape = prepareSwap(sender: sender, layout: layout)
            return
        }
        newSwape?.tappedOnButtonLayout1and2(sender: sender, layout: layout)
    }
}
