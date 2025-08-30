class PagesController < ApplicationController
  def home
  end

  def about
  end

  def work
    @work_experiences = YAML.load_file(Rails.root.join("config/work.yaml"))
  end

  def contact
  end
end
