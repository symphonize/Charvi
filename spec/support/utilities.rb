def full_title(page_title)
  base_title = "Bill Your Time"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end