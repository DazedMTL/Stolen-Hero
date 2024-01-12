
#--------------------------------------------------------------------------
# ■ WindMesser 解像度640x480対応プロジェクト(VX Ace版) ver1.00
#--------------------------------------------------------------------------
#   作成者：塵風
#      URL：http://windmesser.cc/
#     MAIL：windmesser4913@yahoo.co.jp
#--------------------------------------------------------------------------
#     概要：RPGツクールVX Aceの解像度を640x480に変更します。
#     仕様：タイトル、ゲームオーバー、戦闘時の背景画像を自動的に拡大します。
#           戦闘背景は 672x512 になるように、
#           それ以外は 640x480 になるように拡大します。
#           また、戦闘時の敵の初期位置を解像度に合わせて修正します。
#           ウィンドウ表示についても若干のレイアウト調整が加えられています。
#
# 使用条件：各素材の推奨画像サイズは以下となっています。
#           ※トランジション素材は必須です。
#
#           ・タイトル(Graphics/System/Titles1, Graphics/System/Titles2)
#               640x480
#           ・ゲームオーバー(Graphics/System/GameOver.png)
#               640x480
#           ・戦闘背景(Graphics/BattleBacks1, Graphics/BattleBacks2)
#               672x512
#           ・トランジション(Graphics/System/BattleStart.png)
#               640x480
#           
# 使用方法：スクリプトエディタの「▼素材」以下に挿入してください
#--------------------------------------------------------------------------
#  ver1.00：ウィンドウ表示まわりのレイアウト調整
#           HPゲージやアイテム名表示領域などを広げ、
#           なるべくウィンドウがスカスカにみえないようにしています。
#  ver0.91：戦闘背景を一回り大きなサイズになるように拡大
#           拡大しないようにするには画像サイズを 676x512 にします。
#  ver0.90：背景画像等の拡大調整のみのシンプルなバージョン
#--------------------------------------------------------------------------

#==============================================================================
# ▼ 内部仕様の定数
#==============================================================================

# 解像度640x480プロジェクト使用フラグ
# ※他スクリプト素材配布者様向けの判断用フラグ変数です
#   (Graphics.width, Graphics.height で判断する事もできます)
$VXA_640x480 = true

# VX Ace デフォルト解像度
$VXA_O_WIDTH = 544
$VXA_O_HEIGHT = 416

# 解像度を640x480に変更
Graphics.resize_screen(640, 480)

#==============================================================================
# ▼ 追加メソッド
#==============================================================================

class Sprite
  
  #--------------------------------------------------------------------------
  # ● スプライト拡大メソッド
  #    使用素材幅がデフォルト解像度に準拠していれば拡大
  #--------------------------------------------------------------------------
  def vxa_640x480_zoom(add_w = 0, add_h = 0)
    
    self.zoom_x = (Graphics.width + add_w) * 1.0 / width
    self.zoom_y = (Graphics.height + add_h) * 1.0 / height

  end
  
end

#==============================================================================
# ▼ プリセットスクリプト再定義１：画像拡大など
#==============================================================================

#==============================================================================
# ■ Scene_Title
#------------------------------------------------------------------------------
# 　タイトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Title < Scene_Base
  
  if !method_defined?(:create_background_vga)
    alias create_background_vga create_background
  end
  
  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  def create_background
    create_background_vga
    
    # タイトル画像の拡大
    @sprite1.vxa_640x480_zoom
    @sprite2.vxa_640x480_zoom

  end
  
end

#==============================================================================
# ■ Scene_Gameover
#------------------------------------------------------------------------------
# 　ゲームオーバー画面の処理を行うクラスです。
#==============================================================================

class Scene_Gameover < Scene_Base
  
  if !method_defined?(:create_background_vga)
    alias create_background_vga create_background
  end

  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  def create_background
    create_background_vga
    
    # ゲームオーバー画像の拡大
    @sprite.vxa_640x480_zoom
    
  end

end

#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。このクラスは Scene_Battle クラ
# スの内部で使用されます。
#==============================================================================

class Spriteset_Battle
  
  if !method_defined?(:create_battleback1_vga)
    alias create_battleback1_vga create_battleback1
    alias create_battleback2_vga create_battleback2
    alias create_enemies_vga create_enemies
  end
 
  #--------------------------------------------------------------------------
  # ● 戦闘背景（床）スプライトの作成
  #--------------------------------------------------------------------------
  def create_battleback1
    create_battleback1_vga
    
    # 戦闘背景の拡大
    @back1_sprite.vxa_640x480_zoom(36, 32)
    
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（壁）スプライトの作成
  #--------------------------------------------------------------------------
  def create_battleback2
    create_battleback2_vga
    
    # 戦闘背景の拡大
    @back2_sprite.vxa_640x480_zoom(36, 32)
    
  end
  
end

#==============================================================================
# ■ Game_Troop
#------------------------------------------------------------------------------
# 　敵グループおよび戦闘に関するデータを扱うクラスです。バトルイベントの処理も
# 行います。このクラスのインスタンスは $game_troop で参照されます。
#==============================================================================

