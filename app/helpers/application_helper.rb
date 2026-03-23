module ApplicationHelper
  def skill_tag(name, level = :skilled)
    css_class = level == :familiar ? "skill-tag skill-tag--familiar" : "skill-tag skill-tag--skilled"
    content_tag(:span, name, class: css_class)
  end

  def skill_list(skills, title = nil, level = :skilled)
    content_tag(:div, class: "skill-list") do
      if title
        concat(content_tag(:div, title, class: "skill-list-label"))
      end
      concat(
        content_tag(:div, class: "skill-tags") do
          skills.each { |skill| concat(skill_tag(skill, level)) }
        end
      )
    end
  end

  def skill_section(title, skills)
    content_tag(:section, class: "skill-section") do
      concat(content_tag(:h3, title))
      if skills.kind_of?(Array)
        concat(skill_list(skills))
      else
        concat(skill_list(skills["skilled"], "Skilled in", :skilled))
        concat(skill_list(skills["familiar"], "Familiar with", :familiar))
      end
    end
  end

  def skills_data
    @skills_data ||= YAML.load_file(Rails.root.join("config", "skills.yaml")).transform_keys(&:to_sym)
  end
end
