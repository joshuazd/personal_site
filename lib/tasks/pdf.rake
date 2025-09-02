require "erb"
require "yaml"
require Rails.root.join("lib/latex_helpers")

namespace :pdf do
  desc "TODO"
  task :generate, [ :include_personal ] => :environment do |t, args|
    include_personal = args[:include_personal] == "true"

    @work = YAML.load_file("config/work.yaml")
    @info = YAML.load_file("config/info.yaml")
    @skills = YAML.load_file("config/skills.yaml")
    @secrets = if include_personal
      YAML.load_file("config/secrets.yaml")
    else
      {}
    end

    erb_file = Rails.root.join("app/latex/resume.tex.erb")
    template = ERB.new(File.read(erb_file))
    tex_output = template.result_with_hash(info: @info, work: @work, skills: @skills, secrets: @secrets, include_personal: include_personal, escape: LatexHelpers.method(:escape))

    tex_file = Rails.root.join("app/latex/resume.tex")
    File.write(tex_file, tex_output)

    Dir.chdir(Rails.root.join("app/latex")) do
      system("TEXINPUTS=#{Rails.root.join('app/latex/fonts/fontawesome//:')} pdflatex -output-directory=#{Rails.root.join('tmp')} #{tex_file}")
    end
  end
end
