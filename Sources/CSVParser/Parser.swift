// Copyright © 2019 ChouTi. All rights reserved.

import Foundation

extension CSVParser {
    // if there is no quotes in content
    func parserNoQuote() {
        _rows = content.nzSplitElements(lineSeparator: lineSeparator, delimiter: delimiter)
    }

    func parseWithQuotes() throws {
        var cursor = content.startIndex
        var nextDelimiter = content.firstIndex(of: delimiter)
        var nextLine = content.firstIndex(of: lineSeparator)
        var row = [String]()
        while true, cursor != content.endIndex {
            // need to pares with quotes
            if content[cursor] == quotes {
                var nextQuote = cursor
                cursor = content.index(after: cursor)
                while true {
                    if let nextQ = self.content.index(of: quotes, after: content.index(after: nextQuote)) {
                        nextQuote = nextQ

                        // end of file
                        if nextQuote == content.endIndex
                            || content.index(after: nextQuote) == content.endIndex {
                            row.append(String(content[cursor..<nextQuote]))
                            _rows.append(row)
                            return
                        }

                        // two quotes together
                        if content[content.index(after: nextQuote)] == quotes {
                            nextQuote = content.index(after: nextQuote)
                            continue
                        }

                        // come across delimiter
                        if content[content.index(after: nextQuote)] == delimiter {
                            row.append(String(content[cursor..<nextQuote]))
                            cursor = content.index(nextQuote, offsetBy: 1 + 1)
                            // need to be the cursor next index

                            nextDelimiter = content.index(of: delimiter, after: cursor)
                            nextLine = content.index(of: lineSeparator, after: cursor)
                            break
                        }

                        // come accross nextline
                        if content[content.index(after: nextQuote)] == lineSeparator {
                            row.append(String(content[cursor..<nextQuote]))
                            _rows.append(row)
                            row.removeAll(keepingCapacity: true)
                            // nextDelimiter = inputContents.suffix(from: cursor).index(of: self.delimiter)
                            cursor = content.index(nextQuote, offsetBy: 1 + 1)
                            nextDelimiter = content.index(of: delimiter, after: cursor)
                            nextLine = content.index(of: lineSeparator, after: cursor)
                            break
                        }

                    } else {
                        throw CSVParserError.containMismatchedQuotes
                    }
                }
                continue
            }

            // Next delimiter comes before next newline
            if let nextDelim = nextDelimiter {
                if let nextLine = nextLine, nextDelim >= nextLine {
                    // pass
                } else {
                    row.append(String(content[cursor..<nextDelim]))
                    cursor = content.index(nextDelim, offsetBy: 1)
                    nextDelimiter = content.index(of: delimiter, after: cursor)
                    continue
                }
            }

            // end of row
            if let nextNewLine = nextLine {
                row.append(String(content[cursor..<nextNewLine]))
                _rows.append(row)
                row.removeAll(keepingCapacity: true)
                cursor = content.index(nextNewLine, offsetBy: 1)

                nextLine = content.index(of: lineSeparator, after: cursor)

                continue
            }

            // the last element
            if cursor != content.endIndex, nextDelimiter == nil, nextLine == nil {
                row.append(String(content[cursor..<self.content.endIndex]))
                _rows.append(row)
                row.removeAll(keepingCapacity: true)
                cursor = content.endIndex
            }

            break
        }
    }

    // Functional Parse
//    func concurrencyParse(handler:  @escaping ()->()) {
//      let wordsInOneTime = 100
//      let parseGroup = DispatchGroup()
//      // writeRowQueue is a serial queue not concurrent
//      let writeRowQueue = DispatchQueue(label: "com.csvparser.write", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
//      writeRowQueue.setTarget(queue: DispatchQueue.global(qos: .default))
//      for i in 0...self.lines.count / wordsInOneTime {
//        let workItem = DispatchWorkItem(block: {
//          let min = wordsInOneTime < (self.lines.count - i*wordsInOneTime) ? wordsInOneTime : (self.lines.count - i*wordsInOneTime)
//          for j in 0..<min{
//            let index = i*wordsInOneTime + j
    //  //          self.rows[index] =
//            let parsedLine = self.lines[index].words()
    //  //          dispatch_barrier_async(<#T##queue: DispatchQueue##DispatchQueue#>, <#T##block: () -> Void##() -> Void#>)
//            writeRowQueue.async(group: parseGroup, qos: .default, flags: .barrier) {
//              self.rows[index] = parsedLine
//            }
//          }
//        })
//        DispatchQueue.global(qos: .userInitiated).async(group: parseGroup, execute: workItem)
    //
//      }
    //  //    parseGroup.notify(queue: DispatchQueue.main, execute: handler)
//      parseGroup.wait()
//      handler()
//    }
}