class Game_Troop < Game_Unit
  
  if !method_defined?(:setup_vga)
    alias setup_vga setup
  end
  
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  def setup(troop_id)
    setup_vga(troop_id)
    
    # トループ座標の修正
    @enemies.each do |enemy|
      enemy.screen_x = (enemy.screen_x * (Graphics.width * 1.0 / $VXA_O_WIDTH)).to_i
      enemy.screen_y = (enemy.screen_y * (Graphics.height * 1.0 / $VXA_O_HEIGHT)).to_i
    end
    
  end
  
end

#==============================================================================
# ▼ プリセットスクリプト再定義２：ウィンドウレイアウト調整など
#==============================================================================

#==============================================================================
# ■ Window_Base
#------------------------------------------------------------------------------
# 　ゲーム中の全てのウィンドウのスーパークラスです。
#==============================================================================

class Window_Base < Window
  if !method_defined?(:draw_actor_name_vga)
    alias draw_actor_name_vga draw_actor_name
    alias draw_actor_class_vga draw_actor_class
    alias draw_actor_hp_vga draw_actor_hp
    alias draw_actor_mp_vga draw_actor_mp
    alias draw_actor_tp_vga draw_actor_tp
    alias draw_item_name_vga draw_item_name
  end
  
  #--------------------------------------------------------------------------
  # ● 名前の描画
  #--------------------------------------------------------------------------
  def draw_actor_name(actor, x, y, width = 144)
    draw_actor_name_vga(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  # ● 職業の描画
  #--------------------------------------------------------------------------
  def draw_actor_class(actor, x, y, width = 144)
    draw_actor_class_vga(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  # ● HP の描画
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 188)
    draw_actor_hp_vga(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  # ● MP の描画
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 188)
    draw_actor_mp_vga(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  # ● TP の描画
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = 188)
    draw_actor_tp_vga(actor, x, y, width)
  end
  #--------------------------------------------------------------------------
  # ● シンプルなステータスの描画
  #--------------------------------------------------------------------------
  def draw_actor_simple_status(actor, x, y)
    draw_actor_name(actor, x, y)
    draw_actor_level(actor, x, y + line_height * 1)
    draw_actor_icons(actor, x, y + line_height * 2)
    draw_actor_class(actor, x + 152, y)
    draw_actor_hp(actor, x + 152, y + line_height * 1)
    draw_actor_mp(actor, x + 152, y + line_height * 2)
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id)
    change_color(system_color)
    draw_text(x, y, 152, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + 152, y, 36, line_height, actor.param(param_id), 2)
  end
  #--------------------------------------------------------------------------
  # ● アイテム名の描画
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 236)
    draw_item_name_vga(item, x, y, enabled, width)
  end
  
end

#==============================================================================
# ■ Window_Status
#------------------------------------------------------------------------------
# 　ステータス画面で表示する、フル仕様のステータスウィンドウです。
#==============================================================================

class Window_Status < Window_Selectable
  
  #--------------------------------------------------------------------------
  # ● ブロック 1 の描画
  #--------------------------------------------------------------------------
  def draw_block1(y)
    draw_actor_name(@actor, 4, y)
    draw_actor_class(@actor, 128, y)
    draw_actor_nickname(@actor, 336, y)
  end
  #--------------------------------------------------------------------------
  # ● ブロック 2 の描画
  #--------------------------------------------------------------------------
  def draw_block2(y)
    draw_actor_face(@actor, 8, y)
    draw_basic_info(136, y)
    draw_exp_info(336, y)
  end
  #--------------------------------------------------------------------------
  # ● ブロック 3 の描画
  #--------------------------------------------------------------------------
  def draw_block3(y)
    draw_parameters(32, y)
    draw_equipments(336, y)
  end
  #--------------------------------------------------------------------------
  # ● 経験値情報の描画
  #--------------------------------------------------------------------------
  def draw_exp_info(x, y)
    s1 = @actor.max_level? ? "-------" : @actor.exp
    s2 = @actor.max_level? ? "-------" : @actor.next_level_exp - @actor.exp
    s_next = sprintf(Vocab::ExpNext, Vocab::level)
    change_color(system_color)
    draw_text(x, y + line_height * 0, 180, line_height, Vocab::ExpTotal)
    draw_text(x, y + line_height * 2, 180, line_height, s_next)
    change_color(normal_color)
    draw_text(x, y + line_height * 1, 180, line_height, s1, 2)
    draw_text(x, y + line_height * 3, 180, line_height, s2, 2)
  end
  
end

#==============================================================================
# ■ Window_BattleStatus
#------------------------------------------------------------------------------
# 　バトル画面で、パーティメンバーのステータスを表示するウィンドウです。
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● ゲージエリアの幅を取得
  #--------------------------------------------------------------------------
  def gauge_area_width
    return 284
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP あり）
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 136)
    draw_actor_mp(actor, rect.x + 146, rect.y, 64)
    draw_actor_tp(actor, rect.x + 220, rect.y, 64)
  end
  #--------------------------------------------------------------------------
  # ● ゲージエリアの描画（TP なし）
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 166)
    draw_actor_mp(actor, rect.x + 176,  rect.y, 108)
  end
end