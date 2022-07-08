enum AppState {
    case running
    case stop
}

func clear() {
    for _ in 0...9 {
        print("\r", terminator: "")
    }
}