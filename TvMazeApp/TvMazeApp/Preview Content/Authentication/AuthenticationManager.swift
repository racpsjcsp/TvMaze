//
//  AuthenticationManager.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 19/01/25.
//

import LocalAuthentication
import SwiftUI

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    private(set) var context = LAContext()
    @Published private(set) var biometryType: LABiometryType = .none
    private(set) var canEvaluatePolicy = false
    @Published private(set) var isAuthenticated = false
    @Published private(set) var errorDescription: String?
    @Published var showAlert = false

    init() {
        getBiometryType()
    }

    func getBiometryType() {
        /// canEvaluatePolicy will let us know if the user's device supports biometrics authentication
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)

        /// Getting the biometryType - in other words, if the device supports FaceID, TouchID, or doesn't support biometrics auth
        biometryType = context.biometryType
    }

    func authenticateWithFaceID() async {
        /// Resetting the LAContext so on the next login, biometrics are checked again
        context = LAContext()

        /// Only evaluatePolicy if device supports biometrics auth
        if canEvaluatePolicy {
            let reason = StringUtils.unlockTVMazeReason

            do {
                /// evaluatePolicy will check if user is the device's owner, returns a boolean value that'll let us know if it successfully identified the user
                let success = try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)

                /// Only if it's a success, set isAuthenticated to true
                if success {
                    Task {
                        await MainActor.run {
                            self.isAuthenticated = true
                        }
                    }
                }
            } catch {
                Task {
                    await MainActor.run {
                        self.showAlert = true
                        self.biometryType = .none
                        self.errorDescription = error.localizedDescription
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            print(StringUtils.errorBiometricNotAvailable)
            Task {
                await MainActor.run {
                    self.showAlert = true
                    self.errorDescription = StringUtils.errorBiometricNotAvailable
                }
            }
        }
    }

    func logout() {
        isAuthenticated = false
    }
}
