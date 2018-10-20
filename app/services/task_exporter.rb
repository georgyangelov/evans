require 'zip'

class TaskExporter
  def initialize(task)
    @task = task
  end

  def to_zip_io
    solutions = @task.solutions.includes(:user, :revisions)

    zip_io = Zip::OutputStream.write_buffer do |zip|
      solutions.each do |solution|
        zip.put_next_entry("#{solution.user.faculty_number}/info.md")
        zip.write(solution_info(solution))

        zip.put_next_entry("#{solution.user.faculty_number}/solution.#{Language.extension}")
        zip.write(solution.last_revision.code)
      end
    end

    zip_io.rewind
    zip_io.sysread
  end

  private

  def solution_info(solution)
    <<~MARKDOWN
      # User
      Name:  #{solution.user.full_name}
      FN:    #{solution.user.faculty_number}
      Email: #{solution.user.email}

      # Solution
      Revisions: #{solution.revisions.size}
      Last revision date: #{solution.last_revision.created_at}
    MARKDOWN
  end
end
