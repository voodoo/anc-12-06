module PostsHelper
  def region_color_classes(region)
    case region
    when "Mediterranean"
      "bg-blue-50 text-blue-700 ring-blue-700/10"
    when "Mesopotamia"
      "bg-amber-50 text-amber-700 ring-amber-700/10"
    when "Egypt"
      "bg-yellow-50 text-yellow-700 ring-yellow-700/10"
    when "Persia"
      "bg-purple-50 text-purple-700 ring-purple-700/10"
    when "Indian Subcontinent"
      "bg-orange-50 text-orange-700 ring-orange-700/10"
    when "East Asia"
      "bg-red-50 text-red-700 ring-red-700/10"
    when "Northern Europe"
      "bg-emerald-50 text-emerald-700 ring-emerald-700/10"
    when "Sub-Saharan Africa"
      "bg-green-50 text-green-700 ring-green-700/10"
    when "North America"
      "bg-cyan-50 text-cyan-700 ring-cyan-700/10"
    when "South America"
      "bg-lime-50 text-lime-700 ring-lime-700/10"
    when "Alaska"
      "bg-indigo-50 text-indigo-700 ring-indigo-700/10"
    else
      "bg-gray-50 text-gray-700 ring-gray-700/10"
    end
  end
end
