#==============================================================================
# ■ RGSS3 XPスタイルバトル Ver 2.76a by コミュ太郎（@hennatokoro）
#------------------------------------------------------------------------------
#   アクターのバトラー画像を画面下側に表示し、エネミーの行動で
# アニメーションを表示します。
#   それに伴い、ステータスウィンドウやコマンドウィンドウのレイアウトや
# 配置を一新します。
#   度重なる改良で結構マシになったダメージポップアップも実装されています。
#   作者の趣味で、純粋に戦闘スタイルをXPっぽくしたいだけの人には絶対に不要な
# 機能まで実装されてます。ごめんね。無効化可能だから許して。
#
#   アクター用バトラーグラフィックは「Graphics/Battlers」フォルダに
# 「<filename>-<index>」という名前で用意してください。
#   画像のサイズは、基本的にどれだけ大きくても処理の上では問題ありませんが、
# 基本的には横128px〜154px前後、縦160px前後を推奨します。
# <filename>は「アクターに用いる顔グラフィックのファイル名」
# <index>は「顔グラフィックのインデックス（左上が1）」
# に置換してください。
#   ゲーム中に変更する場合は、イベントコマンド『スクリプト』で
# $game_actors[n].battler_name = "ファイル名"
# とすることで、n番目のアクターのバトラーグラフィックを変更できます。
#   ついでに、
# $game_actors[n].battler_hue = 0以上360未満の値
# を実行することで、バトラーグラフィックの色相を変化させることもできます。
#   一応、顔グラフィック変更時にバトラーグラフィックも変更する設定も可能です。
#
#   エネミーの通常攻撃アニメーションは、エネミーのメモ欄に
# <ani_id:x>の形式で指定してください。
#   省略した場合、1番目のアニメーションを使用します。
#
#   メモ欄に
# <HP表示>〜</HP表示><MP表示>〜</MP表示><TP表示>〜</TP表示>
# と表記されていて、〜部分の式が真となるエネミー及び
# メモ欄に式が指定されておらず、デフォルトで設定した式が真となるエネミーは
# 選択中にゲージが表示されます。
#   各種数値も表示したい場合は、同様に
# <HP数値表示>〜</HP数値表示><MP数値表示>〜</MP数値表示>
# <TP数値表示>〜</TP数値表示>
# で指定してください。（こちらもデフォルト式設定可能）
#   更に、Xボタン（変更可能）を押すことで、他の表示可能なゲージに
# 表示を切り替えます。
#   例1：モンスター図鑑系のスクリプト素材を導入している場合、該当エネミーを
# 倒したことがある場合はゲージのみ表示、一定数以上倒していれば
# 数値も表示といった設定も可能です。
#   例2：ボスエネミーなど、HPを表示したくないエネミーは、メモ欄に
# <HP表示>false</HP表示>と表記してください。
#
#   ステートのメモ欄に<ani_id:x>と記述すると、そのステートが付与されたバトラーに
# n番目のアニメーションを表示します。
#   複数のアニメーションが付与されている場合は、優先度順にアニメーションを
# 表示します。
#   また、ステートのメモ欄に<Add:Name>と入力すると、ステートを付与された時に、
# <Remove:Name>と入力すると、ステートが解除された時に、
# それぞれ「Name」をポップアップします。
#   また、それぞれ
# <Add:Name, :Color>
# <Remove:Name, :Color>
# というように記述すると、識別子:Colorで表される色でポップアップさせます。
#   例：<Add:Accel, :critical>
# 付与時にAccelという文字列を:criticalで表される色でポップアップ
# （省略時は、付与時に:stateが、解除時に:healが指定されます）
#   さらに、
# <AddforActor:Name, :Color>
# <RemoveforEnemy:Name>
# のように記述することで、それぞれアクター/エネミーに応じて異なるポップアップを
# 使うことが可能です。
#   設定項目に応じて、バフ/デバフ時もポップアップします。
#
#   スキル使用時に使用者側に表示するアニメーションは、スキル/アイテムのメモ欄に
# <ani_id:x>の形式で指定してください。
#   省略した場合、設定項目で設定したアニメーションを使用します。
#
#   また、メモ欄に<名前非表示>と記述されていないスキル・アイテムは
# 使用時に画面上部に名前を表示します。設定で無効化可能です。
#
#   このスクリプトは、描画領域の関係上、画面サイズを640*480にする前提で
# 設計されています。
#   （544*416でも問題なく表示されますが、若干窮屈かもしれません）
#   そのため、WHITE-FLUTE様（http://www.whiteflute.org/wfrgss/）の
# 『VGA-Size VGAサイズスクリプト (VXAce版)』を導入した上でのご使用を推奨します。
#   （38行目をコメントアウトすれば、単体でも動作するようです）
#   その際、導入位置は当スクリプトより下にしてください。
#   また、導入する際に、スクリプト内の『 * self.opacity / 255.0』
# の部分を削除しないと、戦闘不能者にアニメーションが表示されません。
#
#   また、Integerクラスに次のメソッドが追加されます。
#   separate(digits = 3, chr = ',') -> String
#   self の末尾から digits で指定した桁数ごとに chr で区切った文字列を返します。
#   例:
#   p 6464641000029.separate   #=> "6,464,641,000,029"
#   p 8181877.separate(4, '_') #=> "818_1877"
#
#   再定義がメチャクチャ多いので、なるべく上の方（VXAce_SP1直下くらい）
# に設置したほうがいいかも。
#==============================================================================
#__END__
$imported ||= {}
$imported[:cs_xp_style] = true
# 設定項目ここから（かなり長いので注意！）

