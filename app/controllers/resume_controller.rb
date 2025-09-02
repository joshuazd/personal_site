class ResumeController < ApplicationController
  def download
    pdf_path = Rails.root.join("tmp/resume.pdf")

    unless File.exist?(pdf_path)

      logger.info "Generating pdf..."
      Rails.application.load_tasks
      Rake::Task["pdf:generate"].reenable
      Rake::Task["pdf:generate"].invoke(false)
    end

    send_file pdf_path,
              type: "application/pdf",
              disposition: "attachment",
              filename: "JoshuaZinkDuda_Resume.pdf"
  end
end
