require 'nokogiri'
require 'open-uri'
# require 'pry'

base_url = "http://www.travelmob.com/vacation-rentals"
ctry = {"vietnam" => 26,"cambodia" => 7,"thailand" => 125}

## grab all broad links to popular destinations
output = File::open("travelmob_data.txt", "w")
output << '['

ctry.each do |k,v|
    (1..v).each do |pg|
        url = "#{base_url}/#{k}?page=#{pg.to_s}"
        Nokogiri::HTML(open(url)).css(".space.row").each do |box|
            name = box.css('h4').text
            city = box.css('[itemprop="addressRegion"]').text
            price = box.css('.price').text
            bedrooms = box.css('.bedrooms').text
            capacity = box.css('.accommodates').text
            output << "{'country'   : '#{k}',
                        'city'      : '#{city}',
                        'name'      : '#{name}',
                        'price'     : #{price},
                        'bedrooms'  : #{bedrooms},
                        'capacity'  : #{capacity}
                    },"
        end
        puts "I just scraped the F%!@* out of #{k} - pg #{pg}"
        sleep 1.0 + rand # sleep to avoid hitting the server too frequently
    end
end

output << "]"
output.close
puts "Done! ^____^ "
