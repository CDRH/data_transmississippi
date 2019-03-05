class FileCsv
  def row_to_solr(doc, headers, row)
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
    return doc
  end

  # TODO this is a temporary fix because datura is returning "docs" instead of "doc"
  # but once datura is fixed and this repo is bumped, transform_solr override here can be removed
  def transform_solr
    puts "transforming #{self.filename}"
    solr_doc = Nokogiri::XML("<add></add>")
    @csv.each do |row|
      if !row.header_row?
        doc = Nokogiri::XML::Node.new("doc", solr_doc)
        # row_to_solr should return an XML::Node object with children
        doc = row_to_solr(doc, @csv.headers, row)
        solr_doc.at_css("add").add_child(doc)
      end
    end
    # Uncomment to debug
    # puts solr_doc.root.to_xml
    if @options["output"]
      filepath = "#{@out_solr}/#{self.filename(false)}.xml"
      # puts "output #{@out_solr}"
      File.open(filepath, "w") { |f| f.write(solr_doc.root.to_xml) }
    end
    return { "doc" => solr_doc.root.to_xml }
  end


end