module Comtaro
  def self.message_pos
    # 戦闘中のメッセージウィンドウの位置
    # 戦闘開始時/逃走時/勝利時（静的バトルリザルト未実装時）/敗北時/イベント時の
    # メッセージウィンドウの位置を指定します。
    # 0：上
    # 1：中
    # 2：下（デフォルト）
    return 2
  end
  def self.unclose_status_event
    # イベント時にステータスを非表示にしない
    # message_posが2の時はfalse推奨
    return false
  end
  def self.actor_background
    # アクター表示の背景
    # 0：無し
    # 1：暗くする
    # 2：ウィンドウ
    # 3：ウィンドウ+ステータスを若干上方にシフト
    return 0
  end
  def self.battle_system_message
    # 戦闘開始・逃走・敗北時のメッセージを表示する
    # falseの場合、ポップアップで先制攻撃・不意討ち・逃走失敗を表示します。
    return false
  end
  def self.escape_get_exp
    # 逃走時、そこまでに倒した敵の経験値・Gold・アイテムは獲得する
    # 内部的には勝利扱いになります。
    return true
  end
  def self.force_set_position
    # イベント中のメッセージを強制的にmessage_posにセットする
    # falseの場合、イベントコマンドで設定した表示位置に設定されます。
    return true
  end
  def self.battler_pos
    # バトラーの表示基準位置
    # 0 ：左端
    # 1 ：中央
    # 2 ：右端
    # 2の場合、右から順番にアクターが表示されます。
    return 0
  end
  def self.command_window_pos
    # アクターコマンドウィンドウのy座標
    # バトラーグラフィックに合わせる場合は nil
    return nil
  end
  def self.use_damage_face
    # 被ダメージ時表情差分を使用する
    # 利用する際は、バトラーグラフィックファイル名末尾に『_d』を付与したものを
    # 用意してください。
    # なお、用意されていない場合は画像が変化しません。
    # + 1：HPダメージ
    # + 2：MPダメージ
    # + 4：TPダメージ
    # + 8：バッドステート付与 & 能力低下
    # +16：HPスリップダメージ
    # +32：MPスリップダメージ
    # +64：TPスリップダメージ
    # ここでいうバッドステートとは、メモ欄に<プラスステート>と記述されていない
    # ステートのことを指します。
    # この機能を使用しない場合は、nilを指定してください。
    return 0b0111011 # デフォルトでは『HP・MPダメージ(スリップ含)+バッドステート』
  end
  def self.use_victory_face
    # 勝利時表情差分を使用する
    # 利用する際は、バトラーグラフィックファイル名末尾に『_v』を付与したものを
    # 用意してください。
    # なお、用意されていない場合は画像が変化しません。
    return true
  end
  def self.use_popup
    # ポップアップを使用する
    return true
  end
  def self.actor_screen_ani_y_ext
    # アクター側に画面全体に表示するアニメーションを行う際のy座標補正値
    # ここで設定した値だけ下方向にずらします。（単位：ピクセル）
    # ずらしたくない場合は、アニメーション名の先頭に『*』を付けてください。
    return 0
  end
  def self.blink_battler
    # 被ダメージ時、バトラーを点滅させる
    return true
  end
  def self.play_damage_se
    # 被ダメージ・ミス・回避・反撃・反射時にSEを鳴らす
    return true
  end
  def self.wait_for_dead?
    # コラプスエフェクト中に待機する
    # falseの場合、敵が全滅した瞬間にリザルトに移行するうえに、
    # 味方が全滅した瞬間にゲームオーバーになるので注意してください。
    # その代わり、↓の設定とともにfalseにすると戦闘が非常にスムーズに進みます。
    return false
  end
  def self.popup_wait
    # 行動やコマンド選択をポップアップが消えるまで待つ
    return true
  end
  def self.battlelog_wait
    # 行動をバトルログが消えるまで待つ
    return true
  end
  def self.use_battlelog
    # バトルログを使用する
    # ポップアップと同時に有効にすると、戦闘の進行が若干もたつきます。
    # 各種ウェイト関連の設定項目を調整して、適切な戦闘テンポに調整してください。
    return true
  end
  def self.log_time
    # バトルログ表示時間（単位：フレーム）
    # 8以上の値を設定してください。
    return 180 - $game_variables[91]
  end
  def self.default_battlelog
    # デフォルトのバトルログを使用する
    # 当スクリプトの性質上、基本的にサポート対象外の機能です。
    # どうしても従来のバトルログが必要な場合のみ、有効にしてください。
    # なお、use_battlelogが無効の場合、この設定項目は意味を持ちません。
    return false
  end
  def self.wait_log_for_popup
    # ログのクリアをポップアップ消滅まで待機する
    return true
  end
  def self.popup_font_int
    # ポップアップのフォント等の設定・数値編
    # 次のように設定してください。
    # :name   →フォント名（複数指定可）
    # :size   →サイズ（単位：ポイント）
    # :bold   →太字（しない場合はnil,する場合は数値（単位：ピクセル）を）
    # :italic →斜体（しない場合はnil,する場合は数値（単位：ピクセル）を）
    # :shadow →影付き
    # :outline→縁取り（しない場合はnil,する場合は数値（単位：ピクセル）を）
    # :space  →文字の間隔（単位：ピクセル）（負数指定可能）
    # :speed  →ポップアップ速度（単位：フレーム）
    # :height →跳ね上がる高さ（単位：ピクセル）
    # :lag    →次の文字を表示するまでの時間（単位：フレーム）
    # :time   →最後の文字が着地してから消滅するまでの時間（単位：フレーム）
    # :bounds →バウンド回数
    # :atten  →バウンド時の減衰
    # :reverse→右側からポップアップするかどうか
    # :spaceと:atten以外で数値を指定する項目は必ず0以上の整数で指定してください。
    # bold, italic, outlineに入れる数値は、各項目を有効にする際に
    # 文字が潰れないように文字の周囲に空ける空白です。
    # これにより、文字が必要以上に離れることはありませんが、
    # もし文字が重なって、それが好ましくない場合は、
    # spaceの項目で調整してください。
    return {
    :name    => ["Cambria", "Arial Black", "VL Gothic"],
    :size    => 32,
    :bold    => nil,
    :italic  => 8,
    :shadow  => true,
    :outline => 2,
    :space   => -1,
    :speed   => 16,
    :height  => 24,
    :lag     => 3,
    :time    => 8,
    :bounds  => 1,
    :atten   => 3.0,
    :reverse => true,
    }
  end
  def self.popup_font_str
    # ポップアップのフォント等の設定・文字列編
    # 設定方法は数値の場合と同じです。
    return {
    :name    => ["Cambria", "Arial Black", "VL Gothic"],
    :size    => 32,
    :bold    => nil,
    :italic  => 8,
    :shadow  => true,
    :outline => 2,
    :space   => -1,
    :speed   => 16,
    :height  => 24,
    :lag     => 0,
    :time    => 8,
    :bounds  => 1,
    :atten   => 3.0,
    :reverse => false,
    }
  end
  def self.popup_separate
    # 数値ポップアップに桁区切りを適用する（区切り文字もバウンドします）
    return false
  end
  def self.popup_color
    # 各種ポップアップの文字色
    # :normal   →通常
    # :mp_damage→MPダメージ
    # :tp_damage→TPダメージ
    # :heal     →回復・ステート解除・バフ付与
    # :mp_heal  →MP回復
    # :tp_heal  →TP回復
    # :critical →クリティカル
    # :e_weak   →属性弱点
    # :e_str    →属性耐性
    # :state    →ステート付与・デバフ付与
    # :surprise →不意討ち
    # :overkill →オーバーキル
    # 他のシンボルで指定すると、そちらを参照します。
    # スクリプトを書き換えられるなら、他に追加することも可能です。
    # ステート付与/解除時の色を3種類以上使いたい場合も、ここで追加してください。
    return {
            :normal    => Color.new(255, 255, 255),
            :mp_damage => :normal,
            :tp_damage => :normal,
            :heal      => Color.new(128, 255, 192),
            :mp_heal   => :heal,
            :tp_heal   => :heal,
            :critical  => Color.new(255, 224, 128),
            :e_weak    => :critical,
            :e_str     => :normal,
            :state     => Color.new(255, 128, 224),
            :surprise  => :critical,
            :overkill  => :critical,
           }
  end
  def self.popup_outline
    # 各種ポップアップの縁取り色
    # 文字色と同様に設定します。
    # 必ず、文字色と同じだけ設定してください。
    return {
            :normal    => Color.new(0, 0, 0, 128),
            :mp_damage => :normal,
            :tp_damage => :normal,
            :heal      => Color.new(32, 64, 48, 128),
            :mp_heal   => :heal,
            :tp_heal   => :heal,
            :critical  => Color.new(64, 56, 32, 128),
            :e_weak    => :critical,
            :e_str     => :normal,
            :state     => Color.new(64, 32, 56, 128),
            :surprise  => :critical,
            :overkill  => :critical,
           }
  end
  def self.popup_pattern
    # ポップアップの数字パターン
    # この文字列を書き換えることで、全角数字とか漢数字とかに
    # 置き換えることが可能です。
    # また、要素数10の配列を作成して、各要素を文字列にすると、１桁あたりを
    # 複数文字に置き換えることもできます。（いらない）
    #return "〇一二三四五六七八九"
    #return "０１２３４５６７８９"
    return "0123456789"
  end
  # 各種ポップアップ（もし文法とか誤用とかあったら無言で直してネ）
  def self.surprise_popup
    # 不意
    return "!"
  end
  def self.miss_popup
    # ミス
    return "Miss"
  end
  def self.evade_popup
    # 回避
    return "Evaded"
  end
  def self.fail_popup
    # 失敗
    return "Failed"
  end
  def self.refrect_popup
    # 反射
    return ""
  end
  def self.counter_popup
    # 反撃
    return ""
  end
  def self.substitute_popup
    # 身代わり
    return ""
  end
  def self.overkill_popup
    # オーバーキル
    return "Over Kill!"
  end

  def self.param_popup
    # 各種パラメータ（バフ/デバフ用）
    # 下で設定しているバフ/デバフ/解除が後ろに付加されます。
    # nil でそのパラメータはポップアップしません。
    return ["End", "Mid", "Stm", "Grd", "Chr", "Tec", "Agi", "Luk"]
  end
  def self.buff_popup
    # バフ
    return " Up"
  end
  def self.debuff_popup
    # デバフ
    return " Down"
  end
  def self.dispel_popup
    # 解除
    return " Clear"
  end
  def self.slip_popup
    # HP・MP・TP再生による回復・ダメージもポップアップする
    return true
  end
  def self.s_anime_cont
    # ターン実行中にステートアニメーションを続ける
    # trueの場合、若干重くなる場合があります。
    # falseの場合、ターン開始時にアニメーションを止めます。
    return true
  end
  def self.refresh_state
    # ステートが解除された際にアニメーションを一旦止める
    # 止めた瞬間、次のアニメーションが再生されるため、少なくとも
    # 解除されたステートのアニメーションは収まります。
    # …のはずなのですが、アイテムやスキルで解除すると、仕様上
    # アニメーションが1つは再生されてしまいます。^^;
    return true
  end
  def self.blink_cycle
    # 明滅の周期（単位：フレーム）
    # 必ず偶数で設定してください。
    return 64
  end
  def self.blink_tone
    # 明滅色調(R, G, B, Gray)
    # R, G, Bはそれぞれ-255〜255の実数で、Grayは0〜255の実数で設定
    # 色調である関係上、R, G, Bは絶対値を大きな値に設定してください。
    # (255, 0, 0とかだと明滅がわかりにくくなります)
    # 処理に時間がかかる場合があるため、Grayは0にすることを強く推奨します。
    return Tone.new(255, 255, 255, 0)
  end
  def self.select_brightness
    # 選択中のバトラーの明滅の眩しさ
    # 指定できる値の範囲は、
    # |select_brightness * (blink_toneの要素の最大値) / 255| * blink_cycle <= 255
    # が成立する値です。
    # また、
    # 128 <= |select_brightness * (blink_tone最大値) / 255| * blink_cycle <= 192
    # が成立する範囲で設定することを推奨します。
    # ただし、|a|はaの絶対値とします。
    # 例：blink_cycleが64の場合、±0〜3.984375の範囲で指定。±2〜3を推奨。
    return 2.25
  end
  def self.min_gauge
    # 敵ゲージ長の最低保証（この値未満の長さにはなりません）（単位：ピクセル）
    return 112
  end
  def self.state_limit
    # バトラー名表示ウィンドウにおけるステート表示数（横）の上限
    # 表示しきれない分は次の行に回されます。
    # ステートを表示しない場合は nil を指定してください。
    return 5
  end
  def self.state_line_limit
    # バトラー名表示ウィンドウにおけるステート表示行数の上限
    # これでも表示しきれない分は流石に表示されません。
    return 2
  end
  def self.gauge_input
    # ゲージを切り替えるボタン
    return :X
  end
  def self.battler_info_speed
    # バトラー名表示ウィンドウの移動速度
    # 1以上の値で瞬間移動、1未満で数字が小さいほどゆっくり移動
    # 0に設定すると、アクターかエネミーかで位置を完全に固定します。
    # 0以上の値を指定してください。
    return Rational('4/7') # 分数で指定
  end
  def self.item_name_visible?
    # スキル・アイテム使用時に画面上部に名前を表示する
    # この設定が有効な場合、名称が表示されるスキル・アイテム使用時は
    # バトルログ上で使用メッセージが表示されません。
    return true
  end
  def self.view_select_target
    # ターゲット選択中、使用するスキル・アイテムを表示する
    # メモ欄に<名前非表示>を含むスキル・アイテムの場合、表示されません
    return true
  end
  def self.help_width
    # アイテム・スキル名表示ウィンドウの横幅（単位：ピクセル）
    return 312
  end
  def self.help_time
    # アニメーション未設定時のアイテム・スキル名表示時間（単位：フレーム）
    # A・Cボタンいずれかを押しっぱなしにしている場合は半減することを考慮した上で
    # 設定してください。
    return 20
  end
  def self.tp_width
    # TPゲージの長さ（単位：ピクセル）
    # 描画処理の都合上、実際は指定した値より4px短くなります。
    return 60
  end
  def self.draw_actor_name_for_xp
    # ステータス領域にアクターの名前を表示する
    return false
  end
  def self.battler_auto_change
    # 顔グラフィック変更時、バトラーグラフィックも自動で変更するか
    return true
  end
  def self.skill_animation
    # スキルタイプごとのデフォルトのアニメーションIDの配列
    
    # スキルのIDを<ani_id:x>で指定しなかった場合に用いるアニメーションのIDです。
    # 必ず、スキルタイプの数+1個だけ設定してください。
    # 先頭を0番目として、配列のn番目にはスキルタイプn番のアニメーションID
    # を設定してください。
    # なお、0番目にはアイテム使用時のアニメーションIDを設定します。
    # スキルタイプが「なし」に設定されていても0番目のアニメーションが
    # 表示されるため、必要に応じて個別に設定することをおすすめします。
    # いずれも、表示したくない場合は0を指定しましょう。
    return [0, 81, 81]
  end
  def self.reflect_anime_id
    # 魔法反射時に反射した側に表示するアニメーションID
    # nilにした場合、ポップアップを表示します。
    # アニメーションを表示する場合、魔法反射の効果音を
    # (なし)にすることを推奨します。
    return 119
  end
  def self.overkill_rate
    # オーバーキル判定倍率
    # この値がnのとき、最大HPのn倍のダメージを与えた時にオーバーキル判定します。
    # nilを指定することで、オーバーキルを無効化できます。
    return 1
  end
  def self.overkill_message
    # オーバーキル時のログメッセージ
    # nil で表示しない
    return nil
  end
end
class Game_Battler < Game_BattlerBase
  def overkill_bonus(target)
    # オーバーキル時に攻撃側に行う処理(targetは倒された側のバトラー)
    # RGSS3弄れる人は弄ってみて下さい。
    # SceneManager.scene.log_window.add_text(str)：文字列strをバトルログに表示
    # デフォルトだとTPを3回復します。
    self.tp += 3
    SceneManager.scene.refresh_status
    fmt = self.actor? ? Vocab::ActorGain : Vocab::EnemyGain
    Sound.play_recovery
    SceneManager.scene.log_window.add_text(sprintf(fmt, self.name, Vocab::tp, 3))
    self.sprite.damage_popup(3, scene_viewport, :tp_heal)
  end
end
class Game_Enemy < Game_Battler
  def default_hp_visible?
    # デフォルトのエネミーHPゲージ表示条件
    # @enemy_id：該当エネミーのID
    return true
  end
  def default_mp_visible?
    # デフォルトのエネミーMPゲージ表示条件
    return self.mmp.nonzero?
  end
  def default_tp_visible?
    # デフォルトのエネミーTPゲージ表示条件
    return $data_system.opt_display_tp
  end
  def default_hp_value_visible?
    # デフォルトのエネミーHP数値表示条件
    # @enemy_id：該当エネミーのID
    return false
  end
  def default_mp_value_visible?
    # デフォルトのエネミーMP数値表示条件
    return false
  end
  def default_tp_value_visible?
    # デフォルトのエネミーTP数値表示条件
    return false
  end
end

# 設定項目ここまで（お疲れ様でした）

#==============================================================================
# ■ NilClass
#------------------------------------------------------------------------------
# 　nil のクラス。 nil は NilClass クラスの唯一のインスタンスです。 nil は
# false オブジェクトとともに偽を表し、 その他の全てのオブジェクトは真です。
#==============================================================================

class NilClass
  def damage_popup(*args)
  end
end

#==============================================================================
# ■ Integer
#------------------------------------------------------------------------------
# 　整数の抽象クラス。サブクラスとして Fixnum と Bignum があります。この 2 種
# 類の整数は値の大きさに応じてお互いに自動的に変換されます。ビット操作において
# 整数は無限の長さのビットストリングとみなすことができます。
#==============================================================================

