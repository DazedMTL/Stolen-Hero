#==============================================================================
# ■ RGSS3 アニメーション機能拡張 Ver1.08 by 星潟
#------------------------------------------------------------------------------
# アニメーションについて、以下の機能を追加します。
# 処理の関係上、素材欄の中でも上の方に配置される事が推奨されますが
# 下の方でもまあ大丈夫だと思います。
#==============================================================================
# ★アニメーション表示の左右逆転
#
#   バトラースプライトに対し、画面の左寄りか右寄りかで
#   アニメーション表示位置を逆転させます。
#   それぞれ、左右どちらを本来の基準にするかを設定できます。
#   （何も設定しなければ、常に本来の設定どおりのアニメーションとなります）
#   なお、バトラースプライト以外の場合や
#   画面中央ぴったりの場合は通常と同じ扱いとなります。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     左寄りの場合に通常、右寄りの場合にアニメを反転させたい場合
#     アイテム/スキルのメモ欄に<アニメ左優先>と記入する。
#------------------------------------------------------------------------------
#     右寄りの場合に通常、左寄りの場合にアニメを反転させたい場合
#     アイテム/スキルのメモ欄に<アニメ右優先>と記入する。
#==============================================================================
# ★アニメーションの速度
# 
#   アニメーションの速度を設定します。
#   デフォルトの値を変更する事と、個別のアニメ速度の変更が可能です。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     アニメーションの名前に<アニメ速度:3>と記入する事で
#     このアニメーションの速度は
#     デフォルトのアニメーション速度の1.5倍速となります。
#     デフォルトの速度は4で、2で2倍、8で1/2となります。
#==============================================================================
# ★ターゲットバックアニメーション
#
#   アニメーション1、アニメーション2、あるいはその両方を
#   ターゲットの後方に表示させるようにします。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     アニメーションの名前に[1B]を含める事で
#     アニメーション1がターゲットの後方に表示されます。
#------------------------------------------------------------------------------
#     アニメーションの名前に[2B]を含める事で
#     アニメーション2がターゲットの後方に表示されます。
#------------------------------------------------------------------------------
#     [1B]と[2B]を両方同時に使用する事も出来ます。
#==============================================================================
# ★アニメーション対象の透過度による自らの透過度変更無視化
# 
#   通常、透明度が0となっている対象へアニメーションを行った場合
#   アニメーションも透明となってしまいますが
#   この設定を無効化し、本来の透過度で表示を行います。
#   また、この設定は個別に無効化する事が出来ます。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     アニメーションの名前に<透過設定逆転>を含める事で
#     設定されている透過設定を逆転する事が出来ます。
#==============================================================================
# ★アニメーションの座標調整
#
#   アニメーション位置のX座標・Y座標を本来の位置から更に調整します。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     アニメーションの名前に<座標調整:50,-50>を含める事で
#     表示座標の基準位置がX座標は+50、Y座標は-50されます。
#==============================================================================
# ★アニメーション時のシェイク
#
#   アニメーション時に画面のシェイクを行います。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     アニメーションのSE・フラッシュ設定時に
#    「shake」というSEを鳴らすようにした場合
#     フラッシュの赤要素が強さ、緑要素が速さ、
#     青要素がフレーム数と変換して、シェイクが実行されます。
#     デフォルトでは、一定以上の強さのシェイクを行うと
#     背景が見切れる事があるので注意が必要です。
#     この際、「shake」というSEそのものは再生されません。
#==============================================================================
# ★戦闘背景フラッシュ
#
#   戦闘中のアニメーション時に戦闘背景のみに対しフラッシュを行います。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     アニメーションのSE・フラッシュ設定時に
#     「back_flash」というSEを鳴らすようにした場合
#     フラッシュの対象が戦闘背景に変更されます。
#     この際、「back_flash」というSEそのものは再生されません。
#==============================================================================
# ★「shake」や「back_flash」といったSEデータの簡単な作り方
#
#   1.メモ帳を開きます。
#
#   2.「shake.ogg」や「back_flash.ogg」という名前にして保存します。
#
#   3.保存先を見るとtxtファイルではなくoggファイルが生成されているので
#     それをそのままSEフォルダに入れます。
#==============================================================================
# ★アニメーションビューポート指定消去
#
#   アニメーションを最前面に発生させます。
#   フラッシュ等よりも更に前面に発生させるので、設定には注意が必要です。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     アニメーションの名前に[AVNIL]を含めると
#     そのアニメーションのビューポート指定が消滅し、最前面表示化されます。
#==============================================================================
# ★追加アニメーション
#   
#   指定したアニメーションについて
#   名前欄で指定した追加アニメーションタイプの設定を参照し
#   アニメーション中に追加でアニメーションを実行します。
#------------------------------------------------------------------------------
#   ☆設定例
#------------------------------------------------------------------------------
#     <RA:1>
# 
#     アニメーションの名前に上記を含めると
#     このアニメーションはアニメーション追加タイプ1の設定を参照し
#     対応したフレームにおいてアニメーションを追加実行します。
#==============================================================================
module STAR_ANIME_ENH
  
  #空のハッシュを用意(変更不要)
  
  A = {}
  T = {}
  
  #アニメーション速度を設定します。
  #プリセットスクリプト（デフォ）では4です。
  #数字が小さくなるほど早く、大きくなるほど遅くなります。
  #1以下、もしくは小数点を含む数字を設定すると
  #不具合が発生するので注意してください。
  #個別設定が優先されます。
  
  ANIME_SPEED = 4
  
  #アニメーションの透過度が対象グラフィックの透過度に
  #影響するかどうかを決定します。
  #trueで表示、falseで非表示です。
  #プリセットスクリプト（デフォ）ではfalseです。
  #個別設定で逆転させる事が可能です。
  
  TRANS_ANIME  = true
  
  #通常は位置が画面のアニメーションは敵全体分重ねて表示され
  #SEも敵全体分演奏判定が行われますが
  #これを1体分だけの変更するかどうかを選びます。
  #trueで1体分のみ、falseで規定数分表示します。
  #なお、単体対象のフラッシュはしっかり規定数分発生しますのでご安心を。
  #内部処理的には、元データを基に新たなアニメーションデータを作成し
  #それを実行している形となります。
  #（1体分のみにする事で、大規模な画面アニメーションのアイテムやスキルを
  #  複数対象に行った場合、大幅な軽量化が見込めます）
  
  SCREEN_ONCE  = true
  
  #SCREEN_ONCEがtrueの場合でも演奏対象となるSEの名前を指定します。
  #これはSEを動作の起点にしているスクリプトの使用を想定した物です。
  #基本的には設定する必要はありません。
  #
  #設定例.
  #ANTIONCE_SE    = ["Monster1"]
  
  ANTIONCE_SE    = []
  
  #左寄りの場合に通常、右寄りの場合に
  #アニメを反転させたい場合のキーワードを設定する。
  
  WORD1 = "アニメ左優先"
  
  #右寄りの場合に通常、左寄りの場合に
  #アニメを反転させたい場合のキーワードを設定する。
  
  WORD2 = "アニメ右優先"
  
  #個別にアニメーションの速度を設定したい際の
  #キーワードを設定する。
  
  WORD3 = "アニメ速度"
  
  #アニメーション1を後方表示化する為のキーワードを設定します。
  
  WORD4 = "[1B]"
  
  #アニメーション2を後方表示化する為のキーワードを設定します。
  
  WORD5 = "[2B]"

  #透過度無効化設定を無効化したいアニメーションを
  #設定する場合のキーワードを設定する。
  
  WORD6 = "透過設定逆転"
  
  #X座標・Y座標の位置を調節したいアニメーションを
  #設定する場合のキーワードを設定する。
  
  WORD7 = "座標調整"
  
  #アニメーションを強制的にビューポート指定なしで再生する為の
  #設定用キーワードを指定します。
  
  WORD8 = "[AVNIL]"
  
  #追加アニメーション設定用キーワードを指定します。
  
  WORD9 = "RA"
  
  #アニメーション追加項目を指定
  #例.A[1] = {:t => 3,:r => 75,:a => 2,:bx => 50,:by => 100,:rx => 60,:ry => 30}
  #この場合、3回判定を行い、各判定時の追加確率は75％。
  #追加されるアニメーションはアニメーションID2で
  #基準位置はX座標に+50、Y座標に+100の補正を加える。
  #更にランダムでX座標にプラマイ60以内の補正、
  #更にランダムでY座標にプラマイ30以内の補正を加える。
  
  A[1] = {:t => 3,:r => 75,:a => 2,:bx => 0,:by => 0,:rx => 60,:ry => 60}
  A[2] = {:t => 3,:r => 75,:a => 3,:bx => 0,:by => 0,:rx => 60,:ry => 60}
  A[3] = {:t => 3,:r => 75,:a => 4,:bx => 0,:by => 0,:rx => 60,:ry => 60}
  A[4] = {:t => 1,:r => 100,:a => 5,:bx => 0,:by => 0,:rx => 0,:ry => 0}
  
  #アニメーション追加タイプを指定
  #タイプ内におけるフレーム別のアニメーション追加項目IDを指定
  #例.T[1] = {2 => [1],4 => [1,2],6 => [1,2,3],8 => [4]}
  #この場合
  #2フレーム目にアニメーション追加項目1、
  #4フレーム目にアニメーション追加項目1と2、
  #6フレーム目にアニメーション追加項目1と2と3、
  #8フレーム目にアニメーション追加項目4をそれぞれ実行。
  
  T[1] = {2 => [1],4 => [2],6 => [3],8 => [4]}
  
