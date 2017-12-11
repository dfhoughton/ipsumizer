require "ipsumizer/version"

class Ipsumizer
  attr_reader :prefix, :sentencer

  DEFAULT_SENTENCER = Regexp.new %r{([.!?][.!?\p{Final_Punctuation}\p{Close_Punctuation}"\s]*)}

  DEFAULT_PREFIX = 4

  def initialize( sentences, prefix: DEFAULT_PREFIX, sentencer: DEFAULT_SENTENCER )
    @prefix = prefix
    @sentencer = sentencer
    @transitions = {}
    if sentences.is_a? String
      sentences = sentence sentences
    end
    sentences = sentences.map{ |s| s.strip.gsub /\s/, ' ' }.select{ |s| s =~ /\S/ }
    fail "no sentences" unless sentences.any?
    sentences.each do |s|
      key = ''
      i = 0
      (0...s.length).each do |i|
        nxt = if i === s.length
          nil
        else
          s[i]
        end
        counts = @transitions[key] ||= {}
        counts[nxt] = counts[nxt].to_i + 1
        if nxt
          key += nxt
          if key.length > prefix
            key = key[1..-1]
          end
        end
      end
    end
    @transitions.each do |pfx, counts|
      total = counts.values.reduce(:+)
      probabilities = counts.values.map{ |n| n.to_r / total }
      @transitions[pfx] = AliasTable.new( counts.keys, probabilities )
    end
  end

  # split a text into sentences, where sentences are separated by on of '.', '!', and '?', optionally preceded by
  # double quotes or closing brackets and so forth
  def sentence(text)
    text.split(sentencer).each_slice(2).map{ |*bits| bits.join }.select{ |s| s =~ /\S/ }
  end

  # make a random sentence
  def speak
    pfx = s = ''
    loop do
      nxt = @transitions[pfx]&.generate
      break unless nxt
      s += nxt
      pfx += nxt
      if pfx.length > prefix
        pfx = pfx[1..-1]
      end
    end
    s
  end

  # copied in here and fixed because the gem was in a broken state
  class AliasTable
    def initialize(x_set, p_value)
      @p_primary = p_value.map(&:to_r)
      @x = x_set.clone.freeze
      @alias = Array.new(@x.length)
      parity = Rational(1, @x.length)
      group = @p_primary.each_index.group_by { |i| @p_primary[i] <=> parity }
      parity_set = group.fetch(0, [])
      parity_set.each { |i| @p_primary[i] = Rational(1) }
      deficit_set = group.fetch(-1, [])
      surplus_set = group.fetch(1, [])
      until deficit_set.empty?
        deficit = deficit_set.pop
        surplus = surplus_set.pop
        @p_primary[surplus] -= parity - @p_primary[deficit]
        @p_primary[deficit] /= parity
        @alias[deficit] = @x[surplus]
        if @p_primary[surplus] == parity
          @p_primary[surplus] = Rational(1)
        else
          (@p_primary[surplus] < parity ? deficit_set : surplus_set) << surplus
        end
      end
    end

    def generate
      column = rand(@x.length)
      rand <= @p_primary[column] ? @x[column] : @alias[column]
    end
  end

end
