
module BYS
  $date_array = []

  def load_test
    file_input = File.open("weather.txt", "r")
    file_input.each do |each_line|
      each_line.chop!
      $date_array.push(each_line)
    end

    $date_array.each do |each_line|
      each_line = each_line.split(%r[,])
      #puts each_line.inspect
      if each_line[each_line.length - 1] == "yes"
        $p_yes ||= 0
        $p_yes += 1
      else
        if each_line[each_line.length - 1] == "no"
          $p_no ||= 0
          $p_no += 1
        end
      end
    end
  end

  def calculate_probability(p, flag)
    sum = 0.0
    if flag == "yes"
      sum = $p_yes
    else
      if flag == "no"
        sum = $p_no
      end
    end

    return (p.to_f / sum.to_f)
  end

  def get_probability(attribute, pos, flag)
    sum = 0

    for i in 1..($date_array.length - 1)
      each_line = $date_array[i].split(",")

      if each_line[pos] == attribute
        if each_line[each_line.length - 1] == flag
          sum += 1
        end
      end
    end

    return calculate_probability(sum, flag)
  end

  def input(s)
    s = s.split(%r[\s|,])

    array_yes = []
    array_no = []

    for i in 0...s.length
      array_yes.push(get_probability(s[i], i, "yes"))
      array_no.push(get_probability(s[i], i, "no"))
    end

    $yes = array_yes.inject(1) { |sum, x| sum * x }
    $no = array_no.inject(1) { |sum, x| sum * x }

    $yes *= ($p_yes.to_f / ($date_array.length - 1).to_f)
    $no *= ($p_no.to_f / ($date_array.length - 1).to_f)

    #puts array_yes.inspect
    #puts array_no.inspect
  end

  def main
    load_test
    #puts $date_array.inspect
    #puts $p_yes.inspect
    #puts $p_no.inspect
    puts "please input the attribute in a line"

    s = gets.chomp
    input(s)

    if $yes >= $no
      puts "yes"
    else
      puts "no"
    end
  end
end

include BYS
bys = BYS

bys.main