end
class Game_Temp
  #--------------------------------------------------------------------------
  # 左右反転フラグと背景フラッシュ情報の取得。
  #--------------------------------------------------------------------------
  attr_accessor :lr_rev_a
  attr_accessor :parallax_flash
end
class Game_BattlerBase
  attr_accessor :screen_animation_targets
end
class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_acs initialize
  def initialize(viewport = nil)
    initialize_acs(viewport)
    @random_add_animations = []
  end
  #--------------------------------------------------------------------------
  # 解放
  #--------------------------------------------------------------------------
  alias dispose_acs dispose
  def dispose
    dispose_acs
    @random_add_animations.each {|s| s.dispose unless s.dispoed?}
  end
  #--------------------------------------------------------------------------
  # アニメーションの開始
  #--------------------------------------------------------------------------
  alias start_animation_acs start_animation
  def start_animation(animation, mirror = false)
    
    #反転アニメ情報とスプライトの位置判定の値が同じ場合は、反転判定を逆転させる。
    
    mirror = mirror ? false : true if self.is_a?(Sprite_Battler) && $game_temp.lr_rev_a && $game_temp.lr_rev_a == lr_rev_type
    
    #透過度無効化設定判定を行う。
    #全体の設定と個別の設定から、最終的な透過度設定を判断する。
    
    if animation
    
      @trans_void = STAR_ANIME_ENH::TRANS_ANIME ? !animation.trans_void : animation.trans_void
      
    end
    
    #本来の処理を実行する。
    
    start_animation_acs(animation, mirror)
    
    #アニメーションの個別速度設定が存在する場合はそちらを優先する。
    #存在しない場合はスクリプトで設定された新たなデフォルト速度を用いる。
    
    if animation
      
      @ani_rate = animation.true_anime_rate != 0 ? animation.true_anime_rate : STAR_ANIME_ENH::ANIME_SPEED
      @ani_duration = @animation.frame_max * @ani_rate + 1
      
    end
  end
  #--------------------------------------------------------------------------
  # アニメーションの更新
  #--------------------------------------------------------------------------
  alias update_animation_random_add_animation update_animation
  def update_animation
    update_random_add_animation
    @anti_animation_continue_by_random_add_animation = true
    update_animation_random_add_animation
    @anti_animation_continue_by_random_add_animation = false
  end
  #--------------------------------------------------------------------------
  # ランダム追加アニメーションの更新
  #--------------------------------------------------------------------------
  def update_random_add_animation
    @random_add_animations.each {|s| s.update unless s.disposed?}
    @random_add_animations.delete_if {|s| s.disposed?}
  end
  #--------------------------------------------------------------------------
  # アニメーション用ビットマップの設定
  #--------------------------------------------------------------------------
  alias load_animation_bitmap_anibitmap_back load_animation_bitmap
  def load_animation_bitmap
    
    #本来の処理を実行。
    
    load_animation_bitmap_anibitmap_back
    
    #アニメーション1及び2の後方表示化フラグをアニメーションデータから取得します。
    
    @anibitmap1_back = @animation.animation_1_back_flag
    @anibitmap2_back = @animation.animation_2_back_flag
    
  end
  #--------------------------------------------------------------------------
  # スプライトの生成直後に設定に応じてビューポート指定の変更
  #--------------------------------------------------------------------------
  alias make_animation_sprites_avnil make_animation_sprites
  def make_animation_sprites
    
    #本来の処理を実行。
    
    make_animation_sprites_avnil
    
    #アニメスプライトが
    
    @ani_sprites.each {|ans| ans.viewport = nil} if @animation.avnil && !@ani_sprites.empty?
  end
  #--------------------------------------------------------------------------
  # スプライトの位置判定
  #--------------------------------------------------------------------------
  def lr_rev_type
    
    #左寄りの場合は0、右寄りの場合は1、中央の場合は2を返す。
    
    return 2 if self.x == Graphics.width / 2
    self.x < (Graphics.width / 2) ? 0 : 1
  end
  #--------------------------------------------------------------------------
  # アニメーションの原点設定
  #--------------------------------------------------------------------------
  alias set_animation_origin_acs set_animation_origin
  def set_animation_origin
    
    #本来の処理を実行する。
    
    set_animation_origin_acs
    
    #X座標及びY座標を調整する。
    
    @ani_ox += @animation.xy_axis_control[0]
    @ani_oy += @animation.xy_axis_control[1]
  end
  #--------------------------------------------------------------------------
  # アニメーションスプライトの設定
  #（一部、aliasで処理し難いのでやむなくオーバーライド）
  #--------------------------------------------------------------------------
  alias animation_set_sprites_acs animation_set_sprites
  def animation_set_sprites(frame)
    if @animation
      a = @animation.random_add_animation[frame.frame_index + 1]
      (a.inject([]) {|r,i| r.push(STAR_ANIME_ENH::A[i])}).each {|v|
      next unless v
      v[:t].times {
      next unless v[:r] > rand(100)
      ad = $data_animations[v[:a]]
      next unless ad
      s = Sprite_RandomAddAnimation.new(self,
      @ani_sprites[0] ? @ani_sprites[0].viewport : self.viewport,
      @screen_animation_targets)
      s.x = @ani_ox + v[:bx] + rand(v[:rx] + 1) * (rand(2) == 0 ? 1 : -1)
      s.y = @ani_oy + v[:by] + rand(v[:ry] + 1) * (rand(2) == 0 ? 1 : -1)
      @random_add_animations.push(s)
      @random_add_animations[-1].start_animation(ad)
      @random_add_animations[-1].update}} if a
    end
    cell_data = frame.cell_data
    temp_opacity = self.opacity
    self.opacity = 255 if @trans_void
    animation_set_sprites_acs(frame)
    self.opacity = temp_opacity
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if pattern
        if (@anibitmap1_back && pattern <= 99) or 
          (@anibitmap2_back && pattern > 99)
          sprite.z = self.z - 16 + i
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # SE とフラッシュのタイミング処理
  #--------------------------------------------------------------------------
  alias animation_process_timing_acs animation_process_timing
  def animation_process_timing(timing)
    
    #タイミングにシェイクが含まれている場合
    
    if timing.shake != nil
      
      #マップの場合と戦闘の場合で対象を変える。
      
      if SceneManager.scene_is?(Scene_Map)
        s = $game_map.screen
      elsif SceneManager.scene_is?(Scene_Battle)
        s = $game_troop.screen
      end
      
      #マップでも戦闘でもない場合は処理を飛ばす。
      #そのどちらかの場合は対象のスクリーンをシェイクさせて
      #残りの処理を飛ばす。
      
      if s != nil
        sd = timing.shake
        return s.start_shake(sd[0], sd[1], sd[2] * @ani_rate)
      end
      
    end
    
    #タイミングに背景フラッシュが含まれている場合
    
    if timing.back_flash
      
      #戦闘中でない場合は処理を飛ばす。
      
      return unless SceneManager.scene_is?(Scene_Battle)
      
      #背景フラッシュフラグを設定して、残りの処理を飛ばす。
      
      return $game_temp.parallax_flash = [timing.flash_color, timing.flash_duration * @ani_rate]
      
    end
    
    #元の処理を実行する。
    
    animation_process_timing_acs(timing)
  end
  #--------------------------------------------------------------------------
  # アニメーション中か
  #--------------------------------------------------------------------------
  alias animation_random_add_animation? animation?
  def animation?
    animation_random_add_animation? or
    (@anti_animation_continue_by_random_add_animation ? false : !@random_add_animations.empty?)
  end
