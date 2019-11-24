
class C45
    
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

        @entropy_s ||= 0.0
        @entropy_s =  calculate_entropyS(@data_sheet)

        @ID3hash = calculate_column(@data_sheet.compact,Hash.new)

        output(@ID3hash)
    end

    def calculate_entropyS(sheet)
        temp_hash ||= Hash.new 
        for i in 1..(sheet.length - 1) do
            temp_s = sheet[i][sheet[i].length-1]
            if temp_hash.include?(temp_s)
                temp_hash[temp_s] += 1
            else 
                temp_hash[temp_s] = 1
            end
        end
        return calculate_entropy(temp_hash)
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

    def calculate_gain(entropyS,entropy,info)
        gain = entropyS.to_f - entropy
        return gain / info.to_f
    end

    def calculate_info(sheet,attribute)
        pos = sheet[0].find_index(attribute)
        temp_hash = Hash.new 
        for i in 1..(sheet.length - 1) do
            temp_temp = sheet[i][pos]
            if temp_hash.include?(temp_temp)
                temp_hash[temp_temp] += 1
            else 
                temp_hash[temp_temp] = 1
            end
        end
        return calculate_entropy(temp_hash)
    end


    def calculate_column(sheet,father_hash)


        if sheet[0].length == 2 
            return nil 
        end

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

        temp_entropy = calculate_entropyS(sheet)


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


        temp_array = hash.keys

        
        temp_array.each do |temp_attribute|
            temp = hash[temp_attribute][hash[temp_attribute].length - 1]
            hash[temp_attribute].pop
            hash[temp_attribute] << calculate_gain(temp_entropy,temp,calculate_info(sheet,temp_attribute))
        end


        father_hash ||= Hash.new 
        temp = max_hash(hash)
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
            temp_sheet = Marshal.load(Marshal.dump(sheet))
            p = calculate_column(split_sheet(temp_sheet,temp_attribute,temp),Hash.new)
            father_hash[temp_attribute] = p 
        end
        return father_hash
    end

    def split_sheet(sheet,attribute,father)
         temporary_array = Array.new 
         pos = sheet[0].find_index(father)
         sheet[0].delete(father)
         temporary_array << sheet[0]
         sheet.each do |sheet_line|
            if sheet_line.include?(attribute)
                 if pos != nil 
                    sheet_line.delete_at(pos)
                 end 
                 temporary_array << sheet_line
            end
        end

        return temporary_array
    end


    def max_hash(hash)
        temp_min = 0
        temp_name = nil 
        hash.each do |temp_key,temp_value|
            if temp_value[temp_value.length - 1] > temp_min
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
        print "#{start}"
        puts 
        @s += "\t"
        hash[start].each do |element|
            
            if hash[element].class == Hash.new.class

                print "#{@s}#{element}"
                puts 
                @s += "\t"
                print @s

                output(hash[element])

                @s.chop!
            else
                print "#{@s}#{element}"
                puts "\t\t#{hash[element]}"
            end
        end
        @s.chop!
    end
end


