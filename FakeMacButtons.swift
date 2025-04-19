//
//  MacOSButtonsView.swift
//  Alto
//
//  Created by Henson Liga on 4/12/25.
//

import SwiftUI

@Observable
class MacButtonsViewModel {
    let windowPaddingOffset: CGFloat = 2
    let width: CGFloat = 51
    let spacing = 7.5
    var buttonColors: [Color]
    var isHovered = false
    var buttonState: ButtonState = .idle
    let showIcons = true
    enum ButtonType {
        case close, minimize, fullscreen
    }
    
    enum ButtonState {
        case idle, active, hover
    }
    
    func getButtonColor(buttonType: ButtonType) -> (Color, Color) {
        if buttonState != .idle {
            return (macFillColor(buttonType:buttonType), macStrokeColor(buttonType:buttonType))
        }
        return (Color.white.opacity(0.15), Color.clear)
    }
    
    func macFillColor(buttonType: ButtonType) -> Color {
        switch buttonType {
            case .close: return Color(red: 236/255, green: 106/255, blue: 94/255)
            case .minimize: return  Color(red: 254/255, green: 188/255, blue: 46/255)
            case .fullscreen: return  Color(red: 40/255, green: 200/255, blue: 65/255)
        }
    }
    
    func macStrokeColor(buttonType: ButtonType) -> Color {
        switch buttonType {
            case .close: return Color(red: 208/255, green: 78/255, blue: 69/255)
            case .minimize: return  Color(red: 224/255, green: 156/255, blue: 21/255)
            case .fullscreen: return  Color(red: 21/255, green: 169/255, blue: 31/255)
        }
    }
    func getButtonAction(buttonType: ButtonType) -> () -> Void {
        switch buttonType {
            case .close: return {NSApp.keyWindow?.close()}
            case .minimize: return  {NSApp.keyWindow?.miniaturize(nil)}
            case .fullscreen: return  {NSApp.keyWindow?.toggleFullScreen(nil)}
        }
    }
    
    func getButtonImage(buttonType: ButtonType) -> String {
        switch buttonType {
        case .close: return "minus"
        case .minimize: return "xmark"
        case .fullscreen: return "square.split.diagonal.fill"
        }
    }
    
    func hoverChange(hoverState: Bool) {
        if hoverState {
            if showIcons {
                buttonState = .hover
            } else {
                buttonState = .active
            }
        } else {
            buttonState = .idle
        }
    }
    init() {
        buttonColors = []
    }
}

struct MacButtonsView: View {
    let viewModel = MacButtonsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack(alignment: .center, spacing: viewModel.spacing) {
                    MacButtonView(
                        viewModel: viewModel,
                        buttonType: .close
                    )
                    MacButtonView(
                        viewModel: viewModel,
                        buttonType: .minimize
                    )
                    MacButtonView(
                        viewModel: viewModel,
                        buttonType: .fullscreen
                    )
                }
                .onHover { Hovered in
                    viewModel.hoverChange(hoverState: Hovered)
                }
            }
            .frame(height: geometry.size.height)
            .padding(.leading, (geometry.size.height / 3) - viewModel.windowPaddingOffset)
        }
    }
}

struct MacButtonView: View {
    var viewModel: MacButtonsViewModel
    var buttonType: MacButtonsViewModel.ButtonType
    
    var body: some View {
        Button(action:viewModel.getButtonAction(buttonType: buttonType)) {
            if viewModel.buttonState == .idle {
                Circle()
                    .fill(viewModel.getButtonColor(buttonType: buttonType).0)
                    .frame(width: 12.5,height: 12.5)
            }
            else {
                ZStack {
                Circle()
                        .fill(viewModel.getButtonColor(buttonType: buttonType).1)
                    
                    .overlay(
                        Circle()
                            .inset(by: 0.5)
                            .fill(viewModel.getButtonColor(buttonType: buttonType).0)
                    )
                if viewModel.buttonState == .hover {
                    
                }
            }.frame(width: 12.5,height: 12.5)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