end
class Sprite_RandomAddAnimation < Sprite_Base
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(parent,viewport,screen_animation_targets)
    @parent = parent
    @screen_animation_targets = screen_animation_targets
    super(viewport)
  end
  #--------------------------------------------------------------------------
  # 更新
  #--------------------------------------------------------------------------
  def update
    super
    dispose unless animation?
  end
  #--------------------------------------------------------------------------
  # SE とフラッシュのタイミング処理
  #--------------------------------------------------------------------------
  def animation_process_timing(timing)
    if @screen_animation_targets
      SceneManager.scene.get_scree_animation_targets(@screen_animation_targets).each {|s|
      s.animation_process_timing(timing)}
    else
      @parent.animation_process_timing(timing)
    end
  end
end
class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # 通常アニメーションの表示
  #--------------------------------------------------------------------------
  alias show_normal_animation_random_add_animation show_normal_animation
  def show_normal_animation(targets, animation_id, mirror = false)
    animation = $data_animations[animation_id]
    if animation
      t = targets[0]
      if t
        t = t.actor? ? t : targets.reverse.find {|t| !t.actor?}
        if animation.to_screen?
          t.screen_animation_targets = targets
        else
          t.screen_animation_targets = nil
        end
      end
    end
    show_normal_animation_random_add_animation(targets, animation_id, mirror)
  end
  #--------------------------------------------------------------------------
  # バトラースプライトの取得
  #--------------------------------------------------------------------------
  def get_scree_animation_targets(targets)
    @spriteset.get_scree_animation_targets(targets)
  end
  #--------------------------------------------------------------------------
  # フレーム更新
  #--------------------------------------------------------------------------
  alias update_basic_acs update_basic
  def update_basic
    
    #元の処理を実行する。
    
    update_basic_acs
    
    #背景フラッシュフラグが存在する場合は背景フラッシュを実行する。
    
    @spriteset.parallax_flash($game_temp.parallax_flash[0], $game_temp.parallax_flash[1]) if $game_temp.parallax_flash != nil
  end
  #--------------------------------------------------------------------------
  # アイテム/スキルの使用
  #--------------------------------------------------------------------------
  alias use_item_lr_rev_a use_item
  def use_item
    
    #一時情報として、アイテムの反転情報を保存する。
    
    $game_temp.lr_rev_a = @subject.current_action.item.lr_rev_a
    
    #本来の処理を実行する。
    
    use_item_lr_rev_a
    
    #アイテムの反転情報を破棄する。
    
    $game_temp.lr_rev_a = nil
  end
