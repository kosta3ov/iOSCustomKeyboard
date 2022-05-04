//
//  KeyboardViewController.swift
//  KeyboardExtension
//
//  Created by Konstantin Trekhperstov on 05.04.22.
//

import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    private let keyboardsUserDefault = UserDefaults.standard
    private var keyboardEnvironment: KeyboardEnvironment?
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        keyboardEnvironment = KeyboardEnvironment(languages: [.englisch, .russian, .german],
                                                  textDocumentProxy: textDocumentProxy,
                                                  shouldChangeKeyboards: self.needsInputModeSwitchKey, shouldPlayClickSound: false)

        let keyboardManager = KeyboardManager()
        let keyboardViewModel = KeyboardViewModel(keyboardEnvironment: keyboardEnvironment!, buttonsProvider: keyboardManager)
        let keyboardView = KeyboardView(viewModel: keyboardViewModel, keyboardCalculator: KeyboardCalculator(viewModel: keyboardViewModel, keyboardEnvironment: keyboardEnvironment!))
            .environmentObject(keyboardEnvironment!)
        let hostingController = UIHostingController(rootView: keyboardView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        hostingController.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
//        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

}
