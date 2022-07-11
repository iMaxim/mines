import Foundation
import Darwin

var appState: AppState = .running

var field = Field(rows: 10, columns: 10)
field.randomizeField()
terminalPrint(field.fieldPresentation)

var oldt = termios()
tcgetattr(STDIN_FILENO, &oldt)
var newt = oldt
newt.c_lflag &= ~tcflag_t(ICANON)
newt.c_lflag &= ~tcflag_t(ECHO)

tcsetattr(STDIN_FILENO, TCSAFLUSH, &newt)
var char: UInt8 = 0
terminalPrint("\u{1B}[?25l")

while appState == .running {
    read(STDIN_FILENO, &char, 1)
    guard let input = InputKey(rawValue: char) else { continue }

    switch input {
    case .up: field.moveCursor(.up)
    case .down: field.moveCursor(.down)
    case .left: field.moveCursor(.left)
    case .right: field.moveCursor(.right)
    case .reveal: 
        if field.openCell() == .mine {
            // openAllField()
            terminalPrint("BOOM!!! Press \"r\" to restart game. Press \"q\" to quit.")
        }
    case .quit: appState = .stop 
    }

    terminalPrint("\u{1B}[\(field.rows)A")
    terminalPrint(field.fieldPresentation)
}

terminalPrint("\u{1B}[?25h")
tcsetattr(STDIN_FILENO, TCSANOW, &oldt)