end
class Spriteset_Battle
  #--------------------------------------------------------------------------
  # バトラースプライトの取得
  #--------------------------------------------------------------------------
  def get_scree_animation_targets(targets)
    r = (@enemy_sprites + @actor_sprites).select {|s| targets.include?(s.battler)}
  end
  #--------------------------------------------------------------------------
  # 背景フラッシュの実行
  #--------------------------------------------------------------------------
  def parallax_flash(color, duration)
    
    #背景の壁と床それぞれにフラッシュを設定する。
    
    @back1_sprite.flash(color, duration)
    @back2_sprite.flash(color, duration)
    
    #フラッシュのフラグを消去する。
    
    $game_temp.parallax_flash = nil
  end
end
class RPG::UsableItem
  #--------------------------------------------------------------------------
  # 反転アニメ情報
  #--------------------------------------------------------------------------
  def lr_rev_a
    @lr_rev_a ||= create_lr_rev_a
  end
  #--------------------------------------------------------------------------
  # 反転アニメ情報作成
  #--------------------------------------------------------------------------
  def create_lr_rev_a
    if /<#{STAR_ANIME_ENH::WORD1}>/ =~ note
      @lr_rev_a = 1
    elsif /<#{STAR_ANIME_ENH::WORD2}>/ =~ note
      @lr_rev_a = 0
    else
      @lr_rev_a = -1
    end
  end
