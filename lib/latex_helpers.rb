module LatexHelpers
  def self.escape(str)
    return "" unless str
    str.to_s.gsub(/[\\&%$#_{}~^]/) { |c| "\\" + c }
  end
end
