class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :revision

  attr_protected :user_id, :solution_id

  validates :body, presence: true

  delegate :solution, to: :revision
  delegate :task, :task_name, to: :solution

  scope :inline, -> { where.not line_number: nil }
  scope :non_inline, -> { where line_number: nil }

  def editable_by?(user)
    self.user == user or user.try(:admin?)
  end

  def inline?
    line_number != nil
  end

  def user_name
    user.name
  end
end
