import UIKit
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
  
  func movePlayerTo(player:Player, to:Int) {
    
  }
  
  func setDice(dice:Dice){
    self.dice = dice
  }
  
  private func decidePlayerOrder() {
    self.players
  }
  
  func start() {
    print("すごろくスタート")
    // サイコロを降る順番を決める
    decidePlayerOrder()
    // 順番にサイコロを振る
    // マスのイベントが発生する
    // ゴールに達しているプレイヤーがいないかチェックする
    // ゴールに達しているプレイヤーがいればゲームを終わる
    print("あがり！")
    // どちらかのユーザーのマスがboardのマスの上限を超えるまでサイコロを降る。
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
  
  func setPosition(position:Int) {
    self.position = position
    print("\(self.name)が\(self.position)マスへ移動しました。")
  }
}

class Grid {
  // 発火するイベント
  func event() {
    
  }
}

class VanillaGrid : Grid{
  
}

class Dice {
  // 自分の面数
  let spot:UInt32 = 6
  init() {
    print("ダイスは\(spot)面")
  }
  // 1~spotまでのランダムの整数を返す
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
