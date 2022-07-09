import Foundation
import Darwin

var appState: AppState = .running

var field = Field(rows: 10, columns: 10)
field.randomizeField()
print(field.fieldPresentation)

var oldt = termios()
tcgetattr(STDIN_FILENO, &oldt)

var newt = oldt
newt.c_lflag &= ~tcflag_t(ICANON)
newt.c_lflag &= ~tcflag_t(ECHO)
specialCharacters.VMIN = 1
specialCharacters.VTIME = 0
newt.c_cc = specialCharacters

tcsetattr(STDIN_FILENO, TCSAFLUSH, &newt)
var char: UInt8 = 0
print("\u{1B}[?25l")

while appState == .running {
    read(STDIN_FILENO, &char, 1)
    guard let input = InputKey(rawValue: char) else { continue }

    switch input {
    case .up: field.moveCursor(.up)
    case .down: field.moveCursor(.down)
    case .left: field.moveCursor(.left)
    case .right: field.moveCursor(.right)
    case .reveal: field.openCell()
    case .quit: appState = .stop 
    }

    print("\u{1B}[\(field.rows + 3)A")
    print(field.fieldPresentation)
}

print("\u{1B}[?25h")
tcsetattr(STDIN_FILENO, TCSANOW, &oldt)


