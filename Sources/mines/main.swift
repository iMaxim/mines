import Foundation
import Darwin

var appState: AppState = .running

var field = Field(rows: 10, columns: 10)
field.randomizeField()

while appState == .running {
    print(field.debugPresentation)
    let input = readLine()
    if input == "q" { 
        print("Thank you for playing!")
        appState = .stop 
    }
    if input == "w" { print("Moving position") }
    clear()
}


