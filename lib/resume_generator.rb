require "prawn"
require "yaml"

class ResumeGenerator
  def initialize
    @work = YAML.load_file("config/work.yaml")
    @info = YAML.load_file("config/info.yaml")
    @skills = YAML.load_file("config/skills.yaml")
  end

  def generate(output_path = "resume.pdf")
    Prawn::Document.generate(output_path) do |pdf|
      pdf.font_families.update(
        "LatinModernSans" => {
          normal: Rails.root.join("app/assets/fonts/latinmodern/lmsans10-regular.otf"),
          bold:   Rails.root.join("app/assets/fonts/latinmodern/lmsans10-bold.otf"),
          italic: Rails.root.join("app/assets/fonts/latinmodern/lmsans10-oblique.otf"),
          bold_italic: Rails.root.join("app/assets/fonts/latinmodern/lmsans10-boldoblique.otf")
        },
        "LatinModernRomanCaps" => {
          normal: Rails.root.join("app/assets/fonts/latinmodern/lmromancaps10-regular.otf")
        },
        "LatinModernRoman" => {
          normal: Rails.root.join("app/assets/fonts/latinmodern/lmroman10-regular.otf")
        }
      )

      pdf.font("LatinModernSans", style: :normal)
      # Header
      pdf.text @info["name"], size: 28, align: :right
      pdf.stroke_horizontal_rule
      pdf.move_down 10

      # Experience
      section_header(pdf, "Work Experience")
      @work.each do |job|
        timeline_entry(pdf, job)
      end

      # Skills
      section_header(pdf, "Skills")
      @skills.keys.each do |key|
        skill = @skills[key]
        skill_section(pdf, skill)
      end

      # Education
      edu = @info["education"]
      section_header(pdf, "Education")
      timeline_entry(pdf, edu)

      pdf.number_pages @info["linkedin"], {
        at: [ pdf.bounds.left, 0 ],
        align: :center,
        size: 9
      }
    end
  end

  def section_header(pdf, title)
    cursor_before = pdf.cursor
    box_height = 20
    bar_height = 4

    # Left column: bar centered
    pdf.bounding_box([ pdf.bounds.left, cursor_before ], width: 60, height: box_height) do
      y_center = pdf.bounds.top - (box_height / 2.0) + (bar_height / 2.0) - 2
      pdf.fill_color "000000"
      pdf.fill_rectangle [ pdf.bounds.left, y_center ], pdf.bounds.width, bar_height
    end

    # Right column: vertically center text in same box
    pdf.bounding_box([ pdf.bounds.left + 70, cursor_before ], width: pdf.bounds.width - 70, height: box_height) do
      pdf.text_box title,
        size: 18,
        valign: :center
    end

    pdf.move_down 8
  end

  def timeline_entry(pdf, info)
    cursor_before = pdf.cursor

    # Left column (dates/timeline)
    pdf.bounding_box([ pdf.bounds.left, cursor_before ], width: 60) do
      if info["timeframe"]
        pdf.text_box info["timeframe"].to_s,
          size: 12,
          align: :right,
          valign: :top
      end
    end

    # Right column (content)
    pdf.bounding_box([ pdf.bounds.left + 70, cursor_before ], width: pdf.bounds.width - 70) do
      parts = []
      parts << { text: info["role"], styles: [ :bold ] } if info["role"]
      parts << { text: info["degree"], styles: [ :bold ] } if info["degree"]
      parts << { text: " - " }
      parts << { text: info["company"], font: "LatinModernRomanCaps" } if info["company"]
      parts << { text: info["school"], font: "LatinModernRomanCaps" } if info["school"]
      pdf.formatted_text(parts, size: 12)

      pdf.move_down 4

      if info["projects"]
        info["projects"].each do |project|
          radius = 2
          x = pdf.bounds.left + 3
          y = pdf.cursor - radius - 3
          pdf.line_width(0.8)
          pdf.stroke_circle [ x, y ], radius
          pdf.indent(10) do
            pdf.text project["description"], size: 10
          end

          pdf.move_down 1
        end
      else
        pdf.text "Majors: #{info['major']}", size: 11
        pdf.text "Minor: #{info['minor']}", size: 11
      end

      pdf.move_down 4
    end
  end
end

def skill_section(pdf, skill)
  cursor_before = pdf.cursor

  pdf.bounding_box([ pdf.bounds.left + 70, cursor_before ], width: pdf.bounds.width - 70) do
    pdf.text skill["title"], style: :bold
    pdf.indent(10) do
      pdf.text skill["skills"].join(", "), size: 10
    end
  end
  pdf.move_down 2
end
