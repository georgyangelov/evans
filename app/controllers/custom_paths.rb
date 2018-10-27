module CustomPaths
  def redirect_path
    if Features.dashboard_enabled?
      dashboard_path
    else
      root_path
    end
  end

  def solution_path(solution)
    task_solution_path(solution.task, solution)
  end

  def solution_url(solution)
    task_solution_url(solution.task, solution)
  end

  def comment_path(comment)
    task_solution_url(comment.solution.task, comment.solution, anchor: "comment-#{comment.id}")
  end

  def comment_url(comment)
    task_solution_url(comment.solution.task, comment.solution, anchor: "comment-#{comment.id}")
  end
end
