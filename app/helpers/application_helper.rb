module ApplicationHelper
  def skill_tag(name, level = :skilled)
    colors = { skilled: "bg-indigo-200", familiar: "bg-indigo-50" }
    content_tag(:span, name, class: "px-3 py-1 #{colors[level]} rounded-full text-sm")
  end

  def skill_list(skills, title = nil, level = :skilled, styles = "")
    content_tag(:div, class: "flex flex-wrap gap-3 #{styles}") do
      if title
        concat(content_tag(:span, title, class: "font-semibold text-gray-700 self-center mr-2"))
      end
      skills.each { |skill| concat(skill_tag(skill, level)) }
    end
  end

  def skill_section(title, skills)
    content_tag(:section, class: "mb-8") do
      concat(content_tag(:h3, title, class: "text-xl mb-4"))
      if skills.kind_of?(Array)
        concat(skill_list(skills))
      else
        concat(skill_list(skills["skilled"], "Skilled in", :skilled, "mb-3"))
        concat(skill_list(skills["familiar"], "Familiar with", :familiar))
      end
    end
  end

  def skills_data
    @skills_data ||= YAML.load_file(Rails.root.join("config", "skills.yaml")).transform_keys(&:to_sym)
  end
end
