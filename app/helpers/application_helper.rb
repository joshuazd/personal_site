module ApplicationHelper
  def skill_tag(name)
    content_tag(:span, name, class: "px-3 py-1 bg-gray-200 rounded-full text-sm")
  end

  def skill_section(title, skills)
    content_tag(:section, class: "mb-8") do
      concat(content_tag(:h3, title, class: "text-xl mb-4"))
      concat(
        content_tag(:div, class: "flex flex-wrap gap-3") do
          skills.each { |skill| concat(skill_tag(skill)) }
        end
      )
    end
  end

  def skills_data
    @skills_data ||= YAML.load_file(Rails.root.join("config", "skills.yaml")).transform_keys(&:to_sym)
  end
end
