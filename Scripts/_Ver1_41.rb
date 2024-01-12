# ■ RGSS3 ステート超絶拡張 Ver1.41 by ComtaroRGSS(@ComtaroRgss)
#------------------------------------------------------------------------------
# 　通常、戦闘不能になると、すべてのステートが解除されますが、
# このスクリプトを使用することで、解除されないステートを設定できます。
#   戦闘不能時に解除したくないステートのメモ欄に
#   <Unclear>
#   と記述してください。（文字列は設定項目より変更可能）
#   おまけとして、エネミーに戦闘開始時から指定したステートを付与する機能も
# 導入してあります。
#   複数のエネミーに適用させる特徴とかをステートで設定して後で簡単に手直し
# できるようにしたい場合などに便利です。
#   エネミーのメモ欄に
# <States:n>
#   と入れると、n番目のステートを付与します。（いくつでも設定可能）
# <States:沈黙>
# といったように、ステートの名前でも指定可能です。
#   ただし、ステートの名前を半角数字だけで構成しないでください。
#==============================================================================
#__END__
$imported ||= {}
$imported[:cs_state_death] = true

class Game_Battler < Game_BattlerBase
# 設定項目ここから
  def unclear_state
    # 戦闘不能時に解除しないステートのメモ欄に含める文字列
    return "<Unclear>"
  end
# 設定項目ここまで

  #--------------------------------------------------------------------------
  # ● 戦闘不能になる（再定義）
  #--------------------------------------------------------------------------
  def die
    @hp = 0
    clear_states_die
    clear_buffs
  end

  #--------------------------------------------------------------------------
  # ● 戦闘不能時のステート解除
  #--------------------------------------------------------------------------
  def clear_states_die
    @states.each do |i|
      erase_state(i) unless $data_states[i].note.include?(unclear_state)
    end
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
  # ● ステート解除の表示
  #--------------------------------------------------------------------------
  def display_removed_states(target)
    target.result.removed_state_objects.each do |state|
      next if target.death_state? && state.id != target.death_state_id
      next if state.message4.empty?
      if $imported[:cs_xp_style]
        if target.actor?
          s_name = /<RemoveforActor[:：](.+)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
        else
          s_name = /<RemoveforEnemy[:：](.+)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
        end
        rc = $2
        s_name ||= /<Remove[:：](.+)(?:,\s*(:.+))?>/ =~ state.note ? $1 : nil
        rc = $2
        s_name ||= /<State[:：](.+)>/ =~ state.note ? $1 : nil
        s_support = state.note.include?("<プラスステート>")
        s_color = rc ? eval(rc) : (s_support ? :state : :heal)
        battler_sprite(target).damage_popup(s_name, scene_viewport, s_color) if s_name
      end
      replace_text(target.name + state.message4)
      wait
    end
  end
end