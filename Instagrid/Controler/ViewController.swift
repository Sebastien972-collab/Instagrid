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
    private enum Layout {
        case layout1
        case layout2
        case layout3
    }
    var images : [UIImage] = []
    private var layout : Layout = .layout2 {
        willSet{
            images = recupImage(layout: layout)
        }
        didSet{
            resetLayout()
            swapToLayout(layout: layout, images: images)
            images.removeAll()
        }
    }
    private var imageSave : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUserInterface()
    }
    //MARK:- Button Layout
    @IBAction private func buttonLayout(_ sender: UIButton) {
        if sender == buttonLayout1 {
            tappedLayout(sender: sender, newLayout: .layout1)
        }else if sender == buttonLayout2 {
            tappedLayout(sender: sender, newLayout: .layout2)
        }else if sender == buttonLayout3 {
            tappedLayout(sender: sender, newLayout: .layout3)
        }
    }
    //MARK:- Buttons Photo
    @IBAction func tappedAddPhoto(_ sender: UIButton) {
        addPhoto(button: sender)
    }
    //MARK:- Transform Image
    ///This function moves the image field
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
        /// This variable solves the problem that the system does not detect the orientation of the screen without movement beforehand
        let positionPortrait : Bool = UIScreen.main.bounds.height > UIScreen.main.bounds.width
        switch sender.direction {
        case .left:
            if UIDevice.current.orientation.isLandscape || !positionPortrait{
                transformImageField(landScape: true)
            }
        default:
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
            if completed {
                self.resetAllButton()
            }
        }
        present(vc, animated: true, completion: nil)
    }
    //MARK:- Functions and user interface preparation
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
    ///This function is used to display the start screen and add swipe recognition
    private func prepareUserInterface() {
        tappedLayout(sender: buttonLayout2, newLayout: .layout2)
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
    private func prepareButton(button : UIButton) {
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 0)
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
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
        return alertAction
    }
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePick = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage){
            imageViewButton.imageView?.contentMode = .scaleAspectFill
            imageViewButton.setImage(imagePick, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    ///This function triggers the change of layout
    private func tappedLayout(sender : UIButton, newLayout : Layout) {
        guard !sender.isSelected else {
            present(alertUser(title: "Layout selected", message: "This layout already selected"), animated: true, completion: nil)
            return
        }
        layout = newLayout
        resetButtonLayout()
        selectedButton(button: sender)
    }
    private func resetButtonLayout() {
        buttonLayout1.isSelected = false
        buttonLayout2.isSelected = false
        buttonLayout3.isSelected = false
    }
    //This function allows you to switch the button to selected mode
    private func selectedButton(button : UIButton) {
        button.isSelected = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //This function allows create alert message 
    private func alertUser(title : String ,message : String)-> UIAlertController  {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVc.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            UIView.animate(withDuration: 3) {
                self.imageField.transform = .identity
            }
        }))
        return alertVc
    }
    
    //Removes the button and displays an animation
    private func buttonDisappearanceAnimation(button : UIButton) {
        UIView.animate(withDuration: 0.5) {
            button.isHidden = true
        }
    }
    private func resetAllButton() {
        pickPhotoRightTopButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoRightBottomButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoLeftBottomButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        pickPhotoLeftTopButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
    }
    private func resetLayout() {
        UIView.animate(withDuration: 0.5) {
            self.pickPhotoRightTopButton.isHidden = false
            self.pickPhotoRightBottomButton.isHidden = false
        }
    }
    private func swapButton(buttonDisappear : UIButton, buttonAppears: UIButton) {
        buttonDisappear.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        buttonDisappearanceAnimation(button: buttonDisappear)
    }
    private func swapToLayout(layout : Layout, images : [UIImage]) {
        swapLayout(layout: layout)
        if layout == .layout3  || layout == .layout1{
            let layoutButtons = [pickPhotoLeftTopButton,pickPhotoLeftBottomButton,pickPhotoRightBottomButton]
            fillGrids(layoutButtons: layoutButtons)
        }else if layout == .layout2 {
            let layoutButtons = [pickPhotoLeftTopButton,pickPhotoRightTopButton,pickPhotoLeftBottomButton]
            fillGrids(layoutButtons: layoutButtons)
        }
    }
    private func fillGrids(layoutButtons : [UIButton?]) {
        var indexButton = 0
        for image in images {
            layoutButtons[indexButton]?.contentMode = .scaleAspectFill
            layoutButtons[indexButton]?.setImage(image, for: .normal)
            indexButton += 1
        }
    }
    private func swapLayout(layout : Layout) {
        if layout == .layout1  {
            swapButton(buttonDisappear: pickPhotoRightTopButton, buttonAppears: pickPhotoRightBottomButton)
        }else if layout == .layout2 {
            swapButton(buttonDisappear: pickPhotoRightBottomButton, buttonAppears: pickPhotoRightTopButton)
        }else if layout == .layout3 {
            if imageSave != nil {
                pickPhotoRightTopButton.setImage(imageSave, for: .normal)
            }else{
                pickPhotoRightTopButton.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
            }
        }
    }
    private func recupImage(layout : Layout) -> [UIImage] {
        var images : [UIImage] = []
        if layout == .layout2 {
            images.append(pickPhotoLeftTopButton.currentImage!)
            images.append(pickPhotoLeftBottomButton.currentImage!)
            images.append(pickPhotoRightTopButton.currentImage!)
            return images
        }
        else if layout == .layout1 || layout == .layout3  {
            images.append(pickPhotoLeftTopButton.currentImage!)
            images.append(pickPhotoLeftBottomButton.currentImage!)
            images.append(pickPhotoRightBottomButton.currentImage!)
            if layout == .layout3 {
                imageSave = pickPhotoRightTopButton.currentImage
            }
            return images
        }
        return images
    }
}
