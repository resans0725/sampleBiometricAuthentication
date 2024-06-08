//
//  BiometricAuthManager.swift
//  Sample BiometricAuthentication
//
//  Created by 永井涼 on 2024/06/08.
//

import Foundation
import LocalAuthentication

class BiometricAuthManager {
    var context: LAContext = LAContext()
    let reason = "パスワードを入力してください"
    
    func auth() async throws -> (String, Bool) {
        return try await withCheckedThrowingContinuation { continuation in
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                // 生体認証処理の実行
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            continuation.resume(returning: ("生体認証が成功しました", true))
                        }
                    } else if let laError = error as? LAError {
                        switch laError.code {
                        case .authenticationFailed:
                            continuation.resume(returning:("生体認証に失敗しました", false))
                            break
                        case .userCancel:
                            continuation.resume(returning:("生体認証がキャンセルされました", false))
                            break
                        case .userFallback:
                            continuation.resume(returning:("生体認証に失敗しました", false))
                            break
                        case .systemCancel:
                            continuation.resume(returning:("生体認証がキャンセルされました", false))
                            break
                        case .passcodeNotSet:
                            continuation.resume(returning:("パスコードが入力されませんでした", false))
                            break
                        case .touchIDNotAvailable:
                            continuation.resume(returning:("指紋認証の失敗上限に達しました", false))
                            break
                        case .touchIDNotEnrolled:
                            continuation.resume(returning:("指紋認証が許可されていません", false))
                            break
                        case .touchIDLockout:
                            continuation.resume(returning:("指紋が登録されていません", false))
                            break
                        case .appCancel:
                            continuation.resume(returning:("アプリ側でキャンセルされました", false))
                            break
                        case .invalidContext:
                            continuation.resume(returning:("不明なエラー", false))
                            break
                        case .notInteractive:
                            continuation.resume(returning:("エラーが発生しました", false))
                            break
                        @unknown default:
                            break
                        }
                    }
                }
            } else {
                print("顔認証ができなかった場合")
            }
        }
    }
}
