//
//  AuthVC.swift
//  TouchToMap
//
//  Created by Gavin Li on 4/30/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthVC: UIViewController {
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var suggestionLbl: UILabel!
    @IBOutlet weak var authBtn: UIButton!
    
    private var localAuthenticationContext: LAContext?
    private var canEvaluatePolicyWithBiometrics: Bool = false
    private var canEvaluatePolicy: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUPLocalAuth()
        updateUIBasedOnBiometryType()
        authBtn.isEnabled = canEvaluatePolicy
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        canEvaluatePolicyWithBiometrics = false
        canEvaluatePolicy = false
        suggestionLbl.isHidden = true
        authBtn.isEnabled = false
    }
    
    @IBAction func didClickAuthBtn(_ sender: Any) {
        authenticate()
    }
}

extension AuthVC {
    
    private func setUPLocalAuth() {
        localAuthenticationContext = LAContext()
        localAuthenticationContext!.localizedFallbackTitle = "Use Passcode"
        
        if localAuthenticationContext!.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            canEvaluatePolicyWithBiometrics = true
            canEvaluatePolicy = true
        } else {
            canEvaluatePolicyWithBiometrics = false
            
            var authError: NSError?
            if localAuthenticationContext!.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                canEvaluatePolicy = true
            } else {
                if let error = authError {
                    statusLbl.text = evaluateAuthenticationPolicyMessageForLA(errorCode: error.code)
                }
                canEvaluatePolicy = false
            }
        }
    }
    
    private func updateUIBasedOnBiometryType() {
        if let laContext = localAuthenticationContext {
            if canEvaluatePolicy {
                if canEvaluatePolicyWithBiometrics {
                    switch laContext.biometryType {
                    case .none:
                        suggestionLbl.isHidden = true
                    case .touchID:
                        suggestionLbl.text = "Press Button to Authenticate Using TouchID"
                        suggestionLbl.isHidden = false
                    case .faceID:
                        suggestionLbl.text = "Press Button to Authenticate Using FaceID"
                        suggestionLbl.isHidden = false
                    @unknown default:
                        fatalError()
                    }
                } else {
                    switch laContext.biometryType {
                    case .none:
                        suggestionLbl.isHidden = true
                    case .touchID:
                        suggestionLbl.text = "You Can Enable TouchID for Better Experience"
                        suggestionLbl.isHidden = false
                    case .faceID:
                        suggestionLbl.text = "You Can Enable FaceID for Better Experience"
                        suggestionLbl.isHidden = false
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }
    
    // TODO: Should add alternative Auth methods if local auth fails
    private func authenticate() {
        let reasonString = "To access the secure map"
        localAuthenticationContext!.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
            
            DispatchQueue.main.async { [unowned self] in
                if success {
                    if let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as? MapVC {
                        mapVC.modalPresentationStyle = .fullScreen
                        self.present(mapVC, animated: true)
                    }
                } else {
                    guard let error = evaluateError else { return }
                    self.statusLbl.text = self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code)
                }
            }
            
            if let error = evaluateError {
                DispatchQueue.main.async { [unowned self] in
                    self.statusLbl.text = self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code)
                }
            }
        }
    }
    
    private func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    private func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        var message = ""
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
    
}
