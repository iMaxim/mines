struct Field {
    private var field: [Cell] = []
    private var open: [CellStatus] = []
    var rows: Int
    var cols: Int
    var cursorRow: Int
    var cursorColumn: Int

    enum Cell: String {
        case empty = "."
        case mine = "*"
    }

    enum CellStatus {
        case visible
        case closed
    }

    enum Move {
        case up
        case down
        case left
        case right
    }

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.cols = columns
        self.cursorRow = 0
        self.cursorColumn = 0
        for _ in 0..<(rows * cols) {
            field.append(.empty)
        }
    }

    func getCellFor(row: Int, column: Int) -> Cell {
        field[row * cols + column]
    }

    func isFieldOpen(row: Int, column: Int) -> CellStatus {
        open[row * cols + column]
    }

    func safeGetCellFor(row: Int, column: Int, cell: inout Cell) -> Bool {
        if 0 <= row && row < self.rows && 0 <= column && column < self.cols { 
            cell = getCellFor(row: row, column: column) 
            return true
        }
        return false
    }

    mutating func setCellFor(cell: Cell, row: Int, column: Int) {
        field[row * cols + column] = cell
    }

    mutating func resizeField(row: Int, column: Int) {
        self.rows = row
        self.cols = column
        self.cursorRow = 0
        self.cursorColumn = 0
        field.removeAll()
    }

    mutating func randomizeField() {
        let fieldSize = self.rows * self.cols
        let _ = (0..<fieldSize).map { _ in 
            field.append(.empty)
            open.append(.closed) 
        }
        var placedMines = 0
        let numberOfMines = fieldSize * 20 / 100
        
        while placedMines < numberOfMines {
            let randomizedCell = Int.random(in: 0..<fieldSize)
            if field[randomizedCell] == .empty {
                field[randomizedCell] = .mine
                placedMines += 1
            }
        }
    }

    func atCursor(row: Int, column: Int) -> Bool {
        row == cursorRow && column == cursorColumn
    }

    mutating func openCell() -> Cell {
        let index = cursorRow * cols + cursorColumn
        open[index] = .visible
        return field[index]
    }

    mutating func openAllField() {
        // open.map { $0 = .visible }
    }

    mutating func moveCursor(_ direction: Move) {
        switch direction {
        case .up    : if cursorRow > 0            { cursorRow -= 1 }
        case .down  : if cursorRow < rows - 1     { cursorRow += 1 }
        case .left  : if cursorColumn > 0         { cursorColumn -= 1 }
        case .right : if cursorColumn < cols - 1  { cursorColumn += 1 }
        }
    }

    func countCellNeighbours(row: Int, column: Int) -> Int {
        var cell: Cell = .empty
        var neighboursCounter = 0
        for DRow in -1...1 {
            for DCol in -1...1 {
                if DRow != 0 || DCol != 0 {  }
                if safeGetCellFor(row: row + DRow, column: column + DCol, cell: &cell) {
                    if cell == .mine { neighboursCounter += 1 }
                }
            }
        }
        return neighboursCounter
    }
}

extension Field {
    var fieldPresentation: String {
        var fieldString = ""
        for row in 0..<rows {
            for col in 0..<cols {
                fieldString += atCursor(row: row, column: col) ? "[" : " "
                if isFieldOpen(row: row, column: col) == .visible {
                    switch getCellFor(row: row, column: col) {
                    case .mine:
                        fieldString += "*"
                    case .empty:
                        let neighbours = countCellNeighbours(row: row, column: col)
                        if neighbours > 0 { fieldString += "\(neighbours)" } else { fieldString += " " }
                    }
                } else {
                    fieldString += "#"
                }
                fieldString += atCursor(row: row, column: col) ? "]" : " "
            }
            fieldString += "\n"
        }
        return fieldString
    }
}