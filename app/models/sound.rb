include Math
require 'variables'

class Sound
  include ActiveModel::Model

  def initialize()
    @standard = 440
    @tuning = "eq_temp"
  end

  def pitch_devide()
    c2 = @standard / 8 * (2 ** 0.25)

    pitch_log = log(@pitch/c2) / log(2)
    pitch_register = pitch_log.floor + 2
    num_cent = (pitch_log % 1) * 12

    cent = ((num_cent + 0.5) % 1 - 0.5) * 100
    local_register = (num_cent + 0.5).floor
    if local_register < 12
      chromatic = (num_cent + 0.5).floor
    else
      chromatic = 0
      pitch_register += 1
    end
    
    @chromatic = chromatic
    @fifth = ( chromatic * 7 + 6 ) % 12 - 6
    @register = pitch_register
    @cent = cent.round
  end

  def set_pitch(pitch)
    @pitch = pitch.to_f
    self.pitch_devide()
  end

  def set_sound(chromatic, register)
    @chromatic = chromatic
    @fifth = ( @chromatic * 7 + 6 ) % 12 - 6
    @register = register
    @cent = 0
    @pitch = @standard * 2 ** ( ( @chromatic - 9 ) / 12 ) * 2 ** (@register - 4)
  end
end