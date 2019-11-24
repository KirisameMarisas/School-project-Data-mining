
class ID3
    
    def input
        @data_sheet ||= Array.new 
        while true 
            temp_line = gets.chomp
            temp_line.lstrip!
            temp_line.rstrip!
            if temp_line.eql?('end')
                break
            end
            temp_line = temp_line.split(' ')
            @data_sheet << temp_line
        end

        temp_hash ||= Hash.new 
        for i in 1..(@data_sheet.length - 1) do
            temp_s = @data_sheet[i][@data_sheet[i].length-1]
            if temp_hash.include?(temp_s)
                temp_hash[temp_s] += 1
            else 
                temp_hash[temp_s] = 1
            end
        end

        @entropy_s ||= 0.0
        @entropy_s =  calculate_entropy(temp_hash)

        @ID3hash = calculate_column(@data_sheet,Hash.new)

        output(@ID3hash)
    end

    def calculate_atrribute(sheet,atrribute)
        temp_hash ||= Hash.new 
        sheet.each do |sheet_line|
            temp_s = sheet_line[sheet_line.length-1]
            if sheet_line.include?(atrribute) 
                if temp_hash.include?(temp_s)
                    temp_hash[temp_s] += 1
                else
                    temp_hash[temp_s] = 1
                end
            end
        end
        return calculate_entropy(temp_hash)
    end

    def calculate_column(sheet,father_hash)
        
        puts sheet.inspect
        
        if sheet[0].length == 2 
            return nil 
        end

        #puts sheet.inspect
        hash = Hash.new 
        attribute_hash = Hash.new 
        for j in 1..(sheet[0].length-2) do
           if !hash.include?(sheet[0][j]) 
                 hash[sheet[0][j]] = Array.new 
           end

            for i in 1..(sheet.length-1) do
                temp_s = sheet[i][j]
                if attribute_hash.include?(temp_s)
                    attribute_hash[temp_s][0] += 1
                else 
                    attribute_hash[temp_s] = Array.new
                    attribute_hash[temp_s][0] = 1
                    hash[sheet[0][j]] << temp_s
                end
            end
        end

        temp_array = attribute_hash.keys
        sum ||= 0.0

        temp_array.each do |temp|
            temp_temp = calculate_atrribute(sheet,temp)

            attribute_hash[temp] << temp_temp
         end

        temp_array_hash = hash.keys


        @total ||= @data_sheet.length - 1

        temp_array_hash.each do |temp_attribute_key|
            temp_attribute_list = hash[temp_attribute_key]
            
            
            sum = 0.0
            temp_attribute_list.each do |temp_attribute|
                temp_temp_array = attribute_hash[temp_attribute]

                sum += (attribute_hash[temp_attribute][0] / @total.to_f).to_f * attribute_hash[temp_attribute][1]

            end
            hash[temp_attribute_key].push(0.0)
            hash[temp_attribute_key][hash[temp_attribute_key].length-1] = sum 
        end



        father_hash ||= Hash.new 
        temp = min_hash(hash)
        hash[temp].pop()
        father_hash[temp] = hash[temp]


        father_hash[temp].each do |temp_temp|
            if attribute_hash[temp_temp][attribute_hash[temp_temp].length - 1] == 0.0 
                sheet.each do |sheet_line|
                    if sheet_line.include?(temp_temp)
                        father_hash[temp_temp] = sheet_line[sheet_line.length - 1]
                        break
                    end
                end
            end
        end
        

        father_hash[temp].each do |temp_attribute|
            if father_hash.include?(temp_attribute)
                next
            end

            p = Hash.new
            p = calculate_column(split_sheet(sheet,temp_attribute,temp),Hash.new)
            father_hash[temp_attribute] = p 
        end
        return father_hash
    end

    def split_sheet(sheet,attribute,father)
         temporary_array = Array.new 
         sheet[0].delete(father)
         temporary_array << sheet[0]
         sheet.each do |sheet_line|
            if sheet_line.include?(attribute)
                 sheet_line.delete(attribute)
                 temporary_array << sheet_line
            end
        end

        return temporary_array
    end


    def min_hash(hash)
        temp_min = 1
        temp_name = nil 
        hash.each do |temp_key,temp_value|
            if temp_value[temp_value.length - 1] < temp_min
                temp_name = temp_key
                temp_min = temp_value[temp_value.length - 1]
            end
        end
        return temp_name
    end

    def calculate_entropy(hash)
        temp_values = hash.values 
        temp_sum = (temp_values.inject(0,:+)).to_f

        sum = 0.0
        temp_values.each do |temp|
            temp = temp / temp_sum
            sum += (-1) * (temp * Math.log2(temp))
        end
        return sum 
    end

    def output(hash)
        start = hash.keys[0]
        @s ||= ""
        print "#{@s}#{start}\t"
        puts 
        hash[start].each do |element|
            
            if hash[element].class == Hash.new.class
                @s += "\t"
                print "#{@s}#{element}"
                puts 
                print @s
                output(hash[element])
            else
                print "#{@s}\t#{element}"
                puts "#{@s}\t#{hash[element]}"
            end
        end
        @s.chop!
    end
end


