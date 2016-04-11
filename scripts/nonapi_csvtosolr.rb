require 'csv'
require 'nokogiri'

def csv_to_solr(file_path, options)
  data = read_csv(file_path)
  file_name = File.basename(file_path)
  solr_doc = Nokogiri::XML("<add></add>")
  data.each do |row|
    if !row.header_row?
      doc = Nokogiri::XML::Node.new "doc", solr_doc
      ############################
      # non-api transmississippi #
      ############################
      doc.add_child("<field name='id'>#{row['id']}</field>") if row['id']
      doc.add_child("<field name='title'>#{row['title']}</field>") if row['title']
      doc.add_child("<field name='category'>#{row['category']}</field>") if row['category']
      doc.add_child("<field name='sub_category'>#{row['sub_category']}</field>") if row['sub_category']
      doc.add_child("<field name='caption'>#{row['caption']}</field>") if row['caption']
      doc.add_child("<field name='location'>#{row['location']}</field>") if row['location']
      doc.add_child("<field name='pages'>#{row['pages']}</field>") if row['pages']
      doc.add_child("<field name='description'>#{row['description']}</field>") if row['description']
      doc.add_child("<field name='keywords'>#{row['keywords']}</field>") if row['keywords']
      doc.add_child("<field name='date'>#{row['date']}</field>") if row['date']
      doc.add_child("<field name='dateNormalized'>#{row['dateNormalized']}</field>") if row['dateNormalized']
      doc.add_child("<field name='medium'>#{row['medium']}</field>") if row['medium']
      doc.add_child("<field name='size'>#{row['size']}</field>") if row['size']
      doc.add_child("<field name='creator'>#{row['creator']}</field>") if row['creator']
      doc.add_child("<field name='collection'>#{row['collection']}</field>") if row['collection']
      
      solr_doc.at_css("add").add_child(doc)
    end
  end
  # Uncomment to write files to inspect
  # File.open(file_name, "w") { |file| file.write(solr_doc.root.to_xml) }
  return solr_doc.root.to_xml
end



###############
#   HELPERS   #
###############
# Ignore these if you are just changing the solr output

# this pads results so 10 => "010", 4 => "004", etc
# because this is how the pages are identified in jpg form
def get_page_ext(page)
  if page
    return page.rjust(3, "0")
  else
    return "001"
  end
end

def make_it_sortable(title)
  # a, an, the moved to the end, lowercased
  title = title.downcase
  front = title.slice!(/^a |^the |^an /)
  if front
    front.strip!
    return "#{title}, #{front}"
  else
    return title
  end
end

def normalize_date(date)
  begin
    return Time.new(date).strftime("%Y-%m-%dT%H:%M:%SZ")
  rescue e
    puts "There was an error with a date #{date}"
  end
end

def read_csv(file_path)
  data = CSV.read(file_path, {
    :encoding => "iso-8859-1",  # apparently this is necessary with excel docs
    :headers => true,           # there are headers in the csv file
    :return_headers => true     # should be accessible with csv object
    })
  return data
end

