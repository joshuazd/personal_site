class ResumeController < ApplicationController
  def download
    pdf_path = Rails.root.join("tmp/resume.pdf")

    unless File.exist?(pdf_path)
      logger.info "Generating pdf..."
      system("bundle exec rails 'pdf:generate[false]'")
    end

    send_file pdf_path,
              type: "application/pdf",
              disposition: "attachment",
              filename: "JoshuaZinkDuda_Resume.pdf"
  end
end
