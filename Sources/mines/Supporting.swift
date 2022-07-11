import Foundation
import Darwin

enum AppState {
    case running
    case stop
}

enum InputKey: UInt8 {
    case up = 119
    case down = 115
    case left = 97
    case right = 100
    case reveal = 32
    case quit = 113
}

func terminalPrint(_ input: String) {
    print(input, terminator: "\r")
} 