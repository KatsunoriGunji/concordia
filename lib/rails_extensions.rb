class Integer
  @@array_degree = %w(I II III IV V VI VII)
  @@array_en = %w(C D E F G A B)
  @@array_de = %w(C D E F G A H)
  @@array_jp = %w(ハ ニ ホ ヘ ト イ ロ)
  @@array_accidental    = ["𝄫", "♭", "", "#", "𝄪"]
  @@array_accidental_de = ["eses", "es", "", "is", "isis"]
  @@array_accidental_jp = ["重変", "変", "", "嬰", "重嬰"]

  def to_fifth
    ( self * 7 + 6 ) % 12 - 6
  end

  def accidental
    r = (self + 1) % 7 - 1
    ( self - r ) / 7
  end

  def degree
    (4 * self) % 7
  end

  def degree_odd
    number = (self == 7) ? -5 : self
    degree       = 1 + (4 * number) % 7
    degree += 7 if degree.even?
    degree
  end

  def tension
    number = (self == 7) ? -5 : self
    accidental = number.accidental
    @@array_accidental[ 2 + accidental ] + self.degree_odd.to_s
  end

  def degree_name
    @@array_accidental[ 2 + self.accidental ] + @@array_degree[ self.degree ]
  end

  def note_name
    @@array_en[ self.degree ] + @@array_accidental[ 2 + self.accidental ]
  end

  def note_name_de
    result = @@array_de[ self.degree ] + @@array_accidental_de[ 2 + self.accidental ]
    result.sub(/Hes/, "B").sub(/Aes/, "As").sub(/Ees/, "Es")
  end

  def note_name_jp
    @@array_accidental_jp[ 2 + self.accidental ] + @@array_jp[ self.degree ]
  end

  def note_name_gagaku
    array = %w(神仙 双調 壱越 黄鐘 平調 盤渉 下無 上無 鳧鐘 断金 鸞鏡 勝絶)
    array[self % 12]
  end
end