class Integer < Numeric
  #--------------------------------------------------------------------------
  # ● 桁区切りを適用した文字列を返す
  #--------------------------------------------------------------------------
  def separate(digits = 3, chr = ?,)
    return self.to_s.reverse.gsub(/(\d{#{digits.to_i}})(?=\d)/, '\1' + chr).reverse
  end
end

#==============================================================================
# ■ BattleManager
#------------------------------------------------------------------------------
# 　戦闘の進行を管理するモジュールです。
#==============================================================================

module BattleManager
  def self.phase
    @phase
  end
  def self.victoried
    @victoried
  end
  def self.victoried=(bool)
    @victoried = bool
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始
  #--------------------------------------------------------------------------
  def self.battle_start
    @victoried = false
    $game_system.battle_count += 1
    $game_party.on_battle_start if $BTEST
    $game_troop.on_battle_start
    if Comtaro.battle_system_message
      $game_troop.enemy_names.each do |name|
        $game_message.add(sprintf(Vocab::Emerge, name))
      end
      if @preemptive
        $game_message.add(sprintf(Vocab::Preemptive, $game_party.name))
      elsif @surprise
        $game_message.add(sprintf(Vocab::Surprise, $game_party.name))
      end
      wait_for_message
      SceneManager.scene.instance_variable_get(:@status_window).open
    else
      if @preemptive
        $game_troop.alive_members.each do |battler|
          battler.sprite.damage_popup(Comtaro.surprise_popup, battler.scene_viewport, :surprise)
        end
      elsif @surprise
        $game_party.alive_members.each do |battler|
          battler.sprite.damage_popup(Comtaro.surprise_popup, battler.scene_viewport, :surprise)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘終了
  #     result : 結果（0:勝利 1:逃走 2:敗北）
  #--------------------------------------------------------------------------
  def self.battle_end(result)
    @phase = nil
    @event_proc.call(result) if @event_proc
    $game_party.on_battle_end
    $game_troop.on_battle_end
    SceneManager.exit if $BTEST
  end
  class << self
    alias cs_process_victory process_victory unless $!
  end
  #--------------------------------------------------------------------------
  # ● 勝利の処理
  #--------------------------------------------------------------------------
  def self.process_victory
    $game_party.battle_members.each do |actor|
      ((actor.sprite.bitmap = Cache.battler("#{actor.battler_name}_v", actor.battler_hue ||= 0)) rescue nil) if actor.actor? && Comtaro.use_victory_face
    end
    BattleManager.victoried = true if Comtaro.use_victory_face
    self.cs_process_victory
  end
  #--------------------------------------------------------------------------
  # ● 逃走の処理
  #--------------------------------------------------------------------------
  def self.process_escape
    $game_message.add(sprintf(Vocab::EscapeStart, $game_party.name)) if Comtaro.battle_system_message
    success = @preemptive ? true : (rand < @escape_ratio)
    Sound.play_escape
    if success
      Comtaro.escape_get_exp ? process_victory : process_abort
    else
      @escape_ratio += 0.1
      $game_message.add('\.' + Vocab::EscapeFailure) if Comtaro.battle_system_message
      $game_party.alive_members.each do |battler|
          battler.sprite.damage_popup(Comtaro.fail_popup, battler.scene_viewport) unless Comtaro.battle_system_message
        end
      $game_party.clear_actions
    end
    wait_for_message if Comtaro.battle_system_message
    return success
  end
  #--------------------------------------------------------------------------
  # ● 敗北の処理
  #--------------------------------------------------------------------------
  def self.process_defeat
    $game_message.add(sprintf(Vocab::Defeat, $game_party.name)) if Comtaro.battle_system_message
    wait_for_message if Comtaro.battle_system_message
    if @can_lose
      revive_battle_members
      replay_bgm_and_bgs
      SceneManager.return
    else
      SceneManager.goto(Scene_Gameover)
    end
    battle_end(2)
    return true
  end
end

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　スプライトや行動に関するメソッドを追加したバトラーのクラスです。このクラス
# は Game_Actor クラスと Game_Enemy クラスのスーパークラスとして使用されます。
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● ダメージ計算
  #--------------------------------------------------------------------------
  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    @result.e_rate = item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)
    @result.make_damage(value.to_i, item)
  end
end

#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス（$game_actors）
# の内部で使用され、Game_Party クラス（$game_party）からも参照されます。
#==============================================================================

class Game_Actor < Game_Battler
  attr_accessor :screen_x                 # バトル画面 X 座標
  attr_accessor :screen_y                 # バトル画面 Y 座標
  attr_accessor :sprite                   # 戦闘中のスプライト
  attr_accessor :battler_name             # バトラーグラフィック
  attr_accessor :battler_hue              # バトラー色相
  attr_accessor :scene_viewport
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias cs_initialize initialize unless $!
  def initialize(actor_id)
    cs_initialize(actor_id)
    @battler_name = "#{face_name}-#{face_index + 1}"
    @battler_hue = 0
    @screen_x = 0
    @screen_y = Graphics.height
  end
  #--------------------------------------------------------------------------
  # ● ダメージ効果の実行
  #--------------------------------------------------------------------------
  def perform_damage_effect
    @sprite_effect_type = :blink if Comtaro.blink_battler
    Sound.play_actor_damage if Comtaro.play_damage_se
  end
  #--------------------------------------------------------------------------
  # ● グラフィックの変更
  #--------------------------------------------------------------------------
  alias cs_set_graphic set_graphic unless $!
  def set_graphic(character_name, character_index, face_name, face_index)
    cs_set_graphic(character_name, character_index, face_name, face_index)
    @battler_name = "#{face_name}-#{face_index + 1}" if Comtaro.battler_auto_change
  end
  #--------------------------------------------------------------------------
  # ● コラプス効果の実行
  #--------------------------------------------------------------------------
  def perform_collapse_effect
    case collapse_type
    when 0
      @sprite_effect_type = :collapse
      Sound.play_actor_collapse
    when 1
      @sprite_effect_type = :boss_collapse
      Sound.play_boss_collapse1
    when 2
      @sprite_effect_type = :instant_collapse
    end
  end
  #--------------------------------------------------------------------------
  # ● HP の再生
  #--------------------------------------------------------------------------
  alias cs_regenerate_hp regenerate_hp unless $!
  def regenerate_hp
    cs_regenerate_hp
    return unless Comtaro.slip_popup
    case @result.hp_damage <=> 0
    when 0..1
      color = :normal
    when -1
      color = :heal
    end
    @sprite.damage_popup(@result.hp_damage.abs, @scene_viewport, color, (Comtaro.use_damage_face[4] == 1 && color == :normal)) unless (@result.hp_damage.zero? || !$game_party.in_battle)
  end
  #--------------------------------------------------------------------------
  # ● MP の再生
  #--------------------------------------------------------------------------
  alias cs_regenerate_mp regenerate_mp unless $!
  def regenerate_mp
    cs_regenerate_mp
    return unless Comtaro.slip_popup
    case @result.mp_damage <=> 0
    when 0..1
      color = :mp_damage
    when -1
      color = :mp_heal
    end
    @sprite.damage_popup(@result.mp_damage.abs, @scene_viewport, color, (Comtaro.use_damage_face[5] == 1 && color == :mp_damage)) unless (@result.mp_damage.zero? || !$game_party.in_battle)
  end
  #--------------------------------------------------------------------------
  # ● TP の再生
  #--------------------------------------------------------------------------
  def regenerate_tp
    self.tp += 100 * trg
    return unless Comtaro.slip_popup
    case trg <=> 0
    when -1..0
      color = :tp_damage
    when 1
      color = :tp_heal
    end
    @sprite.damage_popup((100 * trg).to_i.abs, @scene_viewport, color, (Comtaro.use_damage_face[6] == 1 && color == :tp_damage)) unless ((100 * trg).to_i.zero? || !$game_party.in_battle)
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 Z 座標の取得
  #--------------------------------------------------------------------------
  def screen_z
    return 12000
  end
  #--------------------------------------------------------------------------
  # ● スプライトとかをクリア
  #--------------------------------------------------------------------------
  def clear_battle
    remove_instance_variable(:@sprite) rescue nil
    remove_instance_variable(:@scene_viewport) rescue nil
  end
  #--------------------------------------------------------------------------
  # ● スプライトを使うか？
  #--------------------------------------------------------------------------
  def use_sprite?
    return true
  end
end

#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 　敵キャラを扱うクラスです。このクラスは Game_Troop クラス（$game_troop）の
# 内部で使用されます。
#==============================================================================

class Game_Enemy < Game_Battler
  attr_accessor :sprite                   # 戦闘中のスプライト
  attr_accessor :scene_viewport
  #--------------------------------------------------------------------------
  # ● ダメージ効果の実行
  #--------------------------------------------------------------------------
  def perform_damage_effect
    @sprite_effect_type = :blink if Comtaro.blink_battler
    Sound.play_enemy_damage if Comtaro.play_damage_se
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃 アニメーション ID の取得
  #--------------------------------------------------------------------------
  def atk_animation_id1
    return /<ani_id[:：](\d+)>/ =~ enemy.note ? $1.to_i : 1
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃 アニメーション ID の取得
  #--------------------------------------------------------------------------
  def atk_animation_id2
    return 0
  end
  #--------------------------------------------------------------------------
  # ● HP の再生
  #--------------------------------------------------------------------------
  alias cs_regenerate_hp regenerate_hp unless $!
  def regenerate_hp
    cs_regenerate_hp
    return unless Comtaro.slip_popup
    case @result.hp_damage <=> 0
    when 0..1
      color = :normal
    when -1
      color = :heal
    end
    @sprite.damage_popup(@result.hp_damage.abs, @scene_viewport, color) unless (@result.hp_damage.zero? || !$game_party.in_battle)
  end
  #--------------------------------------------------------------------------
  # ● MP の再生
  #--------------------------------------------------------------------------
  alias cs_regenerate_mp regenerate_mp unless $!
  def regenerate_mp
    cs_regenerate_mp
    return unless Comtaro.slip_popup
    case @result.mp_damage <=> 0
    when 0..1
      color = :mp_damage
    when -1
      color = :mp_heal
    end
    @sprite.damage_popup(@result.mp_damage.abs, @scene_viewport, color) unless (@result.mp_damage.zero? || !$game_party.in_battle)
  end
  #--------------------------------------------------------------------------
  # ● TP の再生
  #--------------------------------------------------------------------------
  def regenerate_tp
    self.tp += 100 * trg
    return unless Comtaro.slip_popup
    case trg <=> 0
    when -1..0
      color = :tp_damage
    when 1
      color = :tp_heal
    end
    @sprite.damage_popup((100 * trg).to_i.abs, @scene_viewport, color) unless ((100 * trg).to_i.zero? || !$game_party.in_battle)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘用ステートの解除
  #--------------------------------------------------------------------------
  def remove_battle_states
    states.each do |state|
      next if state.id == death_state_id
      remove_state(state.id) if state.remove_at_battle_end
    end
  end
  #--------------------------------------------------------------------------
  # ● スプライトとかをクリア
  #--------------------------------------------------------------------------
  def clear_battle
    remove_instance_variable(:@sprite) rescue nil
    remove_instance_variable(:@scene_viewport) rescue nil
  end
end

#==============================================================================
# ■ Game_ActionResult
#------------------------------------------------------------------------------
# 　戦闘行動の結果を扱うクラスです。このクラスは Game_Battler クラスの内部で
# 使用されます。
#==============================================================================

class Game_ActionResult
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :e_rate                      # 属性相性
  #--------------------------------------------------------------------------
  # ● ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias cs_clear_damage_values clear_damage_values unless $!
  def clear_damage_values
    cs_clear_damage_values
    @e_rate = 1.0
  end
end
#==============================================================================
# ■ Game_Party
#------------------------------------------------------------------------------
# 　パーティを扱うクラスです。所持金やアイテムなどの情報が含まれます。このクラ
# スのインスタンスは $game_party で参照されます。
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● アクターを加える
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    @actors.push(actor_id) unless @actors.include?(actor_id)
    reset_battler_position
    $game_player.refresh
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● アクターを外す
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    @actors.delete(actor_id)
    reset_battler_position
    $game_player.refresh
    $game_map.need_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● パーティメンバーのバトラーグラフィックの位置を調整
  #--------------------------------------------------------------------------
  def reset_battler_position
    battle_members.each do |member|
      member.screen_x = (max_battle_members - battle_members.size) * (Graphics.width / max_battle_members / 2) + (battle_members.index(member) + 0.5) * (Graphics.width / max_battle_members)
      member.screen_x = (Graphics.width / max_battle_members) * (0.5 + battle_members.index(member)) if Comtaro.battler_pos != 1
      member.screen_x = Graphics.width - member.screen_x if Comtaro.battler_pos == 2
      member.screen_y = Graphics.height
      member.screen_y = -180 unless battle_members.include?(member)
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始処理
  #--------------------------------------------------------------------------
  def on_battle_start
    BattleManager.victoried = false
    $game_message.position = Comtaro.message_pos
    reset_battler_position
    super
  end
end
#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 戦闘中にステータスウィンドウを更新
  #--------------------------------------------------------------------------
  def redraw_status
    SceneManager.scene.refresh_status if $game_party.in_battle
  end
  #--------------------------------------------------------------------------
  # ● 文章の表示
  #--------------------------------------------------------------------------
  def command_101
    wait_for_message
    $game_message.face_name = @params[0]
    $game_message.face_index = @params[1]
    $game_message.background = @params[2]
    $game_message.position = ((Comtaro.force_set_position && $game_party.in_battle) ? Comtaro.message_pos : @params[3])
    while next_event_code == 401       # 文章データ
      @index += 1
      $game_message.add(@list[@index].parameters[0])
    end
    case next_event_code
    when 102  # 選択肢の表示
      @index += 1
      setup_choices(@list[@index].parameters)
    when 103  # 数値入力の処理
      @index += 1
      setup_num_input(@list[@index].parameters)
    when 104  # アイテム選択の処理
      @index += 1
      setup_item_choice(@list[@index].parameters)
    end
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● メンバーの入れ替え
  #--------------------------------------------------------------------------
  def command_129
    actor = $game_actors[@params[0]]
    if actor
      if @params[1] == 0    # 加える
        if @params[2] == 1  # 初期化
          $game_actors[@params[0]].setup(@params[0])
        end
        $game_party.add_actor(@params[0])
        if $game_party.in_battle
          actor.scene_viewport = @viewport
        end
      else                  # 外す
        $game_party.remove_actor(@params[0])
      end
      redraw_status
    end
  end
  #--------------------------------------------------------------------------
  # ● HP の増減
  #--------------------------------------------------------------------------
  alias cs_command_311 command_311 unless $!
  def command_311
    cs_command_311
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● MP の増減
  #--------------------------------------------------------------------------
  alias cs_command_312 command_312 unless $!
  def command_312
    cs_command_312
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● ステートの変更
  #--------------------------------------------------------------------------
  alias cs_command_313 command_313 unless $!
  def command_313
    cs_command_313
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● 全回復
  #--------------------------------------------------------------------------
  alias cs_command_314 command_314 unless $!
  def command_314
    cs_command_314
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● 経験値の増減
  #--------------------------------------------------------------------------
  alias cs_command_315 command_315 unless $!
  def command_315
    cs_command_315
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● レベルの増減
  #--------------------------------------------------------------------------
  alias cs_command_316 command_316 unless $!
  def command_316
    cs_command_316
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● 能力値の増減
  #--------------------------------------------------------------------------
  alias cs_command_317 command_317 unless $!
  def command_317
    cs_command_317
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● スキルの増減
  #--------------------------------------------------------------------------
  alias cs_command_318 command_318 unless $!
  def command_318
    cs_command_318
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● 装備の変更
  #--------------------------------------------------------------------------
  alias cs_command_319 command_319 unless $!
  def command_319
    cs_command_319
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● 名前の変更
  #--------------------------------------------------------------------------
  alias cs_command_320 command_320 unless $!
  def command_320
    cs_command_320
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● 職業の変更
  #--------------------------------------------------------------------------
  alias cs_command_321 command_321 unless $!
  def command_321
    cs_command_321
    redraw_status
  end
  #--------------------------------------------------------------------------
  # ● アクターのグラフィック変更
  #--------------------------------------------------------------------------
  alias cs_command_322 command_322 unless $!
  def command_322
    cs_command_322
    redraw_status
  end
end
class Sprite_Popup < Sprite
  attr_accessor :base_x
  attr_accessor :base_y
end
class Array_Popup < Array
  attr_accessor :pop_time
  attr_accessor :d_face
  attr_accessor :string
end
#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。Game_Battler クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#==============================================================================

class Sprite_Battler < Sprite_Base
  attr_reader :anime
  attr_accessor :ani_num
  attr_accessor :damaging
  attr_reader :s_anime
  attr_reader :p_sp
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias cs_initialize initialize unless $!
  def initialize(viewport, battler = nil)
    cs_initialize(viewport, battler)
    @anime = []
    @p_sp = []
    @ani_num = 0
    @s_anime = false
    self.z += 500 if self.battler && self.battler.actor?
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの開始
  #--------------------------------------------------------------------------
  def start_animation(animation, mirror = false, state = false)
    dispose_animation
    @animation = animation
    if @animation
      @ani_mirror = mirror
      @s_anime = state
      set_animation_rate
      @ani_duration = @animation.frame_max * @ani_rate + 1
      load_animation_bitmap
      make_animation_sprites
      set_animation_origin
    end
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの原点設定
  #--------------------------------------------------------------------------
  def set_animation_origin
    if @animation.position == 3
      if viewport == nil
        @ani_ox = Graphics.width / 2
        @ani_oy = Graphics.height / 2 + ((@animation.name[0] != ?* && self.battler.actor?) ? Comtaro.actor_screen_ani_y_ext : 0)
      else
        @ani_ox = viewport.rect.width / 2
        @ani_oy = viewport.rect.height / 2 + ((@animation.name[0] != ?* && self.battler.actor?) ? Comtaro.actor_screen_ani_y_ext : 0)
      end
    else
      @ani_ox = x - ox + width / 2
      @ani_oy = y - oy + height / 2
      if @animation.position == 0
        @ani_oy -= height / 2
      elsif @animation.position == 2
        @ani_oy += height / 2
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if @battler
      @use_sprite = @battler.use_sprite?
      if @use_sprite
        update_bitmap
        update_origin
        update_position
        update_popup
        state_animations
      end
      setup_new_effect
      setup_new_animation
      update_effect
    else
      self.bitmap = nil
      @effect_type = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 転送元ビットマップの更新
  #--------------------------------------------------------------------------
  def update_bitmap
    new_bitmap = @battler.actor? ? Cache.battler(@battler.battler_name, @battler.battler_hue ||= 0) : Cache.battler(@battler.battler_name, @battler.battler_hue)
    ((new_bitmap = Cache.battler("#{@battler.battler_name}_d", @battler.battler_hue ||= 0)) rescue nil) if self.damaging
    ((new_bitmap = Cache.battler("#{@battler.battler_name}_v", @battler.battler_hue ||= 0)) rescue nil) if BattleManager.victoried && @battler.actor?
    if bitmap != new_bitmap
      self.bitmap = new_bitmap
      init_visibility
    end
  end
  #--------------------------------------------------------------------------
  # ● ポップアップの更新
  #--------------------------------------------------------------------------
  def update_popup
    return if @p_sp.empty?
    @p_sp.each do |spt|
      fset = spt.string ? Comtaro.popup_font_str : Comtaro.popup_font_int
      self.damaging = true if @battler.actor? && spt.d_face && Comtaro.use_damage_face && (!BattleManager.victoried || !Comtaro.use_victory_face)
      spt.each do |sp|
        return if sp.disposed?
        s_chr = spt.index(sp)
        c_pop = spt.pop_time - (s_chr * fset[:lag])
        b_times = c_pop / fset[:speed]
        (sp.y = sp.base_y - (fset[:height].to_f / (fset[:atten] ** b_times)) * Math.sin(Math::PI * (c_pop % fset[:speed]) / fset[:speed].to_f)) if fset[:bounds] >= b_times
        sp.visible = true if c_pop >= 0
      end
      spt.pop_time += 1
      spt.each{|sp|sp.dispose} if spt.pop_time >= (spt.size * fset[:lag]) + fset[:speed] * (fset[:bounds] + 1) + fset[:time]
      self.damaging = false if @battler.actor? && spt.d_face && Comtaro.use_damage_face && (spt.pop_time >= (spt.size * fset[:lag]) + fset[:speed] * (fset[:bounds] + 1) + fset[:time]) && (!BattleManager.victoried || !Comtaro.use_victory_face)
      spt.delete_if {|sp| sp.disposed? }
    end
    @p_sp.delete_if {|spt| spt.empty? }
  end
  #--------------------------------------------------------------------------
  # ● ステートからアニメーションを取得
  #--------------------------------------------------------------------------
  def state_animations
    anime = []
    @state_list = @battler.states.sort_by {|i| i.priority }.reverse
    @state_list.each do |i|
      /<ani_id[:：](\d+)>/ =~ i.note ? anime.push($1.to_i) : nil
    end
    @anime = anime if @anime != anime
  end
  #--------------------------------------------------------------------------
  # ● ダメージポップアップ
  #--------------------------------------------------------------------------
  def damage_popup(damage, scene_viewport, color = :normal, face = false)
    return unless Comtaro.use_popup
    int = damage.is_a?(Integer)
    fset = int ? Comtaro.popup_font_int : Comtaro.popup_font_str
    damage = damage.separate if (damage.is_a?(Integer) && Comtaro.popup_separate)
    damage = damage.to_s
    damage = damage.tr("0123456789", Comtaro.popup_pattern) if Comtaro.popup_pattern.is_a?(String)
    if Comtaro.popup_pattern.is_a?(Array) && Comtaro.popup_pattern.size == 10
      new_damage = ""
      damage.each_char {|ch| new_damage += (Comtaro.popup_pattern[ch.to_i]) }
      damage = new_damage
    end
    dummy = Bitmap.new(1, 1)
    dummy.font.name = fset[:name]
    dummy.font.size = fset[:size]
    btxt = dummy.text_size(damage)
    btxt.width += (fset[:space] * (damage.size - 1))
    spt = Array_Popup.new
    spt.pop_time = 0
    spt.d_face = face
    spt.string = !int
    x_ad = 0
    damage.each_char do |chr|
      dummy = Bitmap.new(1, 1)
      dummy.font.name = fset[:name]
      dummy.font.size = fset[:size]
      text = dummy.text_size(chr)
      text.width += fset[:outline] if fset[:outline]
      text.width += fset[:bold] if fset[:bold]
      text.width += fset[:italic] if fset[:italic]
      text.height += fset[:bold] if fset[:bold]
      text.height += fset[:outline] if fset[:outline]
      p_bitmap = Bitmap.new(text.width, text.height)
      p_bitmap.font.name = fset[:name]
      p_bitmap.font.size = fset[:size]
      p_bitmap.font.shadow = fset[:shadow]
      p_bitmap.font.outline = fset[:outline]
      p_bitmap.font.bold = fset[:bold]
      p_bitmap.font.italic = fset[:italic]
      f_color = Comtaro.popup_color[color]
      until f_color.is_a?(Color)
        f_color = Comtaro.popup_color[f_color]
      end
      o_color = Comtaro.popup_outline[color]
      until o_color.is_a?(Color)
        o_color = Comtaro.popup_outline[o_color]
      end
      p_bitmap.font.color = f_color
      p_bitmap.font.out_color = o_color
      p_bitmap.draw_text(p_bitmap.rect, chr)
      sp = Sprite_Popup.new(scene_viewport)
      sp.bitmap = p_bitmap
      sp.base_x = sp.x = self.x - (btxt.width) / 2 + x_ad
      x_ad += sp.width
      x_ad += fset[:space]
      x_ad -= fset[:outline] if fset[:outline]
      x_ad -= fset[:bold] if fset[:bold]
      x_ad -= fset[:italic] if fset[:italic]
      sp.base_y = sp.y = self.y - btxt.height * 1.5 - @p_sp.size * btxt.height
      sp.z = 1500
      sp.visible = false
      spt.push(sp)
    end
    @p_sp.push(fset[:reverse] ? spt.reverse : spt)
  end
  #--------------------------------------------------------------------------
  # ● エフェクト実行中判定
  #--------------------------------------------------------------------------
#~   def effect?
#~     @effect_type && @effect_type != :whiten
#~   end
end

#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。このクラスは Scene_Battle クラ
# スの内部で使用されます。
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :enemy_sprites            # エネミースプライト
  attr_accessor :actor_sprites            # アクタースプライト
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    create_viewports
    create_battleback1
    create_battleback2
    create_enemies
    create_actorback
    create_actorback_window
    create_actors
    create_pictures
    create_timer
    update
  end
  #--------------------------------------------------------------------------
  # ● アクター背景ビットマップの取得
  #--------------------------------------------------------------------------
  def actorback_bitmap
    back = Bitmap.new(Graphics.width, 144)
    color1 = Color.new(0, 0, 0, 0)
    color2 = Color.new(0, 0, 0, 160)
    back.gradient_fill_rect(0, 0, Graphics.width, 32, color1, color2, true)
    back.fill_rect(0, 32, Graphics.width, 112, color2)
    back
  end
  #--------------------------------------------------------------------------
  # ● アクター背景スプライトの作成
  #--------------------------------------------------------------------------
  def create_actorback
    return unless Comtaro.actor_background == 1
    @back3_sprite = Sprite.new(@viewport1)
    @back3_sprite.bitmap = actorback_bitmap
    @back3_sprite.y = Graphics.height - 144
    @back3_sprite.z = 15
  end
  #--------------------------------------------------------------------------
  # ● アクター背景ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_actorback_window
    return unless Comtaro.actor_background >= 2
    @back3_sprite = Window_Base.new(0, 0, Graphics.width, 144)
    @back3_sprite.viewport = @viewport1
    @back3_sprite.y = Graphics.height - 144
    @back3_sprite.z = 15
  end
  #--------------------------------------------------------------------------
  # ● アクタースプライトの作成
  #--------------------------------------------------------------------------
  def create_actors
    @actor_sprites = Array.new($game_party.max_battle_members) { Sprite_Battler.new(@viewport1) }
  end
  #--------------------------------------------------------------------------
  # ● アニメーション表示中判定
  #--------------------------------------------------------------------------
  def animation?
    battler_sprites.any? {|sprite| sprite.animation? && !sprite.s_anime }
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias cs_dispose_for_xp dispose unless $!
  def dispose
    cs_dispose_for_xp
    dispose_battleback3
  end
  #--------------------------------------------------------------------------
  # ● 戦闘背景（アクター）スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_battleback3
    return unless @back3_sprite
    @back3_sprite.bitmap.dispose unless Comtaro.actor_background >= 2
    @back3_sprite.dispose
  end
end
class Sprite_BattleLog < Sprite
  attr_accessor :time
  def initialize(viewport, string)
    super(viewport)
    self.z = 80000
    self.opacity = 255
    @str = string
    @bmp = Bitmap.new(Graphics.width, Font.default_size)
    @time = 0
    create_background
    draw_text
    self.bitmap = @bmp
  end
  def update
    super
    return unless SceneManager.scene.is_a?(Scene_Battle)
    @time += SceneManager.scene.show_fast? ? 2 : 1
    self.x -= Graphics.width / (SceneManager.scene.show_fast? ? 4 : 8) if self.x.nonzero?
    self.x = 0 if self.x <= 0
    self.y -= (SceneManager.scene.show_fast? ? 2 : 1) if @time >= Comtaro.log_time
    self.opacity -= (SceneManager.scene.show_fast? ? 48 : 24) if @time >= Comtaro.log_time
    @bmp.dispose if self.opacity.zero?
    self.dispose if self.opacity.zero?
  end
  def create_background
    @bmp.gradient_fill_rect(@bmp.rect, Color.new, Color.new(0, 0, 0, 192))
  end
  def draw_text
    @bmp.draw_text(@bmp.rect, @str)
  end
end
#==============================================================================
# ■ Window_BattleLog
#------------------------------------------------------------------------------
# 　戦闘の進行を実況表示するウィンドウです。枠は表示しませんが、便宜上ウィンド
# ウとして扱います。
#==============================================================================

class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :spriteset
  attr_accessor   :scene_viewport
  attr_accessor   :log_sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias cs_initialize_xp initialize unless $!
  def initialize
    cs_initialize_xp
    @log_sprite = []
  end
  #--------------------------------------------------------------------------
  # ● 対象のバトラースプライトの取得
  #--------------------------------------------------------------------------
  def battler_sprite(target)
    actor = @spriteset.actor_sprites.find {|actor| actor.battler == target }
    enemy = @spriteset.enemy_sprites.find {|enemy| enemy.battler == target }
    return actor || enemy
  end
  #--------------------------------------------------------------------------
  # ● メッセージ速度の取得
  #--------------------------------------------------------------------------
  def message_speed
    return 20 - $game_variables[90]
  end
  #--------------------------------------------------------------------------
  # ● ポップアップのウェイト用メソッドの設定
  #--------------------------------------------------------------------------
  def method_wait_for_popup=(method)
    @method_wait_for_popup = method
  end
  #--------------------------------------------------------------------------
  # ● ログのウェイト用メソッドの設定
  #--------------------------------------------------------------------------
  def method_wait_for_battlelog=(method)
    @method_wait_for_battlelog = method
  end
  #--------------------------------------------------------------------------
  # ● ウェイト
  #--------------------------------------------------------------------------
  alias cs_wait wait unless $!
  def wait
    cs_wait if Comtaro.use_battlelog# && Comtaro.default_battlelog
  end
  #--------------------------------------------------------------------------
  # ● エフェクト実行が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_effect
    @method_wait_for_effect.call if @method_wait_for_effect && Comtaro.wait_for_dead? && Comtaro.use_battlelog && Comtaro.default_battlelog
  end
  #--------------------------------------------------------------------------
  # ● 一行戻る
  #--------------------------------------------------------------------------
  alias cs_back_one back_one unless $!
  def back_one
    return cs_back_one if Comtaro.use_battlelog && Comtaro.default_battlelog
  end
  #--------------------------------------------------------------------------
  # ● ウェイトとクリア
  #    メッセージが読める最低限のウェイトを入れた後クリアする。
  #--------------------------------------------------------------------------
  def wait_and_clear
    wait while @num_wait < 2 if line_number > 0 && Comtaro.use_battlelog && Comtaro.default_battlelog
    wait while @num_wait < 2 if @log_sprite.size > 0 && Comtaro.use_battlelog && !Comtaro.default_battlelog
    clear
    @method_wait_for_popup.call if @method_wait_for_popup && Comtaro.use_popup && Comtaro.wait_log_for_popup
    @method_wait_for_battlelog.call if @method_wait_for_battlelog && Comtaro.use_battlelog && !Comtaro.default_battlelog
  end
  #--------------------------------------------------------------------------
  # ● 背景の不透明度を取得
  #--------------------------------------------------------------------------
  def back_opacity
    Comtaro.use_battlelog ? 64 : 0
  end
  #--------------------------------------------------------------------------
  # ● 行の描画
  #--------------------------------------------------------------------------
  alias cs_draw_line draw_line unless $!
  def draw_line(line_number)
    cs_draw_line(line_number) if Comtaro.use_battlelog && Comtaro.default_battlelog
  end
  #--------------------------------------------------------------------------
  # ● 文章の追加
  #--------------------------------------------------------------------------
  alias cs_add_text add_text unless $!
  def add_text(text)
    return unless Comtaro.use_battlelog
    return cs_add_text(text) if Comtaro.default_battlelog
    return if text.empty?
    @log_sprite.delete_if{|sp|sp.disposed?}
    sprite = Sprite_BattleLog.new(@scene_viewport, text)
    sprite.x = Graphics.width
    sprite.y = (@log_sprite.collect{|sp|sp.y}.max + Font.default_size) rescue 16
    @log_sprite.push(sprite)
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  alias cs_clear_xp clear unless $!
  def clear
    return cs_clear_xp if Comtaro.use_battlelog && Comtaro.default_battlelog
    @log_sprite.each{|sp|sp.time = Comtaro.log_time unless sp.disposed?}
  end
  #--------------------------------------------------------------------------
  # ● 文章の置き換え
  #    最下行を別の文章に置き換える。
  #--------------------------------------------------------------------------
  alias cs_replace_text replace_text unless $!
  def replace_text(text)
    return cs_replace_text(text) if Comtaro.use_battlelog && Comtaro.default_battlelog
    add_text(text) unless Comtaro.default_battlelog
  end
  #--------------------------------------------------------------------------
  # ● 最下行の文章の取得
  #--------------------------------------------------------------------------
  alias cs_last_text last_text unless $!
  def last_text
    Comtaro.use_battlelog && Comtaro.default_battlelog ? cs_last_text : ""
  end
  #--------------------------------------------------------------------------
  # ● 指定した行に戻る
  #--------------------------------------------------------------------------
  alias cs_back_to back_to unless $!
  def back_to(line_number)
    cs_back_to(line_number) if Comtaro.use_battlelog
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテム使用の表示
  #--------------------------------------------------------------------------
  alias cs_display_use_item_for_xp display_use_item unless $!
  def display_use_item(subject, item)
    cs_display_use_item_for_xp(subject, item) unless (!(/<名前非表示>/ =~ item.note) && Comtaro.item_name_visible?)
  end
  #--------------------------------------------------------------------------
  # ● 行動結果の表示
  #--------------------------------------------------------------------------
  def display_action_results(target, item)
    if target.result.used
      last_line_number = line_number
      display_critical(target, item)
      display_e_sw(target, item)
      display_damage(target, item)
      display_affected_status(target, item)
      display_failure(target, item)
      wait if line_number > last_line_number
      back_to(last_line_number)
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート付加の表示
  #--------------------------------------------------------------------------
  def display_added_states(target)
    target.result.added_state_objects.each do |state|
      state_msg = target.actor? ? state.message1 : state.message2
      target.perform_collapse_effect if state.id == target.death_state_id
      if target.actor?
        s_name = /<AddforActor[:：](.+?)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
      else
        s_name = /<AddforEnemy[:：](.+?)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
      end
      rc = $2
      s_name ||= /<Add[:：](.+?)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
      rc ||= $2
      s_name ||= /<State[:：](.+)>/ =~ state.note ? $1 : nil
      s_support = state.note.include?("<プラスステート>")
      s_color = rc ? eval(rc) : (s_support ? :heal : :state)
      battler_sprite(target).damage_popup(s_name, scene_viewport, s_color, !s_support && Comtaro.use_damage_face[3] == 1) if s_name
      next if state_msg.empty?
      replace_text(target.name + state_msg)
      wait
      wait_for_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート解除の表示
  #--------------------------------------------------------------------------
  def display_removed_states(target)
    battler_sprite(target).end_animation if Comtaro.refresh_state
    target.result.removed_state_objects.each do |state|
      if target.actor?
        s_name = /<RemoveforActor[:：](.+?)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
      else
        s_name = /<RemoveforEnemy[:：](.+?)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
      end
      rc = $2
      s_name ||= /<Remove[:：](.+?)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
      rc = $2
      s_name ||= /<State[:：](.+)>/ =~ state.note ? $1 : nil
      s_support = state.note.include?("<プラスステート>")
      s_color = rc ? eval(rc) : (s_support ? :state : :heal)
      battler_sprite(target).damage_popup(s_name, scene_viewport, s_color) if s_name
      next if state.message4.empty?
      replace_text(target.name + state.message4)
      wait
    end
  end
  #--------------------------------------------------------------------------
  # ● 反撃の表示
  #--------------------------------------------------------------------------
  def display_counter(target, item)
    Sound.play_evasion if Comtaro.play_damage_se
    add_text(sprintf(Vocab::CounterAttack, target.name))
    battler_sprite(target).damage_popup(Comtaro.counter_popup, scene_viewport)
    wait
    back_one
  end
  #--------------------------------------------------------------------------
  # ● 反射の表示
  #--------------------------------------------------------------------------
  def display_reflection(target, item)
    Sound.play_reflection if Comtaro.play_damage_se
    add_text(sprintf(Vocab::MagicReflection, target.name))
    battler_sprite(target).damage_popup(Comtaro.refrect_popup, scene_viewport)
    wait
    back_one
  end
  #--------------------------------------------------------------------------
  # ● 身代わりの表示
  #--------------------------------------------------------------------------
  def display_substitute(substitute, target)
    add_text(sprintf(Vocab::Substitute, substitute.name, target.name))
    battler_sprite(target).damage_popup(Comtaro.substitute_popup, scene_viewport)
    wait
    back_one
  end
  #--------------------------------------------------------------------------
  # ● 失敗の表示
  #--------------------------------------------------------------------------
  def display_failure(target, item)
    if target.result.hit? && !target.result.success
      add_text(sprintf(Vocab::ActionFailure, target.name))
      battler_sprite(target).damage_popup(Comtaro.fail_popup, scene_viewport)
      wait
    end
  end
  #--------------------------------------------------------------------------
  # ● 属性相性の表示
  #--------------------------------------------------------------------------
  def display_e_sw(target, item)
    case target.result.e_rate <=> 1.0
    when -1
      @e_sw = :low
    when 0
      @e_sw = :none
    when 1
      @e_sw = :hi
    end
  end
  #--------------------------------------------------------------------------
  # ● クリティカルヒットの表示
  #--------------------------------------------------------------------------
  def display_critical(target, item)
    if target.result.critical
      @critical = true
      text = target.actor? ? Vocab::CriticalToActor : Vocab::CriticalToEnemy
      add_text(text)
      wait
    else
      @critical = false
    end
  end
  #--------------------------------------------------------------------------
  # ● ミスの表示
  #--------------------------------------------------------------------------
  def display_miss(target, item)
    if !item || item.physical?
      fmt = target.actor? ? Vocab::ActorNoHit : Vocab::EnemyNoHit
      Sound.play_miss if Comtaro.play_damage_se
    else
      fmt = Vocab::ActionFailure
    end
    add_text(sprintf(fmt, target.name))
    battler_sprite(target).damage_popup(Comtaro.miss_popup, scene_viewport)
    wait
  end
  #--------------------------------------------------------------------------
  # ● 回避の表示
  #--------------------------------------------------------------------------
  def display_evasion(target, item)
    if !item || item.physical?
      fmt = Vocab::Evasion
      Sound.play_evasion if Comtaro.play_damage_se
    else
      fmt = Vocab::MagicEvasion
      Sound.play_magic_evasion if Comtaro.play_damage_se
    end
    add_text(sprintf(fmt, target.name))
    battler_sprite(target).damage_popup(Comtaro.evade_popup, scene_viewport)
    wait
  end
  #--------------------------------------------------------------------------
  # ● HP ダメージ表示
  #--------------------------------------------------------------------------
  def display_hp_damage(target, item)
    return if target.result.hp_damage.zero? && item && !item.damage.to_hp?
    if target.result.hp_damage > 0 && target.result.hp_drain.zero?
      target.perform_damage_effect
    end
    Sound.play_recovery if target.result.hp_damage < 0
    add_text(target.result.hp_damage_text)
    case target.result.hp_damage <=> 0
    when 0..1
      color = @critical ? :critical : :normal
    when -1
      color = :heal
    end
    if color == :normal
      case @e_sw
      when :low
        color = :e_str
      when :hi
        color = :e_weak
      end
    end
    ref = SceneManager.scene.instance_variable_get(:@ref)
    if target.result.hp_drain > 0
      subject = ref ? SceneManager.scene.instance_variable_get(:@target) : SceneManager.scene.instance_variable_get(:@subject)
      battler_sprite(subject).damage_popup(target.result.hp_damage.abs, scene_viewport, :heal)
    end
    battler_sprite(target).damage_popup(target.result.hp_damage.abs, scene_viewport, color, target.result.hp_damage > 0 && Comtaro.use_damage_face[0] == 1)
    if Comtaro.overkill_rate && target.result.hp_damage >= target.mhp * Comtaro.overkill_rate && !ref
      add_text(Comtaro.overkill_message) if Comtaro.overkill_message
      SceneManager.scene.instance_variable_get(:@subject).overkill_bonus(target)
      target.sprite.damage_popup(Comtaro.overkill_popup, scene_viewport, :overkill)
    end
    wait
  end
  #--------------------------------------------------------------------------
  # ● MP ダメージ表示
  #--------------------------------------------------------------------------
  def display_mp_damage(target, item)
    return if target.result.mp_damage.zero? && item && !item.damage.to_mp?
    if target.result.mp_damage > 0 && target.result.mp_drain.zero?
      target.perform_damage_effect
    end
    Sound.play_recovery if target.result.mp_damage < 0
    add_text(target.result.mp_damage_text)
    case target.result.mp_damage <=> 0
    when 0..1
      color = :mp_damage
    when -1
      color = :mp_heal
    end
    if target.result.mp_drain > 0
      ref = SceneManager.scene.instance_variable_get(:@ref)
      subject = ref ? SceneManager.scene.instance_variable_get(:@target) : SceneManager.scene.instance_variable_get(:@subject)
      battler_sprite(subject).damage_popup(target.result.mp_damage.abs, scene_viewport, :mp_heal)
    end
    battler_sprite(target).damage_popup(target.result.mp_damage.abs, scene_viewport, color, target.result.mp_damage > 0 && Comtaro.use_damage_face[1] == 1)
    if Comtaro.overkill_rate && target.result.mp_damage >= target.mmp * Comtaro.overkill_rate && target.dead? && !ref
      add_text(Comtaro.overkill_message) if Comtaro.overkill_message
      SceneManager.scene.instance_variable_get(:@subject).overkill_bonus(target)
      target.sprite.damage_popup(Comtaro.overkill_popup, scene_viewport, :overkill)
    end
  end
  #--------------------------------------------------------------------------
  # ● TP ダメージ表示
  #--------------------------------------------------------------------------
  def display_tp_damage(target, item)
    return if target.dead? || target.result.tp_damage.zero?
    Sound.play_recovery if target.result.tp_damage < 0
    add_text(target.result.tp_damage_text)
    case target.result.tp_damage <=> 0
    when 0..1
      color = :tp_damage
    when -1
      color = :tp_heal
    end
    battler_sprite(target).damage_popup(target.result.tp_damage.abs, scene_viewport, color, target.result.tp_damage > 0 && Comtaro.use_damage_face[2] == 1)
    wait
  end
  #--------------------------------------------------------------------------
  # ● 能力強化／弱体の表示
  #--------------------------------------------------------------------------
  def display_changed_buffs(target)
    display_buffs(target, target.result.added_buffs, Vocab::BuffAdd)
    display_buffs(target, target.result.added_debuffs, Vocab::DebuffAdd)
    display_buffs(target, target.result.removed_buffs, Vocab::BuffRemove)
  end
  #--------------------------------------------------------------------------
  # ● 能力強化／弱体の表示（個別）
  #--------------------------------------------------------------------------
  def display_buffs(target, buffs, fmt)
    buffs.each do |param_id|
      case fmt
      when Vocab::BuffAdd
        color = :heal
        text = Comtaro.buff_popup
      when Vocab::DebuffAdd
        color = :state
        text = Comtaro.debuff_popup
      when Vocab::BuffRemove
        color = :normal
        text = Comtaro.dispel_popup
      end
      battler_sprite(target).damage_popup(Comtaro.param_popup[param_id] + text, scene_viewport, color, (fmt == Vocab::DebuffAdd) && Comtaro.use_damage_face[3] == 1) if Comtaro.param_popup[param_id]
      replace_text(sprintf(fmt, target.name, Vocab::param(param_id)))
      wait
    end
  end
end
#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # ● ウィンドウ位置の更新
  #--------------------------------------------------------------------------
  alias cs_update_placement_for_xp update_placement unless $!
  def update_placement
    cs_update_placement_for_xp
    return unless $game_party.in_battle
    @gold_window.y = y - @gold_window.height
    @gold_window.y = y + height if @gold_window.y < 0
  end
end
#==============================================================================
# ■ Window_BattleStatus
#------------------------------------------------------------------------------
# 　バトル画面で、パーティメンバーのステータスを表示するウィンドウです。
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(-standard_padding, Graphics.height - window_height, window_width, window_height)
    refresh
    self.openness = Comtaro.battle_system_message ? 0 : 255
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● 標準パディングサイズの取得
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    return 4
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width + standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    $game_party.max_battle_members
  end
  #--------------------------------------------------------------------------
  # ● 横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 項目の高さを取得
  #--------------------------------------------------------------------------
  def item_height
    height - standard_padding * 2
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new
    rect.width = item_width
    rect.height = item_height
    rect.x = index % col_max * (item_width + spacing)
    rect.x = contents.width - rect.width - rect.x if Comtaro.battler_pos == 2
    rect.y = index / col_max * item_height
    rect
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    rect = item_rect(index)
    icons = (actor.state_icons + actor.buff_icons)
    draw_actor_name(actor, rect.x + 1, rect.y, rect.width - 2) if Comtaro.draw_actor_name_for_xp
    draw_actor_icons(actor, rect.x + 1, rect.y + line_height * 1, rect.width - 2)
    draw_actor_hp(actor, rect.x + 4, rect.y + line_height * 2, rect.width - 8)
    draw_actor_mp(actor, rect.x + 4, rect.y + line_height * 3, rect.width - 8 - ($data_system.opt_display_tp ? Comtaro.tp_width : 0))
  end
end

#==============================================================================
# ■ Window_PartyCommand
#------------------------------------------------------------------------------
# 　バトル画面で、戦うか逃げるかを選択するウィンドウです。
#==============================================================================

class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width / 4 * item_max
  end
  #--------------------------------------------------------------------------
  # ● 横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    return 8
  end
  #--------------------------------------------------------------------------
  # ● 表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    return 1
  end
  #--------------------------------------------------------------------------
  # ● アライメントの取得
  #--------------------------------------------------------------------------
  def alignment
    return 1
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    item_max
  end
end

#==============================================================================
# ■ Window_ActorCommand
#------------------------------------------------------------------------------
# 　バトル画面で、アクターの行動を選択するウィンドウです。
#==============================================================================

class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, Graphics.height - 256)
    self.openness = 0
    deactivate
    @actor = nil
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width / $game_party.max_battle_members
  end
end
class Window_BattleActor < Window_BattleStatus
  #--------------------------------------------------------------------------
  # ● 標準パディングサイズの取得
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_battler($game_party.battle_members[@index])
  end
  #--------------------------------------------------------------------------
  # ● カーソルを右に移動
  #--------------------------------------------------------------------------
  alias cs_cursor_right cursor_right unless $!
  alias cs_cursor_left cursor_left unless $!
  def cursor_right(wrap = false)
    Comtaro.battler_pos == 2 ? cs_cursor_left(wrap) : cs_cursor_right(wrap)
  end
  #--------------------------------------------------------------------------
  # ● カーソルを左に移動
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    Comtaro.battler_pos != 2 ? cs_cursor_left(wrap) : cs_cursor_right(wrap)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
  end
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     info_viewport : 情報表示用ビューポート
  #--------------------------------------------------------------------------
  def initialize
    super
    self.visible = false
    self.openness = 255
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの表示
  #--------------------------------------------------------------------------
  def show
    select(0)
    super
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
  end
end
#==============================================================================
# ■ Window_BattleEnemy
#------------------------------------------------------------------------------
# 　バトル画面で、行動対象の敵キャラを選択するウィンドウです。
#==============================================================================

class Window_BattleEnemy < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     info_viewport : 情報表示用ビューポート
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, window_width, fitting_height(1))
    refresh
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_battler(enemy)
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    return item_max
  end
  #--------------------------------------------------------------------------
  # ● 先頭の桁の取得
  #--------------------------------------------------------------------------
  def top_col
    ox / (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # ● 先頭の桁の設定
  #--------------------------------------------------------------------------
  def top_col=(col)
    col = 0 if col < 0
    col = col_max - 1 if col > col_max - 1
    self.ox = col * (item_width + spacing)
  end
  #--------------------------------------------------------------------------
  # ● 末尾の桁の取得
  #--------------------------------------------------------------------------
  def bottom_col
    top_col + col_max - 1
  end
  #--------------------------------------------------------------------------
  # ● 末尾の桁の設定
  #--------------------------------------------------------------------------
  def bottom_col=(col)
    self.top_col = col - (col_max - 1)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの表示
  #--------------------------------------------------------------------------
  def show
    select(0)
    super
  end
  #--------------------------------------------------------------------------
  # ● 決定やキャンセルなどのハンドリング処理
  #--------------------------------------------------------------------------
  alias cs_process_handling process_handling unless $!
  def process_handling
    cs_process_handling
    return process_gauge   if Input.trigger?(Comtaro.gauge_input) && active
  end
  #--------------------------------------------------------------------------
  # ● ゲージボタンが押されたときの処理
  #--------------------------------------------------------------------------
  def process_gauge
    Input.update
    deactivate
    call_gauge_handler
  end
  #--------------------------------------------------------------------------
  # ● ゲージハンドラの呼び出し
  #--------------------------------------------------------------------------
  def call_gauge_handler
    call_handler(:gauge)
  end
end
#==============================================================================
# ■ Window_BattlerHelp
#------------------------------------------------------------------------------
# 　アクターやエネミーの簡単な情報を表示するウィンドウです。
#==============================================================================

class Window_BattlerHelp < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, Graphics.width, fitting_height(1))
    self.arrows_visible = false
    @type_num = 0
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の高さを計算
  #--------------------------------------------------------------------------
  def contents_height
    line_height * (2 + Comtaro.state_line_limit)
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #--------------------------------------------------------------------------
  def set_battler(battler)
    return unless battler
    @battler = battler
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 敵ゲージの描画
  #--------------------------------------------------------------------------
  def draw_enemy_gauge(enemy, x, y, type, width = 124)
    case type
    when :hp
      draw_gauge(x, y, width, enemy.hp_rate, hp_gauge_color1, hp_gauge_color2)
      change_color(system_color)
      draw_text(x, y, 30, line_height, Vocab::hp_a)
      change_color(normal_color)
      draw_current_and_max_values(x, y, width, enemy.hp, enemy.mhp,
        hp_color(enemy), normal_color) if hp_value_visible?(@battler)
    when :mp
      draw_gauge(x, y, width, enemy.mp_rate, mp_gauge_color1, mp_gauge_color2)
      change_color(system_color)
      draw_text(x, y, 30, line_height, Vocab::mp_a)
      change_color(normal_color)
      draw_current_and_max_values(x, y, width, enemy.mp, enemy.mmp,
        mp_color(enemy), normal_color) if mp_value_visible?(@battler)
    when :tp
      draw_gauge(x, y, width, enemy.tp_rate, tp_gauge_color1, tp_gauge_color2)
      change_color(system_color)
      draw_text(x, y, 30, line_height, Vocab::tp_a)
      change_color(normal_color)
      draw_current_and_max_values(x, y, width, enemy.tp.to_i, 100,
        tp_color(enemy), normal_color) if tp_value_visible?(@battler)
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のゲージを表示
  #--------------------------------------------------------------------------
  def next_gauge
    return if @type.size <= 1
    Sound.play_cursor
    @type_num += 1
    @type_num %= @type.size
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リセット
  #--------------------------------------------------------------------------
  def reset_gauge
    return if @type.size <= 1
    @type_num = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● HPゲージを表示するか
  #--------------------------------------------------------------------------
  def hp_visible?(battler)
    return false if battler.actor?
    return /<HP表示>(?:\r\n)*(.+)<\/HP表示>/m =~ battler.enemy.note ?
    eval($1) : battler.default_hp_visible?
  end
  #--------------------------------------------------------------------------
  # ● MPゲージを表示するか
  #--------------------------------------------------------------------------
  def mp_visible?(battler)
    return false if battler.actor?
    return /<MP表示>(?:\r\n)*(.+)<\/MP表示>/m =~ battler.enemy.note ?
    eval($1) : battler.default_mp_visible?
  end
  #--------------------------------------------------------------------------
  # ● TPゲージを表示するか
  #--------------------------------------------------------------------------
  def tp_visible?(battler)
    return false if battler.actor?
    return /<TP表示>(?:\r\n)*(.+)<\/TP表示>/m =~ battler.enemy.note ?
    eval($1) : battler.default_tp_visible?
  end
  #--------------------------------------------------------------------------
  # ● HP数値を表示するか
  #--------------------------------------------------------------------------
  def hp_value_visible?(battler)
    return false if battler.actor?
    return /<HP数値表示>(?:\r\n)*(.+)<\/HP数値表示>/m =~ battler.enemy.note ?
    eval($1) : battler.default_hp_value_visible?
  end
  #--------------------------------------------------------------------------
  # ● MP数値を表示するか
  #--------------------------------------------------------------------------
  def mp_value_visible?(battler)
    return false if battler.actor?
    return /<MP数値表示>(?:\r\n)*(.+)<\/MP数値表示>/m =~ battler.enemy.note ?
    eval($1) : battler.default_mp_value_visible?
  end
  #--------------------------------------------------------------------------
  # ● TP数値を表示するか
  #--------------------------------------------------------------------------
  def tp_value_visible?(battler)
    return false if battler.actor?
    return /<TP数値表示>(?:\r\n)*(.+)<\/TP数値表示>/m =~ battler.enemy.note ?
    eval($1) : battler.default_tp_value_visible?
  end
  #--------------------------------------------------------------------------
  # ● ステートおよび強化／弱体のアイコンを描画
  #--------------------------------------------------------------------------
  def draw_icons(battler, x, y)
    icons = battler.state_icons + battler.buff_icons
    icons.each_with_index {|n, i| draw_icon(n, x + 24 * (i % Comtaro.state_limit), y + 24 * (i / Comtaro.state_limit)) }
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    bs = @type.clone if @type
    @type = []
    @type.push(:hp) if hp_visible?(@battler)
    @type.push(:mp) if mp_visible?(@battler)
    @type.push(:tp) if tp_visible?(@battler)
    @type_num = 0 unless bs == @type
    self.width = contents.text_size(@battler.name).width + standard_padding * 2 + 8
    self.width = [self.width, [(standard_padding * 2 + (@battler.state_icons + @battler.buff_icons).size * 24), (standard_padding * 2 + Comtaro.state_limit * 24)].min].max if Comtaro.state_limit
    self.width = [self.width, Comtaro.min_gauge + 8 + standard_padding * 2].max unless @type.empty?
    self.height = fitting_height(@type.empty? ? 1 : 2)
    self.height = fitting_height((@type.empty? ? 1 : 2) + [Comtaro.state_line_limit, ((@battler.state_icons + @battler.buff_icons).size / Comtaro.state_limit.to_f).ceil].min) if Comtaro.state_limit
    draw_text(0, 0, self.width - standard_padding * 2, line_height, @battler.name, 1)
    draw_enemy_gauge(@battler, 4, line_height, @type[@type_num], self.width - 8 - standard_padding * 2)
    icon_x = 24 * [Comtaro.state_limit, (@battler.state_icons + @battler.buff_icons).size].min
    draw_icons(@battler, (self.width - standard_padding * 2 - icon_x) / 2, line_height * (@type.empty? ? 1 : 2)) if Comtaro.state_limit
  end
