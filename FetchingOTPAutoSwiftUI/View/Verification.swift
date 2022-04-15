//
//  Verification.swift
//  FetchingOTPAutoSwiftUI
//
//  Created by MANAS VIJAYWARGIYA on 15/04/22.
//

import SwiftUI
import AwesomeToast

struct Verification: View {
    @EnvironmentObject var otpViewModel: OTPViewModel
    @FocusState var activeField: OTPField?
    
    var body: some View {
        VStack {
            OTPField()
            
            Button {
                Task { await otpViewModel.verifyOTP()}
            } label: {
                Text("Verify")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.blue)
                            .opacity(otpViewModel.isLoading ? 0.4 : 1)
                    )
                    .overlay(
                        ProgressView()
                            .opacity(otpViewModel.isLoading ? 1 : 0)
                    )
            }
            .padding(.vertical)
            .disabled(checkStates())
            .opacity(checkStates() ? 0.4 : 1)
            
            HStack(spacing: 12) {
                Text("Didn't get OTP?")
                    .font(.caption)
                    .foregroundColor(.gray)
                Button("Resend") {}
                .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationTitle("Verification")
        .onChange(of: otpViewModel.otpFields) { newValue in
            OTPCondition(value: newValue)
        }
        .showToast(title: "Error:", otpViewModel.errorMsg, isPresented: $otpViewModel.showAlert, color: Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), duration: 4, alignment: .top, toastType: .offsetToast)
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension Verification {
    //
    func checkStates() -> Bool {
        for index in 0..<6 {
            if otpViewModel.otpFields[index].isEmpty { return true }
        }
        return false
    }
    
    
    // MARK: - Condition for Custom OTP Field & Limiting only one Text
    func OTPCondition(value: [String]) {
        // Checking if OTP is pressed
        for index in 0..<6 {
            if value[index].count == 6 {
                DispatchQueue.main.async {
                    otpViewModel.otpText = value[index]
                    otpViewModel.otpFields[index] = ""
                    
                    // Updating all fields with value
                    for item in otpViewModel.otpText.enumerated() {
                        otpViewModel.otpFields[item.offset] = String(item.element)
                    }
                }
                
                return
            }
        }
        
        // Moving to the next field if current field typed
        for index in 0..<5 {
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        // Moving back if current is empty and previous is not empty
        for index in 1...5 {
            if value[index].isEmpty && !value[index - 1].isEmpty {
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        for index in  0..<5 {
            if value[index].count > 1 {
                otpViewModel.otpFields[index] = String(value[index].last!)
            }
        }
    }
    
    // MARK: - Custom OTP TextField
    @ViewBuilder
    func OTPField() -> some View {
        HStack(spacing: 14) {
            ForEach(0..<6, id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $otpViewModel.otpFields[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ? .blue : .gray.opacity(0.3))
                        .frame(height: 4)
                }
                .frame(width: 40)
            }
        }
    }
    
    func activeStateForIndex(index: Int) -> OTPField {
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
        }
    }
}

// MARK: - Focus active State enum
enum OTPField {
    case field1, field2, field3, field4, field5, field6
}
