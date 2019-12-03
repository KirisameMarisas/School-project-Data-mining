
module K_Mean

  def input_integer
    s = gets.chomp
    return s.to_i
  end

  def input_coordinate
    s = gets.chomp
    s = s.split(" ")

    #puts s.inspect

    return s
  end

  def generate_random_center
    temp_array = []

    for i in 1..@dimension
      temp_array << rand(1.0..10.0)
    end

    return temp_array
  end

  def main
    input
    distribute
  end

  def calculate_distance(array1, array2)
    sum = 0
    for i in 1..@dimension
      sum += (array1[i].to_f - array2[i].to_f) ** 2
    end
    return sum
  end

  def array_delete(array, element)
    #puts array.inspect

    array.each do |floor|
      if (floor.class.name != Array.name)
        next
      end

      if (floor.length > 0)
        array_delete(floor, element)
        if (floor.delete(element) != nil)
          return
        end
      end
    end
    return array.delete(element)
  end

  def get_average(array)
    result_array = []
    #puts array.inspect
    if (array.length == 0)
      return nil
    end

    for j in 0...@input_array[array[0]].length
      sum_column = 0.0
      for i in 0...array.length
        sum_column += @input_array[array[i]][j].to_f
      end
      result_array << (sum_column / array.length)
    end
    return result_array
  end

  def distribute
    temp_array = []
    preview_array = []
    count_max = 1
    puts

    while (preview_array != @result && count_max < 99)
      preview_array = Marshal.load(Marshal.dump(@result))
      for i in 0...@input_array.length
        for j in 0...@centers
          temp_array << calculate_distance(@input_array[i], @centers_array[j])
        end

        array_delete(@result, i)
        #puts @result.inspect
        min_pos = temp_array.each_with_index.min[1]
        @result[min_pos] << i
        temp_array.clear
      end

      @result.delete(nil)
      puts
      puts @result.inspect
      #puts @result[2].length
      for i in 0...@centers
        @centers_array[i] = (temp = get_average(@result[i])) == nil ? @centers_array[i] : temp
      end

      puts @centers_array.inspect
      count_max += 1

    end
  end

  def input
    puts "Please input the number of input data"
    @n = input_integer
    puts "Please input the dimension of the data's element"
    @dimension = input_integer
    puts "Please input the number of centers"
    @centers = input_integer
    puts "Please input the datas"
    
    @centers_array = []
    @result = []

    for i in 1..@centers
      @result << []
    end

    for i in 1..@centers
      @centers_array << Marshal.load(Marshal.dump(generate_random_center))
    end

    @input_array = {}

    temp_array = []

    for i in 0...@n
      temp_array = input_coordinate

      @input_array[i] = Marshal.load(Marshal.dump(temp_array))
      temp_array.clear
    end

    #puts @input_array.inspect
    #puts @centers_array.inspect
  end
end

include K_Mean

KM = K_Mean

KM.main