end
#==============================================================================
# ■ Window_ItemName
#------------------------------------------------------------------------------
# 　スキル・アイテムの名前を表示するウィンドウです。
#==============================================================================

class Window_ItemName < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((Graphics.width - Comtaro.help_width) / 2, 16, Comtaro.help_width, fitting_height(1))
    self.arrows_visible = false
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #--------------------------------------------------------------------------
  def set_item(item)
    return unless item
    @item = item
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_icon(@item.icon_index, (self.width - standard_padding * 2 - 24 - text_size(@item.name).width) / 2, 0)
    draw_text((self.width - standard_padding * 2 + (@item.icon_index.zero? ? 0 : 24) - text_size(@item.name).width) / 2, 0, text_size(@item.name).width + 24, line_height, @item.name)
  end
end

#==============================================================================
# ■ Scene_Base
#------------------------------------------------------------------------------
# 　ゲーム中の全てのシーンのスーパークラスです。
#==============================================================================

class Scene_Base
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias cs_update update unless $!
  def update
    $game_party.reset_battler_position
    cs_update
  end
end
#==============================================================================
# ■ Scene_Map
#------------------------------------------------------------------------------
# 　マップ画面の処理を行うクラスです。
#==============================================================================

class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias cs_start start unless $!
  def start
    cs_start
    $game_actors.instance_variable_get(:@data).each{|actor| actor.clear_battle rescue nil}
    $game_troop.members.each{|enemy| enemy.clear_battle}
    GC.start
  end
  #--------------------------------------------------------------------------
  # ● バトル画面遷移の前処理
  #--------------------------------------------------------------------------
  def pre_battle_scene
    Graphics.update
    Graphics.freeze
    $game_party.on_battle_start
    @spriteset.dispose_characters
    BattleManager.save_bgm_and_bgs
    BattleManager.play_battle_bgm
    Sound.play_battle_start
  end