end
class RPG::Animation
  attr_accessor :random_add_animation
  #--------------------------------------------------------------------------
  # フレーム配列
  #--------------------------------------------------------------------------
  unless method_defined?(:frames_random_add_animation)
  alias frames_random_add_animation frames
  def frames
    frames_add_index unless @frames_add_index_flag
    frames_random_add_animation
  end
  end
  #--------------------------------------------------------------------------
  # フレームにインデックスを指定
  #--------------------------------------------------------------------------
  def frames_add_index
    @frames.each_with_index {|f,i| f.frame_index = i if f}
    @frames_add_index_flag = true
  end
  #--------------------------------------------------------------------------
  # ランダム追加アニメーション
  #--------------------------------------------------------------------------
  def random_add_animation
    @random_add_animation ||= create_random_add_animation
  end
  #--------------------------------------------------------------------------
  # ランダム追加アニメーションデータ作成
  #--------------------------------------------------------------------------
  def create_random_add_animation
    h = STAR_ANIME_ENH::T[/<#{STAR_ANIME_ENH::WORD9}[:：](\d+)>/ =~ name ? $1.to_i : -1]
    h ? h : {}
  end
  #--------------------------------------------------------------------------
  # 個別アニメーション速度
  #--------------------------------------------------------------------------
  def true_anime_rate
    @true_anime_rate ||= /<#{STAR_ANIME_ENH::WORD3}[：:](\S+)>/ =~ name ? $1.to_i : 0
  end
  #--------------------------------------------------------------------------
  # アニメーション1の後方表示フラグ
  #--------------------------------------------------------------------------
  def animation_1_back_flag
    (@abf1 ||= name.include?(STAR_ANIME_ENH::WORD4) ? 1 : 0) == 1
  end
  #--------------------------------------------------------------------------
  # アニメーション2の後方表示フラグ
  #--------------------------------------------------------------------------
  def animation_2_back_flag
    (@abf2 ||= name.include?(STAR_ANIME_ENH::WORD5) ? 1 : 0) == 1
  end
  #--------------------------------------------------------------------------
  # 個別透過度設定無視フラグ
  #--------------------------------------------------------------------------
  def trans_void
    (@trans_void ||= /<#{STAR_ANIME_ENH::WORD6}>/ =~ name ? 1 : 0) == 1
  end
  #--------------------------------------------------------------------------
  # 個別座標調整
  #--------------------------------------------------------------------------
  def xy_axis_control
    @xy_axis_control ||= /<#{STAR_ANIME_ENH::WORD7}[：:](\S+),(\S+)>/ =~ name ? [$1.to_i, $2.to_i] : [0, 0]
  end
  #--------------------------------------------------------------------------
  # ビューポートを指定なしにするか否かのフラグを取得
  #--------------------------------------------------------------------------
  def avnil
    (@avnil ||= name.include?(STAR_ANIME_ENH::WORD8) ? 1 : 0) == 1
  end
end
class RPG::Animation::Frame
  attr_accessor :frame_index
end
class RPG::Animation::Timing
  #--------------------------------------------------------------------------
  # シェイクデータを取得
  #--------------------------------------------------------------------------
  def shake
    if @se.name != '' && @se.name == 'shake'
      return [@flash_color.red, @flash_color.green, @flash_color.blue]
    else
      return nil
    end
  end
  #--------------------------------------------------------------------------
  # 背景フラッシュデータを取得
  #--------------------------------------------------------------------------
  def back_flash
    @se.name != '' && @se.name == 'back_flash'
  end
end
#--------------------------------------------------------------------------
# 表示位置:画面のアニメーションをフラッシュを維持させつつ軽量化する作業
#--------------------------------------------------------------------------
if STAR_ANIME_ENH::SCREEN_ONCE
class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # アニメーションの解放
  #--------------------------------------------------------------------------
  alias dispose_animation_acs dispose_animation
  def dispose_animation
    dispose_animation_acs
    game_temp_a_to_s_delete
  end
  #--------------------------------------------------------------------------
  # 画面対象アニメの判定を消去
  #--------------------------------------------------------------------------
  def game_temp_a_to_s_delete
  end
end
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # 画面対象アニメの判定を消去
  #--------------------------------------------------------------------------
  def game_temp_a_to_s_delete
    @@animation_to_screen ||= []
    @@animation_to_screen = [] if @@animation_to_screen && @@animation_to_screen[1] != Graphics.frame_count
  end
  #--------------------------------------------------------------------------
  # 新しいアニメーションの設定
  # (一部分がaliasでは処理し難い為オーバーライド)
  #--------------------------------------------------------------------------
  alias setup_new_animation_acs setup_new_animation
  def setup_new_animation
    aid = @battler.animation_id
    gfc = Graphics.frame_count
    if aid > 0
      cloned_animation = nil
      @@animation_to_screen ||= []
      if @@animation_to_screen[0] == aid && @@animation_to_screen[1] == gfc
        @@data_dummy_screen_animations ||= {}
        if !@@data_dummy_screen_animations[aid]
          animation = $data_animations[aid].clone
          animation.random_add_animation = {}
          animation.frames = []
          animation.frame_max.times {animation.frames.push(RPG::Animation::Frame.new)}
          animation.frames_add_index
          timings = []
          animation.timings.each {|t1| 
          t2 = RPG::Animation::Timing.new
          t2.frame = t1.frame
          if t1.flash_scope != 2
            t2.se = t1.se if STAR_ANIME_ENH::ANTIONCE_SE.include?(t1.se.name)
            t2.flash_scope = t1.flash_scope
            t2.flash_color = t1.flash_color
            t2.flash_duration = t1.flash_duration
          end
          timings.push(t2)}
          animation.timings = timings
          @@data_dummy_screen_animations[aid] = animation
        end
        cloned_animation = $data_animations[aid]
        $data_animations[aid] = @@data_dummy_screen_animations[aid]
      end
    end
    setup_new_animation_acs
    if aid > 0
      $data_animations[aid] = cloned_animation if cloned_animation
      @@animation_to_screen = $data_animations[aid].to_screen? ? [aid,gfc] : nil
    end
  end
end
end
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # 新しいアニメーションの設定
  #--------------------------------------------------------------------------
  alias setup_new_animation_random_add_animation setup_new_animation
  def setup_new_animation
    if @battler && @battler.animation_id > 0
      @screen_animation_targets = @battler.screen_animation_targets
      @battler.screen_animation_targets = nil
    end
    setup_new_animation_random_add_animation
  end
end