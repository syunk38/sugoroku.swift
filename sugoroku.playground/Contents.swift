import UIKit

// CollectionTypeプロトコルを拡張してshuffle()関数を追加している
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
    print("すごろくをはじめます。")
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
  
  // Playersというclass作って責務委譲してもいいかもね
  private func decidePlayerOrder() {
    self.players = self.players.shuffle()
    for (i, player) in players.enumerate() {
      print("\(i+1)番：\(player.name)")
    }
  }
  
  private func play() -> Bool {
    for player in self.players {
      player.diceRoll(self.dice!)
      self.board!.grids[player.position].event()
      
      if player.position >= self.board!.grid_count {
        print("\(player.name)があがり！")
        return true
      }
    }
    return false
  }
  
  func start() {
    decidePlayerOrder()
    print("すごろくスタート！")
    var isAnyPlayerGoal = false
    while !isAnyPlayerGoal {
      isAnyPlayerGoal = play()
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
  
  // TODO: grid_countを引数に取る形にリファクタリング
  private func createGrids() -> [Grid] {
    var grids = [Grid]()
    for _ in 1...self.grid_count {
      grids.append(getGrid())
      grids.append(VanillaGrid()) // ゴールは普通のマス
    }
    return grids
  }
  
  private func getGrid() -> Grid{
    return VanillaGrid()
  }
  
}

class Player {
  var name:String
  var position = 0
  
  init(name:String){
    self.name = name
    print("\(name)が参加しました。")
  }
  
  func diceRoll(dice:Dice) {
    let spot = dice.roll()
    print("\(self.name)の出目は\(spot)")
    self.moveTo(spot)
  }
  
  func moveTo(to:Int) {
    self.position = self.position + to
    print("\(self.name)が\(self.position)マスへ移動しました。")
  }
}

protocol Grid {
  var name : String {get}
  
  func event()
}

class VanillaGrid : Grid{
  init () {
    
  }
  var name:String{
    get {
      return "普通のマス"
    }
  }
  
  func aboutMe() ->String {
    return "普通のマス"
  }
  
  func event() {
    
  }
}

class Dice {
  // 自分の面数
  let spot:UInt32 = 6
  init() {
    print("ダイスは\(spot)面")
  }
  // TODO: 1~spotまでのランダムの整数を返す
  func roll() -> Int {
    let r = Int(arc4random() % self.spot) + 1
    return r
  }
}

var game = Game.getInstance()
game.setBoard(Board(grid_count: 30))
game.setDice(Dice())
game.addPlayer(Player(name: "hyde"))
game.addPlayer(Player(name: "tetsuya"))
game.addPlayer(Player(name: "ken"))
game.addPlayer(Player(name: "yukihiro"))
game.start()