end
#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle < Scene_Base
  attr_reader :log_window
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  alias cs_start start unless $!
  def start
    cs_start
    $game_party.all_members.each do |battler|
      battler.sprite = @spriteset.actor_sprites.find {|actor| actor.battler == battler }
      battler.scene_viewport = @viewport
    end
    $game_troop.members.each do |battler|
      battler.sprite = @spriteset.enemy_sprites.find {|enemy| enemy.battler == battler }
      battler.scene_viewport = @viewport
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  alias cs_terminate_xp terminate unless $!
  def terminate
    cs_terminate_xp
    if @log_window
      @log_window.log_sprite.each_with_index do |sp, idx|
        sp.bitmap.dispose unless sp.disposed?
        sp.dispose unless sp.disposed?
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ポップアップが終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_popup
    return unless Comtaro.popup_wait
    update_for_wait
    update_for_wait while (@spriteset.actor_sprites + @spriteset.enemy_sprites).any?{|battler| !battler.p_sp.empty? }
  end
  #--------------------------------------------------------------------------
  # ● ログ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_battlelog
    return unless Comtaro.battlelog_wait
    update_for_wait
    update_for_wait until @log_window.log_sprite.empty?
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新（基本）
  #--------------------------------------------------------------------------
  alias cs_update_basic update_basic unless $!
  def update_basic
    unless @b_help_window.visible
      @b_help_window.x = (Graphics.width - @b_help_window.width) / 2
      @b_help_window.y = (Graphics.height - @b_help_window.height) / 2
    end
    $game_message.position = Comtaro.message_pos
    $game_party.all_members.each do |battler|
      battler.sprite = @spriteset.actor_sprites.find {|actor| actor.battler == battler }
      battler.scene_viewport = @viewport
    end
    $game_troop.members.each do |battler|
      battler.sprite = @spriteset.enemy_sprites.find {|enemy| enemy.battler == battler }
      battler.scene_viewport = @viewport
    end
    @status_window.x = @actor_window.x = ($game_party.max_battle_members -  $game_party.battle_members.size) * (Graphics.width / $game_party.max_battle_members / 2) rescue nil
    @status_window.x = 0 if Comtaro.battler_pos != 1
    @spriteset.actor_sprites.each do |actor|
      (actor.start_animation($data_animations[actor.anime[actor.ani_num % actor.anime.size]], false, true);actor.ani_num += 1) if !actor.animation? && actor.anime[0] && (!BattleManager.in_turn? || Comtaro.s_anime_cont)
      actor.tone.set(0, 0, 0) if !@actor_window.active
      actor.tone.set(0, 0, 0) if @actor_window.index != @spriteset.actor_sprites.index(actor) && @actor_window.active
      next unless @actor_window.active
      if (@actor_window.index == @spriteset.actor_sprites.index(actor)) && actor.anime == []
        blink_time = (Graphics.frame_count - @start_frame) % Comtaro.blink_cycle
        case blink_time
        when 0..(Comtaro.blink_cycle / 2 - 1)
          blink = blink_time * Comtaro.select_brightness
        when (Comtaro.blink_cycle / 2)..(Comtaro.blink_cycle - 1)
          blink = (Comtaro.blink_cycle - blink_time) * Comtaro.select_brightness
        end
        actor.tone.set(Comtaro.blink_tone.red * blink / 255, Comtaro.blink_tone.green * blink / 255, Comtaro.blink_tone.blue * blink / 255, Comtaro.blink_tone.gray * blink / 255) 
      end
      if @actor_window.index == @spriteset.actor_sprites.index(actor)
        if Comtaro.battler_info_speed.zero?
          @b_help_window.x = (Graphics.width - @b_help_window.width) / 2
          @b_help_window.y = 80
        else
          ox = [Graphics.width - @b_help_window.width, [0, actor.x - @b_help_window.width / 2].max].min
          difx = ((@b_help_window.x - ox).abs * (@b_help_window.visible ? Comtaro.battler_info_speed : 1)).ceil
          case @b_help_window.x <=> ox
          when 1
            @b_help_window.x = [@b_help_window.x - difx, ox].max
          when -1
            @b_help_window.x = [@b_help_window.x + difx, ox].min
          end
          oy = [0, actor.y - actor.height - @b_help_window.height - 16].max
          dify = ((@b_help_window.y - oy).abs * (@b_help_window.visible ? Comtaro.battler_info_speed : 1)).ceil
          case @b_help_window.y <=> oy
          when 1
            @b_help_window.y = [@b_help_window.y - dify, oy].max
          when -1
            @b_help_window.y = [@b_help_window.y + dify, oy].min
          end
        end
      end
    end
    enemy_array = @spriteset.enemy_sprites.select do |enemy|
      enemy.battler.enemy? && enemy.battler.alive?
    end
    enemy_array.reverse!
    enemy_array.each do |enemy|
      (enemy.start_animation($data_animations[enemy.anime[enemy.ani_num % enemy.anime.size]], false, true);enemy.ani_num += 1) if !enemy.animation? && enemy.anime[0] && (!BattleManager.in_turn? || Comtaro.s_anime_cont)
      enemy.tone.set(0, 0, 0) if !@enemy_window.active
      enemy.tone.set(0, 0, 0) if @enemy_window.index != enemy_array.index(enemy) && @enemy_window.active
      next unless @enemy_window.active
      if (@enemy_window.index == enemy_array.index(enemy)) && enemy.anime == []
        blink_time = (Graphics.frame_count - @start_frame) % Comtaro.blink_cycle
        case blink_time
        when 0..(Comtaro.blink_cycle / 2 - 1)
          blink = blink_time * Comtaro.select_brightness
        when (Comtaro.blink_cycle / 2)..(Comtaro.blink_cycle - 1)
          blink = (Comtaro.blink_cycle - blink_time) * Comtaro.select_brightness
        end
        enemy.tone.set(Comtaro.blink_tone.red * blink / 255, Comtaro.blink_tone.green * blink / 255, Comtaro.blink_tone.blue * blink / 255, Comtaro.blink_tone.gray * blink / 255)
      end
      if @enemy_window.index == enemy_array.index(enemy)
        if Comtaro.battler_info_speed.zero?
          @b_help_window.x = (Graphics.width - @b_help_window.width) / 2
          @b_help_window.y = Graphics.height - 80 - @b_help_window.height
        else
          ox = [Graphics.width - @b_help_window.width, [0, enemy.x - @b_help_window.width / 2].max].min
          difx = ((@b_help_window.x - ox).abs * (@b_help_window.visible ? Comtaro.battler_info_speed : 1)).ceil
          case @b_help_window.x <=> ox
          when 1
            @b_help_window.x = [@b_help_window.x - difx, ox].max
          when -1
            @b_help_window.x = [@b_help_window.x + difx, ox].min
          end
          oy = [0, enemy.y - enemy.height - @b_help_window.height - 16].max
          dify = ((@b_help_window.y - oy).abs * (@b_help_window.visible ? Comtaro.battler_info_speed : 1)).ceil
          case @b_help_window.y <=> oy
          when 1
            @b_help_window.y = [@b_help_window.y - dify, oy].max
          when -1
            @b_help_window.y = [@b_help_window.y + dify, oy].min
          end
        end
      end
    end
    @party_command_window.x = (Graphics.width - @party_command_window.width) / 2 if @party_command_window
    if @log_window
      @log_window.log_sprite.each_with_index do |sp, idx|
        sp.update unless sp.disposed?
      end
    end
    @log_window.log_sprite.delete_if{|sp|sp.disposed?}
    cs_update_basic
  end
  #--------------------------------------------------------------------------
  # ● 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias cs_xp_create_all_windows create_all_windows unless $!
  def create_all_windows
    create_b_help_window
    create_item_name_window
    cs_xp_create_all_windows
    @log_window.spriteset = @spriteset
  end
  #--------------------------------------------------------------------------
  # ● バトラーヘルプウィンドウの作成
  #--------------------------------------------------------------------------
  def create_b_help_window
    @b_help_window = Window_BattlerHelp.new
    @b_help_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● アイテム名ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_item_name_window
    @item_name_window = Window_ItemName.new
    @item_name_window.visible = false
    @item_name_window.z = 5000
  end
  #--------------------------------------------------------------------------
  # ● メッセージウィンドウを開く処理の更新
  #    ステータスウィンドウなどが閉じ終わるまでオープン度を 0 にする。
  #--------------------------------------------------------------------------
  alias cs_update_message_open_for_xp update_message_open unless $!
  def update_message_open
    cs_update_message_open_for_xp if !Comtaro.unclose_status_event
    @status_window.open if !$game_message.busy? && @status_window.close?
  end
  #--------------------------------------------------------------------------
  # ● 情報表示ビューポートの更新
  #--------------------------------------------------------------------------
  def update_info_viewport
    move_info_viewport(0)
  end
  #--------------------------------------------------------------------------
  # ● ステータスウィンドウの作成
  #--------------------------------------------------------------------------
  def create_status_window
    @status_window = Window_BattleStatus.new
    @status_window.x = ($game_party.max_battle_members -  $game_party.battle_members.size) * (Graphics.width / $game_party.max_battle_members / 2)
    @status_window.x = 0 if Comtaro.battler_pos != 1
    if Comtaro.actor_background == 3
      @status_window.y -= 8
    end
  end
  #--------------------------------------------------------------------------
  # ● 情報表示ビューポートの作成
  #--------------------------------------------------------------------------
  def create_info_viewport
    @info_viewport = Viewport.new
    @info_viewport.rect.y = Graphics.height - @status_window.height
    @info_viewport.rect.height = @status_window.height
    @info_viewport.z = 100
    @info_viewport.ox = 64
  end
  #--------------------------------------------------------------------------
  # ● ログウィンドウの作成
  #--------------------------------------------------------------------------
  def create_log_window
    @log_window = Window_BattleLog.new
    @log_window.method_wait = method(:wait)
    @log_window.method_wait_for_effect = method(:wait_for_effect)
    @log_window.method_wait_for_popup = method(:wait_for_popup)
    @log_window.method_wait_for_battlelog = method(:wait_for_battlelog)
    @log_window.scene_viewport = (@viewport)
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_party_command_window
    @party_command_window = Window_PartyCommand.new
    @party_command_window.set_handler(:fight,  method(:command_fight))
    @party_command_window.set_handler(:escape, method(:command_escape))
    @party_command_window.unselect
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_actor_command_window
    @actor_command_window = Window_ActorCommand.new
    @actor_command_window.set_handler(:attack, method(:command_attack))
    @actor_command_window.set_handler(:skill,  method(:command_skill))
    @actor_command_window.set_handler(:guard,  method(:command_guard))
    @actor_command_window.set_handler(:item,   method(:command_item))
    @actor_command_window.set_handler(:cancel, method(:prior_command))
    @actor_command_window.x = Graphics.width
  end
  #--------------------------------------------------------------------------
  # ● アクターウィンドウの作成
  #--------------------------------------------------------------------------
  def create_actor_window
    @actor_window = Window_BattleActor.new
    @actor_window.set_handler(:ok,     method(:on_actor_ok))
    @actor_window.set_handler(:cancel, method(:on_actor_cancel))
    @actor_window.help_window = @b_help_window
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラウィンドウの作成
  #--------------------------------------------------------------------------
  def create_enemy_window
    @enemy_window = Window_BattleEnemy.new
    @enemy_window.set_handler(:ok,     method(:on_enemy_ok))
    @enemy_window.set_handler(:cancel, method(:on_enemy_cancel))
    @enemy_window.set_handler(:gauge , method(:on_enemy_gauge))
    @enemy_window.help_window = @b_help_window
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択の開始
  #--------------------------------------------------------------------------
  def start_actor_command_selection
    @party_command_window.close
    @actor_command_window.x = ($game_party.max_battle_members -  $game_party.battle_members.size) * (Graphics.width / $game_party.max_battle_members / 2) + BattleManager.actor.index * (Graphics.width / $game_party.max_battle_members)
    @actor_command_window.x = (Graphics.width / $game_party.max_battle_members) * BattleManager.actor.index if Comtaro.battler_pos != 1
    @actor_command_window.x = Graphics.width - @actor_command_window.x - @actor_command_window.width if Comtaro.battler_pos == 2
    @actor_command_window.y = Comtaro.command_window_pos ? Comtaro.command_window_pos : (Graphics.height - @actor_command_window.height - BattleManager.actor.sprite.height)
    @actor_command_window.setup(BattleManager.actor)
  end
  #--------------------------------------------------------------------------
  # ● コマンド［攻撃］
  #--------------------------------------------------------------------------
  def command_attack
    @skill = $data_skills[BattleManager.actor.attack_skill_id]
    @item = nil
    BattleManager.actor.input.set_attack
    select_enemy_selection
  end
  #--------------------------------------------------------------------------
  # ● コマンド［防御］
  #--------------------------------------------------------------------------
  def command_guard
    @skill = $data_skills[BattleManager.actor.guard_skill_id]
    @item = nil
    BattleManager.actor.input.set_guard
    next_command
  end
  #--------------------------------------------------------------------------
  # ● スキル［決定］
  #--------------------------------------------------------------------------
  def on_skill_ok
    @skill = @skill_window.item
    @item = nil
    BattleManager.actor.input.set_skill(@skill.id)
    BattleManager.actor.last_skill.object = @skill
    if !@skill.need_selection?
      @skill_window.hide
      next_command
    elsif @skill.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテム［決定］
  #--------------------------------------------------------------------------
  def on_item_ok
    @item = @item_window.item
    @skill = nil
    BattleManager.actor.input.set_item(@item.id)
    if !@item.need_selection?
      @item_window.hide
      next_command
    elsif @item.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
    $game_party.last_item.object = @item
  end
  #--------------------------------------------------------------------------
  # ● アクター選択の開始
  #--------------------------------------------------------------------------
  def select_actor_selection
    @actor_window.refresh
    @start_frame = Graphics.frame_count
    @actor_window.show.hide.activate
    @b_help_window.show
    @item_name_window.set_item(@skill || @item)
    @item_name_window.show if (!(/<名前非表示>/ =~ (@skill || @item).note) && Comtaro.view_select_target)
    @actor_command_window.hide
    @skill_window.hide
    @item_window.hide
  end
  #--------------------------------------------------------------------------
  # ● アクター［決定］
  #--------------------------------------------------------------------------
  def on_actor_ok
    BattleManager.actor.input.target_index = @actor_window.index
    @actor_window.deactivate
    @b_help_window.hide
    @item_name_window.hide
    @actor_command_window.show
    next_command
  end
  #--------------------------------------------------------------------------
  # ● アクター［キャンセル］
  #--------------------------------------------------------------------------
  def on_actor_cancel
    @actor_command_window.show
    @b_help_window.hide
    @item_name_window.hide
    @actor_window.deactivate
    case @actor_command_window.current_symbol
    when :skill
      @skill_window.show.activate
    when :item
      @item_window.show.activate
    else
      @actor_command_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラ選択の開始
  #--------------------------------------------------------------------------
  def select_enemy_selection
    @enemy_window.refresh
    @start_frame = Graphics.frame_count
    @enemy_window.show.hide.activate
    @b_help_window.reset_gauge
    @b_help_window.show
    @item_name_window.set_item(@skill || @item)
    @item_name_window.show if (!(/<名前非表示>/ =~ (@skill || @item).note) && Comtaro.view_select_target)
    @actor_command_window.hide
    @skill_window.hide
    @item_window.hide
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラ［決定］
  #--------------------------------------------------------------------------
  def on_enemy_ok
    BattleManager.actor.input.target_index = @enemy_window.enemy.index
    @actor_command_window.show
    @b_help_window.hide
    @item_name_window.hide
    next_command
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラ［ゲージ切替］
  #--------------------------------------------------------------------------
  def on_enemy_gauge
    return if @actor_window.active
    @b_help_window.next_gauge
    @enemy_window.activate
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラ［キャンセル］
  #--------------------------------------------------------------------------
  def on_enemy_cancel
    @actor_command_window.show
    @b_help_window.hide
    @item_name_window.hide
    case @actor_command_window.current_symbol
    when :skill
      @skill_window.show.activate
    when :item
      @item_window.show.activate
    else
      @actor_command_window.activate
    end
  end
  #--------------------------------------------------------------------------
  # ● ターン開始
  #--------------------------------------------------------------------------
  def turn_start
    @party_command_window.close
    @actor_command_window.close
    @status_window.unselect
    unless Comtaro.s_anime_cont
      @spriteset.actor_sprites.each{|sp|sp.end_animation}
      @spriteset.enemy_sprites.each{|sp|sp.end_animation}
    end
    @subject =  nil
    wait_for_popup
    BattleManager.turn_start
    @log_window.wait
    @log_window.clear
  end
  #--------------------------------------------------------------------------
  # ● ターン終了
  #--------------------------------------------------------------------------
  def turn_end
    all_battle_members.each do |battler|
      battler.on_turn_end
      refresh_status
      @log_window.display_auto_affected_status(battler)
      @log_window.wait_and_clear
    end
    BattleManager.turn_end
    process_event
    start_party_command_selection
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行
  #--------------------------------------------------------------------------
  def execute_action
    wait_for_popup
    @subject.sprite_effect_type = :whiten
    use_item
    wait_for_popup
  end
  #--------------------------------------------------------------------------
  # ● 行動時に使用者側に表示するアニメーションIDを取得
  #--------------------------------------------------------------------------
  def user_animation(item)
    if /<ani_id[:：](\d+)>/ =~ item.note
      return $1.to_i
    end
    return Comtaro.skill_animation[0] if item.is_a?(RPG::Item)
    return Comtaro.skill_animation[item.stype_id]
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの使用
  #--------------------------------------------------------------------------
  def use_item
    item = @subject.current_action.item
    show_animation([@subject], user_animation(item))
    @item_name_window.y = 16
    @log_window.display_use_item(@subject, item)
    unless ((/<名前非表示>/ =~ item.note) && Comtaro.item_name_visible?)
      @item_name_window.set_item(item)
      @item_name_window.show
    end
    wait(Comtaro.help_time) if item.animation_id.zero?
    @subject.use_item(item)
    refresh_status
    targets = @subject.current_action.make_targets.compact
    show_animation(targets, item.animation_id)
    @item_name_window.hide
    targets.each {|target| item.repeats.times { invoke_item(target, item) } }
  end
  #--------------------------------------------------------------------------
  # ● スキル／アイテムの発動
  #--------------------------------------------------------------------------
  def invoke_item(target, item)
    @target = target
    if rand < target.item_cnt(@subject, item)
      @ref = false
      invoke_counter_attack(target, item)
    elsif rand < target.item_mrf(@subject, item)
      @ref = true
      invoke_magic_reflection(target, item)
    else
      @ref = false
      apply_item_effects(apply_substitute(target, item), item)
    end
    @subject.last_target_index = target.index
  end
  #--------------------------------------------------------------------------
  # ● 魔法反射の発動
  #--------------------------------------------------------------------------
  def invoke_magic_reflection(target, item)
    wait_for_popup
    Comtaro.reflect_anime_id ? show_animation([target], Comtaro.reflect_anime_id) : @log_window.display_reflection(target, item)
    show_animation([@subject], item.animation_id)
    apply_item_effects(@subject, item)
  end
  #--------------------------------------------------------------------------
  # ● 攻撃アニメーションの表示
  #     targets : 対象者の配列
  #    アクターの場合は二刀流を考慮（左手武器は反転して表示）。
  #--------------------------------------------------------------------------
  def show_attack_animation(targets)
    show_normal_animation(targets, @subject.atk_animation_id1, false)
    show_normal_animation(targets, @subject.atk_animation_id2, true)
  end
  #--------------------------------------------------------------------------
  # ● 通常アニメーションの表示
  #     targets      : 対象者の配列
  #     animation_id : アニメーション ID
  #     mirror       : 左右反転
  #--------------------------------------------------------------------------
  alias cs_show_animation show_animation unless $!
  def show_animation(targets, animation_id)
    return if animation_id.to_i.zero?
    cs_show_animation(targets, animation_id)
  end
  #--------------------------------------------------------------------------
  # ● 勝敗判定
  #--------------------------------------------------------------------------
  def judge_win_loss
    wait_for_effect if Comtaro.wait_for_dead?
    if BattleManager.phase
      return BattleManager.process_abort   if $game_party.members.empty?
      return BattleManager.process_victory if $game_troop.all_dead?
      return BattleManager.process_abort   if BattleManager.aborting?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if BattleManager.in_turn?
      process_event
      process_action
    end
    judge_win_loss
  end
  #--------------------------------------------------------------------------
  # ● イベントの処理
  #--------------------------------------------------------------------------
  def process_event
    while !scene_changing?
      $game_troop.interpreter.update
      $game_troop.setup_battle_event
      wait_for_message
      wait_for_effect if $game_troop.all_dead?
      process_forced_action
      judge_win_loss
      break unless $game_troop.interpreter.running?
      update_for_wait
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動終了時の処理
  #--------------------------------------------------------------------------
  def process_action_end
    @subject.on_action_end
    refresh_status
    @log_window.display_auto_affected_status(@subject)
    @log_window.display_current_state(@subject)
    judge_win_loss
  end
end
class Sprite_Base
  #--------------------------------------------------------------------------
  # ○ アニメーションスプライトの設定
  #     frame : フレームデータ（RPG::Animation::Frame）
  #--------------------------------------------------------------------------
  def animation_set_sprites(frame)
    cell_data = frame.cell_data
    @ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @ani_bitmap1 : @ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @ani_mirror
        sprite.x = @ani_ox - cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @ani_ox + cell_data[i, 1]
        sprite.y = @ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 300 + i
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6]
      sprite.blend_type = cell_data[i, 7]
    end
  end
end