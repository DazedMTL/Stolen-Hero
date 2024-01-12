#==============================================================================
# ■ 敵グループメンバーの位置設定 Var.1.00
#------------------------------------------------------------------------------
#                                                       作成  ぽんぽこねるそん
#------------------------------------------------------------------------------
#   ※利用規約
#     ・利用は自己責任。
#     ・作成者を偽らないでください。
#     ・素材自体の二次配布はしないでください。
#     ・商用・非商用問わず利用できます。
#     ・使用報告・クレジットの記載は必要ありません。
#     ・改変はご自由にどうぞ。
#
#------------------------------------------------------------------------------
#   ※連絡先  バグ報告・ご要望はこちらまで
#       ponpokonerusontanuki@gmail.com
#------------------------------------------------------------------------------
# 　敵グループメンバーの位置を
#   自由に設定できるようにします。
#
#------------------------------------------------------------------------------
#   ※使い方
#     スクリプトエディタの(ここに追加)より下にコピペして貼り付けてください。
#
#     位置設定をしたい敵グループの1ページ目のバトルイベントに
#     注釈で<メンバー座標:index,x,y>と記述してください。
#       ・index  : メンバーのインデックス(グループに追加した順番)
#       ・x      : 画像の中心のX座標(変更しない場合は記述しない)
#       ・y      : 画像の下端のY座標(変更しない場合は記述しない)
#
#     ex.1番目のメンバーのY座標を400にする
#         <メンバー座標:1,,400>
#
#
#------------------------------------------------------------------------------
#   ※更新履歴
#     19/09/08 作成
#
#==============================================================================
#==============================================================================
# ■ Game_Troop
#------------------------------------------------------------------------------
# 　敵グループおよび戦闘に関するデータを扱うクラスです。バトルイベントの処理も
# 行います。このクラスのインスタンスは $game_troop で参照されます。
#==============================================================================

class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  alias members_xy_setup setup
  def setup(troop_id)
    $data_troops[troop_id].change_members_xy
    members_xy_setup(troop_id)
  end
end
class RPG::Troop
  #--------------------------------------------------------------------------
  # ● メンバーの座標の変更
  #--------------------------------------------------------------------------
  def change_members_xy
    return if @change_members_xy_flag
    pages[0].list_annotation.each_line do |line|
      line =~ /<メンバー座標:(.+)>/
      next unless $1
      arr = $1.split(/\s*,\s*/)
      member = members[arr[0].to_i - 1]
      next unless member
      member.x = arr[1].to_i if arr[1] && !arr[1].empty?
      member.y = arr[2].to_i if arr[2] && !arr[2].empty?
    end
    @change_members_xy_flag = true
  end
end
class RPG::Troop::Page
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  ANNOTATION_CODES = [108, 408]
  #--------------------------------------------------------------------------
  # ● イベントページの注釈取得
  #--------------------------------------------------------------------------
  def list_annotation
    return @annotation if @annotation
    @annotation = self.list.inject("") do |r, i|
      j = ANNOTATION_CODES.include?(i.code) ? i.parameters[0] + "\n" : ""
      r + j
    end
    @annotation
  end
end