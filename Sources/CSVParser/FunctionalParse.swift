// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

enum Result<A> {
    case done(A)
    case call(() -> Result<A>)
}

extension CSVParser {
    func functionalParseIter(cursor: String.Index, delimiterIndex: String.Index?, lineSIndex: String.Index?, row: [String], rows: [[String]], content: String) -> Result<[[String]]> {
        if cursor == content.endIndex {
            return .done(rows)
        }

        let nextCursor = content.index(after: cursor)
        if content[cursor] == quotes {
            return .call {
                self.functionalParseQuote(cursor: nextCursor, quoteIndex: cursor, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: row, rows: rows, content: content)
            }
        } else {
            // Next delimiter comes before next newline
            if let delimiterIndex = delimiterIndex {
                if let lineSIndex = lineSIndex, delimiterIndex >= lineSIndex {
                    // pass
                } else {
                    let newRow = row + [String(content[cursor..<delimiterIndex])]

                    let nextCursor = content.index(delimiterIndex, offsetBy: 1)
                    let nextDeiliterIndex = content.index(of: delimiter, after: nextCursor)
                    return .call {
                        self.functionalParseIter(cursor: nextCursor, delimiterIndex: nextDeiliterIndex, lineSIndex: lineSIndex, row: newRow, rows: rows, content: content)
                    }
                }
            }

            // end of row

            if let lineSIndex = lineSIndex {
                let newRow = row + [String(content[cursor..<lineSIndex])]

                let nextCursor = content.index(lineSIndex, offsetBy: 1)
                let nextLineSIndex = content.index(of: lineSeparator, after: nextCursor)
                return .call {
                    self.functionalParseIter(cursor: nextCursor, delimiterIndex: delimiterIndex, lineSIndex: nextLineSIndex, row: [], rows: rows + [newRow], content: content)
                }
            }

            if cursor != content.endIndex, delimiterIndex == nil, lineSIndex == nil {
                let newRow = row + [String(content[cursor..<content.endIndex])]
                return .call {
                    self.functionalParseIter(cursor: content.endIndex, delimiterIndex: nil, lineSIndex: nil, row: [], rows: rows + [newRow], content: content)
                }
            }
        }
//    return rows
        fatalError("Unexpteted error")
    }

    // the cursor must be the cursor.sussor
    private func functionalParseQuote(cursor: String.Index, quoteIndex: String.Index, delimiterIndex: String.Index?, lineSIndex: String.Index?, row: [String], rows: [[String]], content: String) -> Result<[[String]]> {
        if let nextQuote = self.content.index(of: self.quotes, after: content.index(after: quoteIndex)) {
            // end of file
            if nextQuote == content.endIndex {
                let newRow = row + [String(content[cursor..<nextQuote])]
                return .call {
                    self.functionalParseIter(cursor: content.endIndex, delimiterIndex: content.endIndex, lineSIndex: content.endIndex, row: [], rows: rows + [newRow], content: content)
                }
            }

            //  two quotes together
            if content[content.index(after: nextQuote)] == quotes {
                return .call {
                    self.functionalParseQuote(cursor: cursor, quoteIndex: nextQuote, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: row, rows: rows, content: content)
                }
            }

            // come across delimiter
            if content[content.index(after: nextQuote)] == delimiter {
                let newRow = row + [String(content[cursor..<nextQuote])]
                let nextCursor = content.index(nextQuote, offsetBy: 1 + 1)
                return .call {
                    self.functionalParseIter(cursor: nextCursor, delimiterIndex: content.index(of: self.delimiter, after: nextCursor), lineSIndex: content.index(of: self.lineSeparator, after: nextQuote), row: newRow, rows: rows, content: content)
                }
            }

            // come across nextline
            if content[content.index(after: nextQuote)] == lineSeparator {
                let newRow = row + [String(content[cursor..<nextQuote])]
                let nextCursor = content.index(nextQuote, offsetBy: 1 + 1)
                return .call {
                    self.functionalParseIter(cursor: nextCursor, delimiterIndex: content.index(of: self.delimiter, after: nextCursor), lineSIndex: content.index(of: self.lineSeparator, after: nextCursor), row: [], rows: rows + [newRow], content: content)
                }
            }
            return .call {
                self.functionalParseQuote(cursor: cursor, quoteIndex: nextQuote, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: row, rows: rows, content: content)
            }
        } else {
            fatalError("No matched quotes")
        }
    }

    func functionalParseWithQuote() {
        let startIndex = content.startIndex
        let delimiterIndex = content.index(of: delimiter, after: startIndex)
        let lineSIndex = content.index(of: lineSeparator, after: startIndex)

        var res = functionalParseIter(cursor: startIndex, delimiterIndex: delimiterIndex, lineSIndex: lineSIndex, row: [], rows: [], content: content)
        while true {
            switch res {
            case let .done(rows):
                _rows = rows
                return
            case let .call(f):
                res = f()
            }
        }
    }
}
