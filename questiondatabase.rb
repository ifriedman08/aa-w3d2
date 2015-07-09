require 'sqlite3'
require 'singleton'
require 'byebug'

require_relative 'util'
require_relative 'question'
require_relative 'question_follow'
require_relative 'user'
require_relative 'question_like'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    self.results_as_hash = true

    self.type_translation = true
  end

  def self.get_first_value(sql, *bind_vars)
    self.instance.get_first_row(sql, *bind_vars).values.first
  end
end


p Question.find_by_author_id(2)

p QuestionFollow.followers_for_question_id(1)
p QuestionFollow.followed_questions_for_user_id(1)
p QuestionLike::liked_questions_for_user_id(2)
p Question.find_by_id(2).num_likes
 p Question.most_liked(2)
tester = Question.new({
  'title' => 'This is a test save',
  'body' => 'this is the save body',
  'user_id' => 2
  })
tester.save
tester.title = 'Testing the update function'
tester.save
#  p User.find_by_id(2).authored_questions
#  p User.find_by_id(3).authored_replies
# # p QuestionLike.find_by_id(1)
