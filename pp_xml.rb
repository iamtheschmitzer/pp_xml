
matching_el = /<[^>]*:?#{ARGV[0]}[^>]*>/

$xml_declaration = /^<\?xml version/
$solo_element    = /<[^>]+\/$/
$full_element    = /<[^>]+>.*<\/[^>]+$/
$end_element     = /^<\/[^>]+$/

def xml_pp line, indent = 0
  return if line.nil? || line.empty?

  first,rest = line.split(/>/, 2)
  
  # If element contains inline content
  if rest.nil? || rest[0,1] != '<'
    # Expand first to next element
    more_first,rest = rest.split(/>/, 2)
    first += '>' + more_first unless more_first.nil?
  end

  if first =~ $end_element
    indent -= 1
  end
  puts "  "*indent + first + '>'

  if first =~ $xml_declaration
    xml_pp rest, indent
  elsif first =~ $solo_element
    xml_pp rest, indent
  elsif first =~ $full_element
    xml_pp rest, indent
  elsif first =~ $end_element
    xml_pp rest, indent
  else
    xml_pp rest, indent + 1
  end
end

$stdin.each_line do |line|
  if line =~ $xml_declaration
    if line =~ matching_el
      xml_pp line.chomp.sub(/\|#\]$/, '')
    end
  end
end

