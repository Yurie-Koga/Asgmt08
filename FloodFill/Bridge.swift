//
//  Bridge.swift
//  FloodFill
//
//  Created by Uji Saori on 2021-04-07.
//

import Foundation

// input
/*
10
1 1 1 0 0 0 0 1 1 1
1 1 1 1 0 0 0 0 1 1
1 0 1 1 0 0 0 0 1 1
0 0 1 1 1 0 0 0 0 1
0 0 0 1 0 0 0 0 0 1
0 0 0 0 0 0 0 0 0 1
0 0 0 0 0 0 0 0 0 0
0 0 0 0 1 1 0 0 0 0
0 0 0 0 1 1 1 0 0 0
0 0 0 0 0 0 0 0 0 0

*/
// output
// 3

// input
/*
10
1 1 1 0 0 0 0 1 1 1
1 1 1 1 0 0 0 0 1 1
1 0 1 1 0 0 0 0 1 1
0 0 1 1 1 0 0 0 0 1
0 0 0 1 0 0 0 0 0 1
0 0 0 0 0 0 1 0 0 1
0 0 0 0 0 0 1 0 0 0
0 0 0 0 1 1 1 0 0 0
0 0 0 0 1 1 1 0 0 0
0 0 0 0 0 0 0 0 0 0

 */
// output
// 2
func bridge() {
    struct Square {
        let x: Int
        let y: Int
    }
    
    let dx = [0, 0, 1, -1]
    let dy = [1, -1, 0, 0]
    
    let n = Int(readLine()!)!
    var islandMap = [[Int]]()
    var coloredMap = [[Int]](repeating: [Int](repeating: 0, count: n), count: n)
    var distanceMap = [[Int]](repeating: [Int](repeating: -1, count: n), count: n)
    
    for _ in 0..<n {
        let row = readLine()!.split(separator: " ").map { Int($0)! }
        islandMap.append(row)
    }
    
    // 1. color each island
    func bfsColor(square: Square, id: Int) {
        let q = Queue<Square>()
        q.enqueue(item: square)
        coloredMap[square.x][square.y] = id
        
        while !q.isEmpty() {
            let sq = q.dequeue()!
            let x = sq.x
            let y = sq.y
            for i in 0..<4 {
                let nx = x + dx[i]
                let ny = y + dy[i]
                // check the bounds
                if nx >= 0 && nx < n && ny >= 0 && ny < n {
                    // color island
                    if (islandMap[nx][ny] == 1 && coloredMap[nx][ny] == 0) {
                        q.enqueue(item: Square(x: nx, y: ny))
                        coloredMap[nx][ny] = id
                    }
                }
            }
        }
    }
    var id = 0
    for x in 0..<n {
        for y in 0..<n {
            if islandMap[x][y] == 1 && coloredMap[x][y] == 0 {
                id += 1
                bfsColor(square: Square(x: x, y: y), id: id)
            }
        }
    }
//    print("== color map ==")
//    for i in 0..<coloredMap.count {
//        print(coloredMap[i])
//    }
    
    // 2. set distance
    let q = Queue<Square>()
    for x in 0..<n {
        for y in 0..<n {
            if islandMap[x][y] == 1 {
                q.enqueue(item: Square(x: x, y: y))
                distanceMap[x][y] = 0
            }
        }
    }
    while !q.isEmpty() {
        let sq = q.dequeue()!
        let x = sq.x
        let y = sq.y
        for k in 0..<4 {
            let nx = x + dx[k]
            let ny = y + dy[k]
            if nx >= 0 && nx < n && ny >= 0 && ny < n {
                if distanceMap[nx][ny] == -1 {
                    distanceMap[nx][ny] = distanceMap[x][y] + 1
                    coloredMap[nx][ny] = coloredMap[x][y]
                    q.enqueue(item: Square(x: nx, y: ny))
                }
            }
        }
    }
//    print("== distance map ==")
//    for i in 0..<distanceMap.count {
//        print(distanceMap[i])
//    }
    
    // 3. shortest bridge
    var answer = Int.max
    for x in 0..<n {
        for y in 0..<n {
            for i in 0..<4 {
                let nx = x + dx[i]
                let ny = y + dy[i]
                if nx >= 0 && nx < n && ny >= 0 && ny < n {
                    if coloredMap[x][y] != coloredMap[nx][ny] {
                        answer = min(answer, distanceMap[x][y] + distanceMap[nx][ny])
                    }
                }
            }
        }
    }
    print(answer)
}
