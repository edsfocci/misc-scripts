require 'nokogiri'
require 'open-uri'
require 'pry'

base_url = "https://www.airbnb.com"
ctry = {"vietnam" => 24,"cambodia" => 4,"thailand" => 56, "panama" => 24, "nicaruagua" => 12, "costarica" => 56}

## grab all broad links to popular destinations
output = File::open("airbnb_data.txt", "w")
output << '['

ctry.each do |k,v|
    (1..v).each do |pg|
        url = "#{base_url}/s/#{k}?room_types%5B%5D=Entire+home%2Fapt&page=#{pg}"
        Nokogiri::HTML(open(url)).css(".target-details.block-link").each do |box|
            details_url = "#{base_url}#{box["href"]}"
            inner_pg_data = Nokogiri::HTML(open(details_url))
            name = inner_pg_data.css('#listing_name').text.strip
            city = inner_pg_data.css('#display-address > a:nth-child(1)').text.strip
            price = inner_pg_data.css('#price_amount').text[/\d+/]
            beds = inner_pg_data.css('#summary > div > div > div.col-8 > div > div:nth-child(2) > div.col-9 > div > div:nth-child(4)').text[/\d+/]
            bedrooms = inner_pg_data.css('#summary > div > div > div.col-8 > div > div:nth-child(2) > div.col-9 > div > div:nth-child(3)').text[/\d+/]
            capacity = inner_pg_data.css('#summary > div > div > div.col-8 > div > div:nth-child(2) > div.col-9 > div > div:nth-child(2)').text[/\d+/]
            output << "{'country'   : '#{k}',
                        'city'      : '#{city}',
                        'name'      : '#{name}',
                        'price'     : #{price},
                        'bedrooms'  : #{bedrooms},
                        'beds'      : #{beds},
                        'capacity'  : #{capacity}
                    },"
        end
        puts "I just scraped the F%!@* out of #{k} - pg #{pg}"
        sleep 1.0 + rand # sleep to avoid hitting the server too frequently
    end
end

output << "]"
output.close
puts "Done! ^_^"
