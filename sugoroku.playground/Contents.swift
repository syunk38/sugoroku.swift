import UIKit

extension CollectionType {
  /// Return a copy of `self` with its elements shuffled
  func shuffle() -> [Generator.Element] {
    var list = Array(self)
    list.shuffleInPlace()
    return list
  }
}

extension MutableCollectionType where Index == Int {
  /// Shuffle the elements of `self` in-place.
  mutating func shuffleInPlace() {
    // empty and single-element collections don't shuffle
    if count < 2 { return }
    
    for i in 0..<count - 1 {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      guard i != j else { continue }
      swap(&self[i], &self[j])
    }
  }
}

class Game {
  var players:[Player] = [Player]()
  var board:Board?
  var dice:Dice?
  
  static let sharedInstance = Game()
  
  init() {
    print("すごろくの準備をします。")
  }
  
  static func getInstance() -> Game {
    return sharedInstance
  }
  
  func setBoard(board:Board) {
    self.board = board
  }
  
  func addPlayer(player:Player){
    players.append(player)
  }
  
  func setDice(dice:Dice){
    self.dice = dice
  }
  
  private func decidePlayerOrder() {
    self.players = self.players.shuffle()
    for (i, player) in players.enumerate() {
      print("\(i+1)番：\(player.name)")
    }
  }
  
  private func action(player:Player) {
    player.action(self.dice!)
    self.board!.grids[player.position].event()
  }
  
  func start() {
    print("すごろくスタート")
    decidePlayerOrder()
    var isAnyPlayerGoal = false
    while(!isAnyPlayerGoal) {
      for player in players {
        action(player)
        if(player.position >= self.board!.grid_count) {
          print("\(player.name)があがり！")
          isAnyPlayerGoal = true
        }
      }
    }
  }
}

class Board {
  var grid_count:Int
  var grids:[Grid] = [Grid]()
  
  init (grid_count:Int) {
    self.grid_count = grid_count
    self.grids = createGrids()
    print("マスは\(self.grid_count)マス")
  }
  
  private func createGrids() -> [Grid] {
    var grids = [Grid]()
    for _ in 1...self.grid_count {
      grids.append(getGrid())
      grids.append(Grid()) // ゴールは普通のマス
    }
    return grids
  }
  
  private func getGrid() -> Grid{
    return Grid()
  }
  
}

class Player {
  var name:String
  var position = 0
  
  init(name:String){
    self.name = name
    print("\(name)が参加しました。")
  }
  
  func action(dice:Dice) {
    let spot = dice.rollDice()
    self.moveTo(spot)
    print("\(self.name)の出目は\(spot)")
  }
  
  func moveTo(to:Int) {
    self.position = self.position + to
    print("\(self.name)が\(self.position)マスへ移動しました。")
  }
}

class Grid {
  // 発火するイベント
  func event() {
    
  }
}

class VanillaGrid : Grid{
  func aboutMe() ->String {
    return "普通のマス"
  }
}

class Dice {
  // 自分の面数
  let spot:UInt32 = 6
  init() {
    print("ダイスは\(spot)面")
  }
  // TODO: 1~spotまでのランダムの整数を返す
  func rollDice() -> Int {
    let n = 6
    return n
  }
}

var game = Game.getInstance()
game.setBoard(Board(grid_count: 30))
game.setDice(Dice())
game.addPlayer(Player(name: "マオ"))
game.addPlayer(Player(name: "シンジ"))
game.start()
