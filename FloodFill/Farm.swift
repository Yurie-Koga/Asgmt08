//
//  Farm.swift
//  FloodFill
//
//  Created by Uji Saori on 2021-04-07.
//

import Foundation

// input
/*
6 4
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 1

*/
// output
// 8

// input
/*
6 4
0 -1 0 0 0 0
-1 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 1

*/
// output
// -1

// input
/*
6 4
1 -1 0 0 0 0
0 -1 0 0 0 0
0 0 0 0 -1 0
0 0 0 0 -1 1

 */
// output
// 6

// input
/*
5 5
-1 1 0 0 0
0 -1 -1 -1 0
0 -1 -1 -1 0
0 -1 -1 -1 0
0 0 0 0 0

 */
// output
// 14

// input
/*
2 2
1 -1
-1 1

 */
// output
// 0

func farm() {
    struct Square {
        let x: Int
        let y: Int
    }
    
    let dx = [0, 0, 1, -1]
    let dy = [1, -1, 0, 0]
    
    let firstLine = readLine()!.split(separator: " ").map { Int($0)! }
    let width = firstLine[0]
    let height = firstLine[1]

    var tomatoMap = [[Int]]()
    var ripeCount = 0                   // the number of ripe tomatos. count up when changed. check the total at the end
    var tomatoCount = width * height    // the total amount of tomato locations
    
    for _ in 0..<height {
        let row = readLine()!.split(separator: " ").map { Int($0)! }
        tomatoMap.append(row)
    }
    for i in 0..<tomatoMap.count {
        print(tomatoMap[i])
    }

    func bfs2(squares: [Square], dayCount: inout Int) {
        var q = Queue<[Square]>()
        q.enqueue(item: squares)
        
        while !q.isEmpty() {
            let squares = q.dequeue()!   // [Square]
            var newSquares = [Square]()
            var isChanged = false
            for sq in squares {
                let x = sq.x
                let y = sq.y
                for i in 0..<4 {
                    let nx = x + dx[i]
                    let ny = y + dy[i]
                    // check the bounds
                    if nx >= 0 && nx < height && ny >= 0 && ny < width {
                        // change unripe to ripe
                        if tomatoMap[nx][ny] == 0 {
                            newSquares.append(Square(x: nx, y: ny))
                            tomatoMap[nx][ny] = 1
                            ripeCount += 1
                            isChanged = true
                        }
                    }
                }
            }
//            print("===== day \(dayCount) =====")
//            for j in 0..<tomatoMap.count {
//                print(tomatoMap[j])
//            }
            if newSquares.count > 0{
                q.enqueue(item: newSquares)
            }
            if isChanged {
                dayCount += 1
            }
        }
    }
    
    var dayCount = 0
    var squares = [Square]()
    for x in 0..<height {
        for y in 0..<width {
            if tomatoMap[x][y] == 1 {
                ripeCount += 1
                squares.append(Square(x: x, y: y))
            } else if tomatoMap[x][y] == -1 {
                tomatoCount -= 1
            }
        }
    }
    bfs2(squares: squares, dayCount: &dayCount)
//    print("total: \(tomatoCount), ripe: \(ripeCount)")
//    print("===== it took \(dayCount) days =====")
//    for i in 0..<tomatoMap.count {
//        print(tomatoMap[i])
//    }
    
    if tomatoCount == ripeCount {
        print(dayCount)
    } else {
        print("-1")
    }
}
