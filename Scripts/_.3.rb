#==============================================================================
# ■ 特定番号のピクチャ前面化対応(マップ版)　by雪月
#------------------------------------------------------------------------------
# 　通常、ピクチャはウィンドウメッセージなどの下に表示されるよう
# 　viewportというもので制御されていますが、
#   特定番号のピクチャのみ新規にviewportを作成し、
#   それらよりも前に表示されるようz軸を調整したスクリプトとなります。
#
#   要するにピクチャを文章表示より前に出したい事情がある人向け。
#==============================================================================
module SNOW_PICTURE_Z_FIX
  #マップで前に出したいピクチャ番号の指定。デフォルト88番だけ前に出るよ！
  MAP_FIX_NUMBER = 20
end

#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。このクラスは Scene_Battle クラ
# スの内部で使用されます。
#==============================================================================

class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● ピクチャスプライトの更新(再定義)
  #--------------------------------------------------------------------------
  def update_pictures
    $game_map.screen.pictures.each do |pic|
      if pic.number == SNOW_PICTURE_Z_FIX::MAP_FIX_NUMBER
        @picture_sprites[pic.number] ||= Sprite_Picture.new(@viewport_snow_pic_fix, pic)
        @picture_sprites[pic.number].update
      else
        @picture_sprites[pic.number] ||= Sprite_Picture.new(@viewport2, pic)
        @picture_sprites[pic.number].update
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの作成(エイリアス)
  #--------------------------------------------------------------------------
  alias snow_pic_create_viewports create_viewports
  def create_viewports
    snow_pic_create_viewports
    @viewport_snow_pic_fix = Viewport.new
    @viewport_snow_pic_fix.z = 201
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの解放(エイリアス)
  #--------------------------------------------------------------------------
  alias snow_pic_dispose_viewports dispose_viewports
  def dispose_viewports
    snow_pic_dispose_viewports
    @viewport_snow_pic_fix.dispose
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの更新(エイリアス)
  #--------------------------------------------------------------------------
  alias snow_pic_update_viewports update_viewports
  def update_viewports
    snow_pic_update_viewports
    @viewport_snow_pic_fix.ox = $game_troop.screen.shake
    @viewport_snow_pic_fix.update
  end
end