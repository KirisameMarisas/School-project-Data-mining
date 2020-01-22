
module K_center
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

    @input_array = {}

    temp_array = []

    for i in 0...@n
      temp_array = input_coordinate

      @input_array[i] = Marshal.load(Marshal.dump(temp_array))
      temp_array.clear
    end

    for i in 1..@centers
      @centers_array << Marshal.load(Marshal.dump(@input_array[i]))
    end

    #puts @input_array.inspect
    #puts @centers_array.inspect
  end

  def calculate_distance(array1, array2)
    sum = 0
    for i in 1..@dimension
      sum += (array1[i].to_f - array2[i].to_f).abs
    end
    return sum
  end

  def array_delete(array, element)
    #puts array.inspect
    array.delete(element)
    array.each { |e| array_delete(e, element) if e.is_a?(Array) }
    #array.delete([])
  end

  def calculate_cost
    sum = 0
    temp_array = []

    for i in 0...@centers
      each_array = @result[i]

      each_array.each do |element|
        temp_array << calculate_distance(@input_array[element], @centers_array[i])
      end

      temp_sum = temp_array.inject(0) { |temp_sum, x| temp_sum + x }

      sum += temp_sum
      temp_array.clear
    end

    return sum
  end

  def distribute
    temp_array = []
    preview_array = []
    count_max = 1
    puts

    preview_center = 0

    preview_cost = calculate_cost()

    while (preview_array != @result && count_max < 99)
      preview_array = Marshal.load(Marshal.dump(@result))

      for p in (@centers)...@input_array.length
        for q in 0...@centers
          preview_center = @centers_array[q]
          @centers_array[q] = Marshal.load(Marshal.dump(@input_array[p]))
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
          #puts
          #puts @result.inspect
          
          current_cost = calculate_cost()
          if (current_cost>preview_cost)
            @centers_array[q] = preview_center
          end
          #puts @centers_array.inspect
          count_max += 1
        end
        puts 
        puts @result.inspect
        puts @centers_array.inspect
        puts p 
      end
      puts 
    end
  end

  def input_integer
    s = gets.chomp
    return s.to_i
  end

  def main
    input
    distribute
  end

  def input_coordinate
    s = gets.chomp
    s = s.split(" ")

    #puts s.inspect

    return s
  end
end

include K_center

KC = K_center

KC.main
